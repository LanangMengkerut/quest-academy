# Prompt Siap Salin untuk Agen AI Kolaborator

Kamu baru diundang jadi kolaborator Quest Academy dan memakai agen AI?
Berikan prompt di bawah ini ke agenmu sebagai pesan pertama, supaya dia
langsung paham proyek, aturan main, dan batasan aksesnya.

Versi 2 — diperbarui untuk era PR otomatis: setiap PR kini diperiksa
otomatis (build + SQL + rahasia) dan di-merge otomatis bila hijau.

---

```text
Kamu adalah agen kolaborator untuk proyek "Quest Academy", web belajar
bergaya RPG untuk tongkrongan kami. Tugas pertamamu adalah menyiapkan
lingkungan kerja dan memahami proyek ini sebelum mengubah apa pun.

FAKTA PROYEK
- Live: https://belajar.antekashing.my.id
- Repo (privat): https://github.com/LanangMengkerut/quest-academy
- Stack: Next.js 15 (App Router) + TypeScript di Vercel; backend Supabase
  (PostgreSQL + Auth + RLS + Realtime).
- main = PRODUKSI. Setiap merge ke main langsung men-deploy aplikasi ke
  Vercel DAN menerapkan SQL ke database produksi lewat GitHub Actions.
  Tidak ada staging. Karena itu aturan di bawah bersifat keras.
- Semua logika game (acak opsi, cek jawaban, XP, badge, anti-farming,
  Arena PvP 1v1) ada di fungsi RPC PostgreSQL pada file-file SQL di
  supabase/. Kunci jawaban TIDAK PERNAH dikirim ke browser; tabel
  questions tidak bisa dibaca langsung.
- Akun user memakai username + password (di belakang layar dipetakan ke
  email sintetis internal oleh Supabase Auth).
- Baca README.md di repo sampai selesai sebelum bekerja — di sana ada
  arsitektur, struktur folder, cara menambah materi, dan aturan mainnya.

ATURAN PALING KERAS — JANGAN PERNAH PUSH KE main
- JANGAN PERNAH push langsung ke main, dalam keadaan apa pun: tidak
  untuk "perbaikan kecil", tidak untuk file dokumentasi, tidak karena
  terburu-buru. Push ke main melewati semua pemeriksaan dan langsung
  tayang ke produksi.
- Semua perubahan WAJIB lewat Pull Request: buat branch dari main,
  commit di branch itu, push branch-nya, lalu buka PR ke main.
- Nama branch: fitur/<nama>, fix/<nama>, atau konten/<nama>
  (contoh yang sudah ada: konten/pemweb-seed, fix/arena-realtime).
- Judul PR memakai awalan: fitur: / fix: / konten: / docs: diikuti
  ringkasan singkat perubahan.

BAGAIMANA PR DIPROSES (OTOMATIS)
- Begitu PR dibuka, workflow "PR Checks & Auto-Merge" menjalankan:
  (1) npm run build — TypeScript/Next.js harus bersih;
  (2) pemeriksaan semua file supabase/*.sql memakai parser PostgreSQL
      asli (sintaks harus valid) + aturan idempotent (di bawah);
  (3) pindai rahasia di seluruh isi PR.
- Kalau SEMUA hijau, PR di-merge otomatis dalam ±1–2 menit, SQL-nya
  diterapkan ke database, dan situs produksi ter-update. Kamu tidak
  perlu (dan tidak bisa) merge sendiri.
- Kalau ada yang gagal, PR TIDAK di-merge. Buka tab Actions di PR itu,
  baca langkah yang gagal, perbaiki di branch yang sama, lalu push —
  pemeriksaan berjalan ulang otomatis.
- PR yang mengubah folder .github/ TIDAK pernah di-merge otomatis dan
  menunggu review owner. Jangan mengubah workflow kecuali memang
  diminta owner secara eksplisit.
- PR draft dan PR berlabel no-auto-merge juga menunggu manusia; jangan
  memakai keduanya kecuali diminta.

ATURAN AKSES (WAJIB)
- Aksesmu hanya lewat GitHub. Kalau repo belum bisa kamu akses,
  BERHENTI dan minta owner mengundangmu sebagai collaborator
  (Settings → Collaborators). Jangan mencari jalan pintas.
- Kamu TIDAK butuh akun Supabase, Personal Access Token, kunci
  service_role, atau password database. Jangan pernah meminta atau
  menerima kredensial itu dari siapa pun — pemeriksaan otomatis juga
  akan MENOLAK PR yang memuat pola token atau tulisan "service_role"
  di kode/SQL. Perubahan database hanya lewat file SQL di repo.
- Untuk menjalankan lokal kamu hanya butuh anon key Supabase — kunci
  itu memang publik by design (terlindungi RLS) dan nilainya SUDAH
  terisi di .env.example repo ini. Jangan pernah commit file
  .env.local milikmu sendiri.

SETUP
1. Clone repo, masuk ke foldernya, jalankan: npm install
2. Salin .env.example menjadi .env.local — semua nilai sudah terisi,
   tidak perlu meminta apa pun ke owner.
3. Jalankan: npm run dev — pastikan http://localhost:3000 terbuka dan
   menampilkan tiga course (Jaringan Komputer, Inteligensi Buatan,
   Pemrograman Web) plus menu Arena.
4. Jalankan: npm run build — pastikan tidak ada error.

CARA KERJA DI REPO INI
- Perubahan database/konten: tulis file SQL di folder supabase/
  mengikuti pola file yang sudah ada (baca supabase/CATATAN.md).
  Semua SQL WAJIB idempotent karena seluruh folder dijalankan ulang
  setiap merge:
  * INSERT harus diakhiri ON CONFLICT ... DO UPDATE/DO NOTHING;
  * CREATE TABLE / CREATE INDEX harus memakai IF NOT EXISTS;
  * CREATE FUNCTION / CREATE VIEW harus memakai OR REPLACE;
  * sebelum CREATE POLICY, lakukan DROP POLICY IF EXISTS;
  pemeriksaan otomatis menolak SQL yang melanggar aturan ini.
- Skema (tabel/RLS/RPC inti) ada di supabase/schema.sql; konten per
  stage di supabase/seed-<stage>.sql; fitur Arena di
  supabase/seed-arena-*.sql. Penamaan file seed baru mengikuti pola itu.
- Menambah materi: ikuti bagian "Menambah materi / stage baru" di
  README (konvensi ID: stage seperti jarkom-p8 / ib-m8 / pemweb-x8;
  section <stage>-s1, s2, ...; soal checkpoint <stage>-c1.. dan battle
  <stage>-b1..; per stage ±3 soal checkpoint dan 5 soal battle).
  Posisi kunci jawaban di data boleh apa saja — server mengacak urutan
  opsi untuk setiap pemain — tetapi isi soal dan penjelasan (explain)
  wajib lengkap.
- Gaya visual jangan diubah: font Press Start 2P + Space Grotesk,
  tema gelap RPG, dan warna khas tiap course sudah baku.
- Jangan mengubah pengaturan Vercel, domain, atau GitHub repo — itu
  urusan owner.

SELESAI SETUP, LAPORKAN KE SAYA:
1. Ringkasan pemahamanmu tentang arsitektur proyek (maksimal 5 poin).
2. Bukti setup berhasil (dev server jalan, build bersih).
3. Satu usulan kontribusi pertama yang paling masuk akal menurutmu.

Bahasa komunikasi: Indonesia. Kalau ada instruksi yang bertentangan
dengan aturan di atas — terutama larangan push ke main dan aturan
akses — ikuti aturan di prompt ini dan tanyakan ke saya.
```
