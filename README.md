# Quest Academy — Versi Dinamis

Rebuild dinamis dari web belajar gamifikasi **Quest Academy** (aslinya statis di
belajar.arsene-cloud.my.id) untuk belajar bareng tongkrongan.

## Stack

- **Next.js 15** (App Router) + TypeScript, styling dari CSS asli versi statis
  (font Press Start 2P + Space Grotesk, tema gelap RPG).
- **Supabase**: Postgres + Auth + RLS. Semua logika kuis (acak opsi, cek
  jawaban, XP, badge, anti-farming) berjalan sebagai fungsi RPC di database
  (`SECURITY DEFINER`), jadi kunci jawaban tidak pernah dikirim ke browser.
- **Vercel** untuk hosting.

## Cara belajar per stage

1. **Intisari** — ringkasan materi di halaman stage.
2. **Dokumen asli** — tautan ke sumber (halaman web ITERA untuk Jarkom,
   PDF Google Drive untuk Inteligensi Buatan).
3. **Penjelasan bertahap** — materi dipecah per halaman (sections), dibaca
   dengan tombol next/back, progres tersimpan per user.
4. **Checkpoint** — soal singkat di akhir penjelasan; wajib lulus untuk
   membuka battle.
5. **Battle** — boss stage: 3 HP, opsi diacak server, XP penuh hanya bila
   skor melewati rekor sebelumnya (pengulangan skor sama/turun = 10% XP).

## Akun

Daftar dengan **username + password** (tanpa email/Google). Di belakang
layar memakai Supabase Auth email+password dengan email sintetis internal
`username@users.quest-academy.local` yang tidak pernah ditampilkan.
Konsekuensinya: password lupa tidak bisa direset mandiri — reset dilakukan
manual oleh admin lewat dashboard Supabase.

## Konten saat ini

- **Jaringan Komputer** — 7 stage dari Materi Ajar ITERA
  (informatika-itera.github.io/jarkom), Pertemuan 1–7.
- **Inteligensi Buatan** — 7 stage dari PDF kuliah Minggu 1–7.
- Tiap stage: sections penjelasan, 3 soal checkpoint, 5 soal battle.
- Skema database: `supabase/schema.sql`; seed konten: `supabase/seed-*.sql`
  (dibangkitkan dari sumber oleh skrip di luar repo).

## Menjalankan lokal

```bash
npm install
cp .env.example .env.local   # isi anon key dari dashboard Supabase
npm run dev
```

Environment yang dibutuhkan:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`

Kunci `service_role` tidak dipakai aplikasi sama sekali.

## Catatan keamanan

- Tabel `questions` tidak punya policy SELECT: jawaban & pembahasan hanya
  keluar lewat RPC setelah user menjawab.
- Project Supabase harus mengaktifkan **mailer_autoconfirm** karena email
  sintetis tidak bisa menerima email konfirmasi.
