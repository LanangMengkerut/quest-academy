# Folder supabase/

Folder ini adalah satu-satunya sumber kebenaran untuk database Quest Academy.
Tidak ada perubahan database lewat jalur lain — semua lewat file di sini.

## Isi

- `schema.sql` — skema lengkap: tabel, Row Level Security, view statistik,
  dan RPC mesin kuis (`start_session`, `answer_question`, dll).
- `seed-00-courses.sql` — data course (dijalankan sebelum seed stage).
- `seed-<stage>.sql` — konten per stage: intisari, sections (halaman
  penjelasan), soal checkpoint, dan soal battle.

## Cara perubahan diterapkan

Workflow GitHub Actions **Deploy Supabase SQL** menjalankan semua file SQL
di folder ini ke project Supabase setiap ada push ke `main` yang mengubah
folder `supabase/` (atau saat dijalankan manual dari tab Actions).
Urutan eksekusi: `schema.sql` → `seed-00-courses.sql` → `seed-*.sql` lain
sesuai abjad. Penjalanannya ada di `scripts/apply_supabase_sql.py`.

## Aturan wajib

- Setiap file SQL **harus idempotent**: gunakan `IF NOT EXISTS`,
  `CREATE OR REPLACE`, dan `ON CONFLICT ... DO UPDATE` seperti file yang
  sudah ada, karena seluruh folder dijalankan ulang setiap kali.
- Jangan menaruh kredensial apa pun di folder ini. Token yang dipakai
  workflow tersimpan sebagai GitHub Actions secret (`SUPABASE_ACCESS_TOKEN`)
  milik owner.
- Kolaborator tidak butuh akses Supabase langsung — cukup buat PR berisi
  file SQL di folder ini.
