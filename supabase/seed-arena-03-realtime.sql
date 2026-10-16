-- =====================================================================
-- Arena PvP — daftarkan tabel ke Supabase Realtime.
--
-- postgres_changes HANYA mengirim perubahan untuk tabel yang terdaftar di
-- publication supabase_realtime. Tanpa ini, HP bar / daftar pemain / status
-- room tidak ter-update live di layar lawan (harus refresh manual).
-- Idempotent: guard IF NOT EXISTS, aman dijalankan ulang.
-- =====================================================================

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'arena_players'
  ) then
    alter publication supabase_realtime add table public.arena_players;
  end if;

  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'arena_rooms'
  ) then
    alter publication supabase_realtime add table public.arena_rooms;
  end if;
end
$$;
