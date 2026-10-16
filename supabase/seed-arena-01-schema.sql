-- =====================================================================
-- Arena PvP — skema: rooms, players, stats + RLS.
-- Idempotent: aman dijalankan ulang oleh GitHub Actions (seluruh folder
-- supabase/ di-apply ulang setiap merge).
-- File ini dieksekusi SETELAH schema.sql (lihat scripts/apply_supabase_sql.py:
-- schema.sql dulu, lalu seed-*.sql sesuai abjad).
-- =====================================================================

create table if not exists public.arena_rooms (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  mode text not null check (mode in ('battle', 'race')),
  status text not null default 'waiting'
    check (status in ('waiting', 'playing', 'finished', 'expired')),
  created_by uuid not null references public.profiles (id) on delete cascade,
  question_ids text[] not null default '{}',
  max_questions int not null default 25,
  winner_id uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  started_at timestamptz,
  finished_at timestamptz
);

create table if not exists public.arena_players (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references public.arena_rooms (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  is_host boolean not null default false,
  hp int not null default 100,
  progress int not null default 0,
  answered int not null default 0,
  correct int not null default 0,
  option_orders jsonb not null default '{}'::jsonb,
  status text not null default 'joined'
    check (status in ('joined', 'playing', 'finished', 'left')),
  finished_at timestamptz,
  created_at timestamptz not null default now(),
  unique (room_id, user_id)
);
create index if not exists arena_players_room_idx
  on public.arena_players (room_id);

create table if not exists public.arena_stats (
  user_id uuid not null references public.profiles (id) on delete cascade,
  mode text not null check (mode in ('battle', 'race')),
  wins int not null default 0,
  losses int not null default 0,
  draws int not null default 0,
  played int not null default 0,
  updated_at timestamptz not null default now(),
  primary key (user_id, mode)
);

-- ============ RLS ============
-- Semua mutasi lewat RPC SECURITY DEFINER. Client hanya boleh SELECT baris
-- room yang ia ikuti (dibutuhkan juga oleh Supabase Realtime), dan membaca
-- arena_stats milik semua user yang login (leaderboard publik tongkrongan).

alter table public.arena_rooms enable row level security;
alter table public.arena_players enable row level security;
alter table public.arena_stats enable row level security;

-- Helper SECURITY DEFINER agar policy tidak rekursif (policy arena_players
-- tidak boleh subquery ke arena_players secara langsung).
create or replace function public.arena_is_room_player(p_room_id uuid)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists(
    select 1 from public.arena_players
    where room_id = p_room_id
      and user_id = auth.uid()
      and status <> 'left'
  );
$$;
grant execute on function public.arena_is_room_player(uuid) to authenticated;

drop policy if exists arena_rooms_select on public.arena_rooms;
create policy arena_rooms_select on public.arena_rooms
  for select to authenticated
  using (public.arena_is_room_player(arena_rooms.id));

drop policy if exists arena_players_select on public.arena_players;
create policy arena_players_select on public.arena_players
  for select to authenticated
  using (public.arena_is_room_player(arena_players.room_id));

drop policy if exists arena_stats_select on public.arena_stats;
create policy arena_stats_select on public.arena_stats
  for select to authenticated
  using (true);
-- Tidak ada policy insert/update/delete: akses tulis hanya via RPC.
