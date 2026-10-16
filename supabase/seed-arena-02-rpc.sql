-- =====================================================================
-- Arena PvP — RPC (SECURITY DEFINER, pola sama seperti start_session /
-- answer_question di schema.sql). Kunci jawaban TIDAK PERNAH ke browser:
-- opsi diacak per pemain saat room dimulai, pengecekan di server.
-- Idempotent: CREATE OR REPLACE, aman dijalankan ulang.
-- Fase 1: mode battle. Mode race ditolak eksplisit sampai Fase 2.
-- =====================================================================

-- ---------- helper internal: selesaikan room + catat statistik ----------
-- Tidak di-grant ke siapa pun: hanya dipanggil dari RPC lain.
create or replace function public.arena_finish_room(
  p_room_id uuid,
  p_winner_id uuid,
  p_draw boolean
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_mode text;
  r record;
begin
  select mode into v_mode from public.arena_rooms where id = p_room_id;
  if v_mode is null then return; end if;

  for r in
    select user_id from public.arena_players where room_id = p_room_id
  loop
    insert into public.arena_stats (user_id, mode)
    values (r.user_id, v_mode)
    on conflict (user_id, mode) do nothing;

    update public.arena_stats
    set played = played + 1,
        wins = wins + case
          when not p_draw and r.user_id = p_winner_id then 1 else 0 end,
        losses = losses + case
          when not p_draw and r.user_id <> p_winner_id then 1 else 0 end,
        draws = draws + case when p_draw then 1 else 0 end,
        updated_at = now()
    where user_id = r.user_id and mode = v_mode;
  end loop;

  update public.arena_players
  set status = 'finished', finished_at = now()
  where room_id = p_room_id and status = 'playing';

  update public.arena_rooms
  set status = 'finished', winner_id = p_winner_id, finished_at = now()
  where id = p_room_id;
end;
$$;

-- ---------- 1. buat room ----------
create or replace function public.arena_create_room(p_mode text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  v_code text;
  v_room_id uuid;
  alphabet constant text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  i int;
begin
  if uid is null then raise exception 'Harus login'; end if;
  if p_mode = 'race' then raise exception 'Mode race segera hadir'; end if;
  if p_mode <> 'battle' then raise exception 'Mode tidak dikenal'; end if;

  loop
    v_code := '';
    for i in 1..6 loop
      v_code := v_code
        || substr(alphabet, (random() * (length(alphabet) - 1))::int + 1, 1);
    end loop;
    exit when not exists(
      select 1 from public.arena_rooms where code = v_code);
  end loop;

  insert into public.arena_rooms (code, mode, created_by)
  values (v_code, p_mode, uid)
  returning id into v_room_id;

  insert into public.arena_players (room_id, user_id, is_host)
  values (v_room_id, uid, true);

  return jsonb_build_object('room_id', v_room_id, 'code', v_code);
end;
$$;
grant execute on function public.arena_create_room(text) to authenticated;

-- ---------- 2. gabung via kode ----------
create or replace function public.arena_join_room(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  room public.arena_rooms;
  cnt int;
  maxp int;
begin
  if uid is null then raise exception 'Harus login'; end if;

  select * into room from public.arena_rooms
  where code = upper(trim(p_code));
  if room.id is null then raise exception 'Kode room tidak ditemukan'; end if;
  if room.status <> 'waiting' then
    raise exception 'Room sudah mulai atau sudah selesai';
  end if;

  if exists(select 1 from public.arena_players
            where room_id = room.id and user_id = uid and status <> 'left') then
    return jsonb_build_object(
      'room_id', room.id, 'code', room.code, 'rejoined', true);
  end if;

  select count(*) into cnt from public.arena_players
  where room_id = room.id and status <> 'left';
  maxp := case room.mode when 'battle' then 2 else 10 end;
  if cnt >= maxp then raise exception 'Room penuh'; end if;

  insert into public.arena_players (room_id, user_id)
  values (room.id, uid);

  return jsonb_build_object(
    'room_id', room.id, 'code', room.code, 'rejoined', false);
end;
$$;
grant execute on function public.arena_join_room(text) to authenticated;

-- ---------- 3. mulai game (hanya host) ----------
create or replace function public.arena_start_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  room public.arena_rooms;
  me public.arena_players;
  cnt int;
  qids text[];
  p record;
  q record;
  perm int[];
  orders jsonb;
begin
  if uid is null then raise exception 'Harus login'; end if;

  select * into room from public.arena_rooms
  where id = p_room_id for update;
  if room.id is null then raise exception 'Room tidak ditemukan'; end if;
  if room.status <> 'waiting' then
    raise exception 'Room tidak dalam status menunggu';
  end if;
  if room.mode <> 'battle' then raise exception 'Mode belum tersedia'; end if;

  select * into me from public.arena_players
  where room_id = p_room_id and user_id = uid and status <> 'left';
  if me.id is null then raise exception 'Kamu bukan pemain room ini'; end if;
  if not me.is_host then
    raise exception 'Hanya pembuat room yang bisa memulai';
  end if;

  select count(*) into cnt from public.arena_players
  where room_id = p_room_id and status <> 'left';
  if cnt < 2 then raise exception 'Tunggu lawan bergabung dulu'; end if;

  -- Shared deck: urutan soal SAMA untuk semua pemain di room ini (fair).
  select array_agg(id order by random()) into qids
  from (select id from public.questions
        where kind = 'battle' order by random() limit 25) s;
  if qids is null or array_length(qids, 1) < 10 then
    raise exception 'Soal battle belum cukup';
  end if;

  -- Opsi diacak per pemain (pola sama seperti start_session).
  for p in
    select * from public.arena_players
    where room_id = p_room_id and status <> 'left'
  loop
    orders := '{}'::jsonb;
    for q in
      select * from public.questions where id = any (qids)
    loop
      select array_agg(i order by random()) into perm
      from generate_series(0, jsonb_array_length(q.options) - 1) as i;
      orders := orders || jsonb_build_object(q.id, to_jsonb(perm));
    end loop;
    update public.arena_players
    set option_orders = orders, status = 'playing'
    where id = p.id;
  end loop;

  update public.arena_rooms
  set status = 'playing',
      question_ids = qids,
      max_questions = array_length(qids, 1),
      started_at = now()
  where id = p_room_id;

  return jsonb_build_object('ok', true,
    'questions', array_length(qids, 1));
end;
$$;
grant execute on function public.arena_start_room(uuid) to authenticated;

-- ---------- 4. ambil soal berikut untuk pemain ----------
create or replace function public.arena_get_question(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  room public.arena_rooms;
  me public.arena_players;
  opp public.arena_players;
  total int;
  qid text;
  q public.questions;
  perm jsonb;
  displayed jsonb;
begin
  if uid is null then raise exception 'Harus login'; end if;

  select * into room from public.arena_rooms where id = p_room_id;
  if room.id is null then raise exception 'Room tidak ditemukan'; end if;
  if room.status <> 'playing' then
    raise exception 'Room tidak sedang bermain';
  end if;

  select * into me from public.arena_players
  where room_id = p_room_id and user_id = uid and status = 'playing';
  if me.id is null then raise exception 'Kamu tidak sedang bermain'; end if;

  select * into opp from public.arena_players
  where room_id = p_room_id and user_id <> uid and status <> 'left'
  order by user_id limit 1;

  total := array_length(room.question_ids, 1);
  if me.answered >= total then
    return jsonb_build_object('done', true,
      'answered', me.answered, 'total', total);
  end if;

  qid := room.question_ids[me.answered + 1];
  select * into q from public.questions where id = qid;
  if q.id is null then raise exception 'Soal tidak ditemukan'; end if;

  perm := me.option_orders -> qid;
  if perm is null then raise exception 'Data soal rusak'; end if;

  select jsonb_agg(q.options -> ((v #>> '{}')::int) order by ord)
  into displayed
  from jsonb_array_elements(perm) with ordinality as t(v, ord);

  return jsonb_build_object(
    'done', false,
    'question_id', qid,
    'q', q.question,
    'options', displayed,
    'answered', me.answered,
    'total', total,
    'my_hp', me.hp,
    'opp_hp', coalesce(opp.hp, 0)
  );
end;
$$;
grant execute on function public.arena_get_question(uuid) to authenticated;

-- ---------- 5. jawab (inti: cek di server, damage di server) ----------
create or replace function public.arena_answer(p_room_id uuid, p_option int)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  room public.arena_rooms;
  me public.arena_players;
  opp public.arena_players;
  pr public.arena_players;
  total int;
  qid text;
  q public.questions;
  perm jsonb;
  chosen_original int;
  correct_pos int;
  is_correct boolean;
  new_answered int;
  new_correct int;
  new_opp_hp int;
  game_over boolean := false;
  winner_id uuid := null;
  is_draw boolean := false;
  v_result text := null;
begin
  if uid is null then raise exception 'Harus login'; end if;

  -- Kunci room + kedua pemain dalam urutan user_id yang konsisten
  -- agar dua jawaban bersamaan tidak deadlock.
  select * into room from public.arena_rooms
  where id = p_room_id for update;
  if room.id is null then raise exception 'Room tidak ditemukan'; end if;
  if room.status <> 'playing' then
    raise exception 'Room tidak sedang bermain';
  end if;
  if room.mode <> 'battle' then raise exception 'Mode belum tersedia'; end if;

  for pr in
    select * from public.arena_players
    where room_id = p_room_id and status = 'playing'
    order by user_id for update
  loop
    if pr.user_id = uid then me := pr; else opp := pr; end if;
  end loop;
  if me.id is null then
    raise exception 'Kamu tidak sedang bermain di room ini';
  end if;
  if opp.id is null then raise exception 'Lawan tidak ditemukan'; end if;

  total := array_length(room.question_ids, 1);
  if me.answered >= total then raise exception 'Soal sudah habis'; end if;

  -- Soal yang diharapkan = deck[answered+1]; tidak bisa loncat/ulang.
  qid := room.question_ids[me.answered + 1];
  select * into q from public.questions where id = qid;
  if q.id is null then raise exception 'Soal tidak ditemukan'; end if;

  perm := me.option_orders -> qid;
  if perm is null then raise exception 'Data soal rusak'; end if;
  if p_option < 0 or p_option >= jsonb_array_length(perm) then
    raise exception 'Pilihan tidak valid';
  end if;

  chosen_original := (perm ->> p_option)::int;
  is_correct := chosen_original = q.correct_index;
  select pos - 1 into correct_pos
  from jsonb_array_elements(perm) with ordinality as t(val, pos)
  where (val #>> '{}')::int = q.correct_index;

  new_answered := me.answered + 1;
  new_correct := me.correct + case when is_correct then 1 else 0 end;
  new_opp_hp := opp.hp - case when is_correct then 10 else 0 end;

  update public.arena_players
  set answered = new_answered, correct = new_correct
  where id = me.id;
  if is_correct then
    update public.arena_players set hp = new_opp_hp where id = opp.id;
  end if;

  -- Kondisi menang: KO, atau deck habis di kedua sisi lalu banding HP.
  if new_opp_hp <= 0 then
    game_over := true;
    winner_id := uid;
  elsif new_answered >= total and opp.answered >= total then
    game_over := true;
    if me.hp > opp.hp then
      winner_id := uid;
    elsif opp.hp > me.hp then
      winner_id := opp.user_id;
    else
      is_draw := true;
    end if;
  end if;

  if game_over then
    perform public.arena_finish_room(p_room_id, winner_id, is_draw);
    if is_draw then v_result := 'draw';
    elsif winner_id = uid then v_result := 'win';
    else v_result := 'lose';
    end if;
  end if;

  return jsonb_build_object(
    'correct', is_correct,
    'correct_option', correct_pos,
    'explanation', q.explanation,
    'my_hp', me.hp,
    'opp_hp', new_opp_hp,
    'my_answered', new_answered,
    'my_correct', new_correct,
    'total', total,
    'game_over', game_over,
    'result', v_result
  );
end;
$$;
grant execute on function public.arena_answer(uuid, int) to authenticated;

-- ---------- 6. keluar (WO jika sedang bermain) ----------
create or replace function public.arena_leave(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  room public.arena_rooms;
  me public.arena_players;
  others int;
  opp_id uuid;
begin
  if uid is null then raise exception 'Harus login'; end if;

  select * into room from public.arena_rooms
  where id = p_room_id for update;
  if room.id is null then return jsonb_build_object('ok', true); end if;

  select * into me from public.arena_players
  where room_id = p_room_id and user_id = uid and status <> 'left'
  for update;
  if me.id is null then return jsonb_build_object('ok', true); end if;

  if room.status = 'waiting' then
    delete from public.arena_players where id = me.id;
    select count(*) into others from public.arena_players
    where room_id = p_room_id;
    if others = 0 then
      delete from public.arena_rooms where id = p_room_id;
    elsif me.is_host then
      update public.arena_players set is_host = true
      where id = (select id from public.arena_players
                  where room_id = p_room_id
                  order by created_at limit 1);
    end if;
    return jsonb_build_object('ok', true, 'forfeit', false);
  end if;

  if room.status = 'playing' then
    update public.arena_players
    set status = 'left' where id = me.id;
    select user_id into opp_id from public.arena_players
    where room_id = p_room_id and user_id <> uid and status <> 'left'
    order by user_id limit 1;
    -- WO: lawan yang bertahan menang.
    perform public.arena_finish_room(p_room_id, opp_id, false);
    return jsonb_build_object('ok', true, 'forfeit', true);
  end if;

  return jsonb_build_object('ok', true, 'forfeit', false);
end;
$$;
grant execute on function public.arena_leave(uuid) to authenticated;
