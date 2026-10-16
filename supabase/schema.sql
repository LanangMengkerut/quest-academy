-- Quest Academy — dynamic schema (Supabase Postgres)
-- Apply with the Management API query endpoint or the SQL editor.
-- Safe to re-run: tables use IF NOT EXISTS, policies are dropped first,
-- functions use CREATE OR REPLACE.

create extension if not exists pgcrypto;

-- ============ tables ============

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text unique not null,
  avatar text not null default '🧙',
  xp int not null default 0,
  streak int not null default 0,
  best_streak int not null default 0,
  plays int not null default 0,
  wins int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.courses (
  id text primary key,
  title text not null,
  tagline text not null default '',
  icon text not null default '📚',
  boss_icon text not null default '👾',
  boss_name text not null default 'BOSS',
  color text not null default 'cyan',
  sort_order int not null default 0
);

create table if not exists public.stages (
  id text primary key,
  course_id text not null references public.courses (id) on delete cascade,
  title text not null,
  summary text not null default '',
  source_url text,
  source_label text,
  sort_order int not null default 0
);

create table if not exists public.sections (
  id text primary key,
  stage_id text not null references public.stages (id) on delete cascade,
  title text not null,
  body text not null default '',
  sort_order int not null default 0
);

create table if not exists public.questions (
  id text primary key,
  stage_id text not null references public.stages (id) on delete cascade,
  section_id text references public.sections (id) on delete set null,
  kind text not null check (kind in ('checkpoint', 'battle')),
  question text not null,
  options jsonb not null,
  correct_index int not null,
  explanation text not null default '',
  sort_order int not null default 0
);

create table if not exists public.stage_progress (
  user_id uuid not null references public.profiles (id) on delete cascade,
  stage_id text not null references public.stages (id) on delete cascade,
  best_score int not null default 0,
  read_at timestamptz,
  checkpoint_passed boolean not null default false,
  primary key (user_id, stage_id)
);

create table if not exists public.section_progress (
  user_id uuid not null references public.profiles (id) on delete cascade,
  section_id text not null references public.sections (id) on delete cascade,
  read_at timestamptz not null default now(),
  primary key (user_id, section_id)
);

create table if not exists public.attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  stage_id text not null references public.stages (id) on delete cascade,
  score int not null,
  correct_count int not null,
  total int not null,
  xp_earned int not null,
  finished_at timestamptz not null default now()
);

create table if not exists public.user_badges (
  user_id uuid not null references public.profiles (id) on delete cascade,
  badge_id text not null,
  earned_at timestamptz not null default now(),
  primary key (user_id, badge_id)
);

create table if not exists public.battle_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  stage_id text not null references public.stages (id) on delete cascade,
  kind text not null check (kind in ('checkpoint', 'battle')),
  question_ids text[] not null,
  option_orders jsonb not null,
  current_index int not null default 0,
  correct_count int not null default 0,
  player_hp int not null default 3,
  status text not null default 'active',
  created_at timestamptz not null default now()
);

-- ============ row level security ============

alter table public.profiles enable row level security;
alter table public.courses enable row level security;
alter table public.stages enable row level security;
alter table public.sections enable row level security;
alter table public.questions enable row level security;
alter table public.stage_progress enable row level security;
alter table public.section_progress enable row level security;
alter table public.attempts enable row level security;
alter table public.user_badges enable row level security;
alter table public.battle_sessions enable row level security;

drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select to anon, authenticated using (true);
drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own on public.profiles
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

drop policy if exists courses_select on public.courses;
create policy courses_select on public.courses
  for select to anon, authenticated using (true);

drop policy if exists stages_select on public.stages;
create policy stages_select on public.stages
  for select to anon, authenticated using (true);

drop policy if exists sections_select on public.sections;
create policy sections_select on public.sections
  for select to authenticated using (true);

-- questions: deliberately no select policy. Correct answers and
-- explanations are only reachable through the RPC functions below.
-- stage_progress / section_progress / attempts / user_badges: own rows.
drop policy if exists stage_progress_select on public.stage_progress;
create policy stage_progress_select on public.stage_progress
  for select to authenticated using (user_id = auth.uid());
drop policy if exists section_progress_select on public.section_progress;
create policy section_progress_select on public.section_progress
  for select to authenticated using (user_id = auth.uid());
drop policy if exists attempts_select on public.attempts;
create policy attempts_select on public.attempts
  for select to authenticated using (user_id = auth.uid());
drop policy if exists user_badges_select on public.user_badges;
create policy user_badges_select on public.user_badges
  for select to authenticated using (user_id = auth.uid());
-- battle_sessions: no direct access at all (RPC only).

-- ============ public stats views (counts only, no answers) ============

create or replace view public.course_stats as
select
  c.id as course_id,
  (select count(*) from public.stages s where s.course_id = c.id) as stages,
  (select count(*) from public.questions q
     join public.stages s on s.id = q.stage_id
    where s.course_id = c.id and q.kind = 'battle') as battle_questions
from public.courses c;

create or replace view public.checkpoint_stats as
select stage_id, count(*) as n
from public.questions
where kind = 'checkpoint'
group by stage_id;

create or replace view public.weekly_xp as
select user_id, sum(xp_earned)::int as xp_week
from public.attempts
where finished_at >= now() - interval '7 days'
group by user_id;

grant select on public.course_stats, public.checkpoint_stats to anon, authenticated;
grant select on public.weekly_xp to authenticated;

-- ============ profile creation on signup ============

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'username', ''),
      split_part(new.email, '@', 1)
    )
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============ internal helpers ============

create or replace function public.grant_badge(p_user uuid, p_badge text)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  cnt int;
begin
  insert into public.user_badges (user_id, badge_id)
  values (p_user, p_badge)
  on conflict do nothing;
  get diagnostics cnt = row_count;
  return coalesce(cnt, 0) > 0;
end;
$$;
revoke execute on function public.grant_badge(uuid, text) from public, anon, authenticated;

-- ============ RPC: progress marks ============

create or replace function public.mark_stage_read(p_stage_id text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  read_count int;
begin
  if uid is null then raise exception 'Harus login'; end if;
  insert into public.stage_progress (user_id, stage_id, read_at)
  values (uid, p_stage_id, now())
  on conflict (user_id, stage_id)
  do update set read_at = coalesce(public.stage_progress.read_at, now());
  select count(*) into read_count
  from public.stage_progress
  where user_id = uid and read_at is not null;
  if read_count >= 3 then
    perform public.grant_badge(uid, 'scholar');
  end if;
end;
$$;
grant execute on function public.mark_stage_read(text) to authenticated;

create or replace function public.mark_section_read(p_section_id text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
begin
  if uid is null then raise exception 'Harus login'; end if;
  insert into public.section_progress (user_id, section_id)
  values (uid, p_section_id)
  on conflict do nothing;
end;
$$;
grant execute on function public.mark_section_read(text) to authenticated;

-- ============ RPC: quiz sessions ============

create or replace function public.start_session(p_stage_id text, p_kind text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  stage_row public.stages;
  course_row public.courses;
  qids text[];
  orders jsonb := '{}'::jsonb;
  questions_out jsonb := '[]'::jsonb;
  q record;
  perm int[];
  displayed jsonb;
  session_id uuid;
  has_checkpoint boolean;
  passed boolean;
begin
  if uid is null then raise exception 'Harus login'; end if;
  if p_kind not in ('battle', 'checkpoint') then
    raise exception 'Jenis sesi tidak dikenal';
  end if;

  select * into stage_row from public.stages where id = p_stage_id;
  if stage_row.id is null then raise exception 'Stage tidak ditemukan'; end if;
  select * into course_row from public.courses where id = stage_row.course_id;

  if p_kind = 'battle' then
    select exists(
      select 1 from public.questions
      where stage_id = p_stage_id and kind = 'checkpoint'
    ) into has_checkpoint;
    if has_checkpoint then
      select checkpoint_passed into passed
      from public.stage_progress
      where user_id = uid and stage_id = p_stage_id;
      if not coalesce(passed, false) then
        raise exception 'Checkpoint belum lulus';
      end if;
    end if;
  end if;

  select array_agg(id order by sort_order) into qids
  from public.questions
  where stage_id = p_stage_id and kind = p_kind;
  if qids is null then
    raise exception 'Belum ada soal untuk sesi ini';
  end if;

  for q in
    select * from public.questions
    where stage_id = p_stage_id and kind = p_kind
    order by sort_order
  loop
    select array_agg(i order by random()) into perm
    from generate_series(0, jsonb_array_length(q.options) - 1) as i;
    orders := orders || jsonb_build_object(q.id, to_jsonb(perm));
    select jsonb_agg(q.options -> p order by ord)
    into displayed
    from unnest(perm) with ordinality as t(p, ord);
    questions_out := questions_out || jsonb_build_array(jsonb_build_object(
      'id', q.id,
      'q', q.question,
      'options', displayed
    ));
  end loop;

  insert into public.battle_sessions
    (user_id, stage_id, kind, question_ids, option_orders)
  values (uid, p_stage_id, p_kind, qids, orders)
  returning id into session_id;

  return jsonb_build_object(
    'session_id', session_id,
    'stage_title', stage_row.title,
    'course_id', stage_row.course_id,
    'boss_icon', course_row.boss_icon,
    'boss_name', course_row.boss_name,
    'questions', questions_out
  );
end;
$$;
grant execute on function public.start_session(text, text) to authenticated;

create or replace function public.answer_question(
  p_session_id uuid,
  p_question_id text,
  p_option int
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  sess public.battle_sessions;
  q public.questions;
  total int;
  perm jsonb;
  chosen_original int;
  correct_pos int;
  is_correct boolean;
  new_correct int;
  new_hp int;
  new_index int;
  finished boolean;
  score int;
  prev_best int;
  base_xp int;
  v_xp int;
  is_win boolean;
  prof public.profiles;
  new_badges text[] := '{}';
begin
  if uid is null then raise exception 'Harus login'; end if;

  select * into sess from public.battle_sessions
  where id = p_session_id and user_id = uid and status = 'active';
  if sess.id is null then raise exception 'Sesi tidak aktif'; end if;

  total := array_length(sess.question_ids, 1);
  if sess.question_ids[sess.current_index + 1] <> p_question_id then
    raise exception 'Soal tidak sesuai urutan sesi';
  end if;

  select * into q from public.questions where id = p_question_id;
  perm := sess.option_orders -> p_question_id;
  chosen_original := (perm ->> p_option)::int;
  is_correct := chosen_original = q.correct_index;
  select pos - 1 into correct_pos
  from jsonb_array_elements(perm) with ordinality as t(val, pos)
  where (val #>> '{}')::int = q.correct_index;

  new_correct := sess.correct_count + (case when is_correct then 1 else 0 end);
  new_hp := sess.player_hp - (case when is_correct then 0 else 1 end);
  new_index := sess.current_index + 1;
  finished := new_index >= total or new_hp <= 0;

  -- streak lives on the profile and spans sessions
  if is_correct then
    update public.profiles
    set streak = streak + 1,
        best_streak = greatest(best_streak, streak + 1)
    where id = uid;
    if (select streak from public.profiles where id = uid) >= 3 then
      if public.grant_badge(uid, 'streak3') then
        new_badges := array_append(new_badges, 'streak3');
      end if;
    end if;
  else
    update public.profiles set streak = 0 where id = uid;
  end if;

  update public.battle_sessions
  set correct_count = new_correct,
      player_hp = new_hp,
      current_index = new_index,
      status = case when finished then 'finished' else 'active' end
  where id = sess.id;

  if not finished then
    return jsonb_build_object(
      'correct', is_correct,
      'correct_option', correct_pos,
      'explanation', q.explanation,
      'answered', new_index,
      'total', total,
      'correct_count', new_correct,
      'player_hp', new_hp,
      'finished', false,
      'new_badges', to_jsonb(new_badges)
    );
  end if;

  if sess.kind = 'checkpoint' then
    if new_correct = total then
      insert into public.stage_progress (user_id, stage_id, checkpoint_passed)
      values (uid, sess.stage_id, true)
      on conflict (user_id, stage_id)
      do update set checkpoint_passed = true;
    end if;
    return jsonb_build_object(
      'correct', is_correct,
      'correct_option', correct_pos,
      'explanation', q.explanation,
      'answered', new_index,
      'total', total,
      'correct_count', new_correct,
      'player_hp', new_hp,
      'finished', true,
      'passed', new_correct = total,
      'new_badges', to_jsonb(new_badges)
    );
  end if;

  -- battle finalize
  score := round(100.0 * new_correct / total)::int;
  select best_score into prev_best
  from public.stage_progress
  where user_id = uid and stage_id = sess.stage_id;
  prev_best := coalesce(prev_best, 0);

  base_xp := new_correct * 20
    + (case when score >= 60 then 10 else 0 end)
    + (case when score = 100 then 50 else 0 end);
  if prev_best = 0 or score > prev_best then
    v_xp := base_xp;
  else
    v_xp := round(base_xp * 0.1)::int;
  end if;
  is_win := score >= 60;

  insert into public.attempts
    (user_id, stage_id, score, correct_count, total, xp_earned)
  values (uid, sess.stage_id, score, new_correct, total, v_xp);

  insert into public.stage_progress (user_id, stage_id, best_score)
  values (uid, sess.stage_id, score)
  on conflict (user_id, stage_id)
  do update set best_score = greatest(public.stage_progress.best_score, score);

  update public.profiles
  set xp = profiles.xp + v_xp,
      plays = profiles.plays + 1,
      wins = profiles.wins + (case when is_win then 1 else 0 end)
  where id = uid
  returning * into prof;

  if is_win and public.grant_badge(uid, 'first_blood') then
    new_badges := array_append(new_badges, 'first_blood');
  end if;
  if score = 100 and public.grant_badge(uid, 'perfect') then
    new_badges := array_append(new_badges, 'perfect');
  end if;
  if prof.wins >= 5 and public.grant_badge(uid, 'warrior') then
    new_badges := array_append(new_badges, 'warrior');
  end if;
  if prof.plays >= 10 and public.grant_badge(uid, 'marathon') then
    new_badges := array_append(new_badges, 'marathon');
  end if;

  return jsonb_build_object(
    'correct', is_correct,
    'correct_option', correct_pos,
    'explanation', q.explanation,
    'answered', new_index,
    'total', total,
    'correct_count', new_correct,
    'player_hp', new_hp,
    'finished', true,
    'score', score,
    'xp_earned', v_xp,
    'prev_best', prev_best,
    'new_badges', to_jsonb(new_badges)
  );
end;
$$;
grant execute on function public.answer_question(uuid, text, int) to authenticated;
