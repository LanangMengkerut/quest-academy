# 🎮 Quest Academy — Versi Dinamis

**Belajar sambil main, buat tongkrongan.** Quest Academy adalah web belajar bergaya RPG: baca materi per halaman, lulus checkpoint, kalahkan boss di tiap stage, kumpulkan XP, dan rebut puncak leaderboard bareng teman-teman.

- 🌐 **Live:** https://belajar.antekashing.my.id
- 🪞 Cadangan: https://quest-academy-beta.vercel.app
- 📦 Repo: https://github.com/LanangMengkerut/quest-academy (publik)

> Ini adalah rebuild dinamis dari web statis Quest Academy lama. Dulu progres hanya tersimpan di `localStorage` browser dan kunci jawaban bisa diintip dari file JSON. Sekarang semuanya server-side: akun, progres tersinkron, dan kunci jawaban tidak pernah dikirim ke browser.

---

## ✨ Fitur

- **Akun username + password** — tanpa email, tanpa Google. Daftar, langsung main.
- **Belajar bertahap** — materi dipecah jadi halaman-halaman penjelasan yang bisa di-*next* satu per satu; progres bacaan tersimpan per akun.
- **Checkpoint** — kuis singkat di akhir penjelasan. Wajib lulus supaya battle stage terbuka.
- **Battle boss** — 5 soal per stage, 3 HP, opsi jawaban **diacak di server** setiap sesi.
- **Mode Fokus (anti-AI)** — battle & Arena berjalan dalam mode fokus: fullscreen otomatis bila browser mendukung, pindah tab/aplikasi atau split-screen terdeteksi (tenggang ±2 detik), sesi dijeda per pelanggaran, dan 3× pelanggaran menghentikan sesi (Arena: dianggap menyerah). Berlaku di HP maupun PC; checkpoint tidak memakai mode ini. Penegakannya di sisi klien (`lib/useExamGuard.ts`) — penegak norma main bersih, bukan proctoring ujian.
- **Karakter hidup & animasi Framer Motion** — boss dan pemain bergerak idle, menyerang, terhuyung saat kena hit, angka damage melayang, boss berdialog (dan mengamuk saat HP-nya kritis), ada penjaga gerbang di checkpoint, transisi soal & halaman, bar HP/XP berpegas.
- **Musik latar ala dungeon** — ambience prosedural WebAudio (drone rendah, angin, nada minor bergaung) yang mulai setelah interaksi pertama; bisa dimatikan kapan saja lewat tombol **Musik** di navigasi, pilihan tersimpan di browser.
- **Pemilih dunia fokus** — halaman utama menampilkan satu kartu dunia besar bergaya showcase (komponen `WorldCarousel`): navigasi dengan panah ‹ ›, tombol panah keyboard, geser/drag kartu, atau pill nama dunia. Background halaman dan **mood musik berubah mengikuti dunia yang sedang fokus** (Jarkom: A minor rapat bernuansa jaringan; Inteligensi Buatan: D minor renggang bergaung panjang; Pemweb: G mayor cerah dan lincah — lihat `MOODS` di `lib/music.ts`). Semua kartu berukuran persis sama karena geometrinya tetap, bukan mengikuti panjang konten.
- **XP, level & 7 rank** (Newbie → Mitos), bintang per stage, 6 badge, streak jawaban benar, efek suara WebAudio.
- **Leaderboard** — peringkat total XP selamanya + kolom XP 7 hari terakhir.
- **Anti-farming** — XP penuh hanya kalau skor melewati rekor pribadi di stage itu; pengulangan di bawahnya hanya dapat 10% XP.
- **Akses materi asli** — tiap stage menautkan sumber aslinya (halaman web ITERA untuk Jarkom, PDF Google Drive untuk Inteligensi Buatan).

## 📚 Konten saat ini

| Course | Stage | Sumber materi |
| --- | --- | --- |
| 🌐 Jaringan Komputer | 7 (Pertemuan 1–7) | Situs Materi Ajar ITERA — informatika-itera.github.io/jarkom |
| 🧠 Inteligensi Buatan | 7 (Minggu 1–7) | PDF kuliah di Google Drive |
| 💻 Pemrograman Web | menyusul | menunggu materi |

Total: 14 stage, 102 halaman penjelasan, 70 soal battle + 42 soal checkpoint.

## 🔄 Cara main (alur per stage)

1. **Intisari** — ringkasan materi di halaman stage.
2. **Penjelasan bertahap** — baca halaman demi halaman (sections).
3. **Checkpoint** — jawab soal singkat; harus lulus untuk membuka battle.
4. **Battle** — lawan boss: jawab benar = menyerang, 3× salah = tumbang. Skor ≥60% = menang, 100% = bintang 3.
5. XP masuk ke profil & leaderboard. Ulangi stage untuk memecahkan rekor (dan dapat XP penuh lagi).

## 🏗️ Arsitektur

```
Browser ──► Next.js (Vercel) ──► Supabase (Postgres + Auth)
                 UI saja            semua logika game di sini
```

| Lapisan | Teknologi |
| --- | --- |
| Frontend + routing | Next.js 15 (App Router) + TypeScript |
| Styling | CSS asli versi statis — Press Start 2P + Space Grotesk, tema gelap RPG |
| Backend & database | Supabase (PostgreSQL, Auth, Row Level Security) |
| Hosting | Vercel |

### Kenapa logika kuis ada di database?

Mesin kuisnya adalah dua fungsi RPC PostgreSQL (`start_session` dan `answer_question`, keduanya `SECURITY DEFINER`):

- Server membuat sesi, **mengacak urutan opsi**, dan hanya mengirim soal + opsi ke browser — **tanpa** kunci jawaban dan pembahasan.
- Setiap jawaban dicek di server; pembahasan baru dikirim *setelah* menjawab.
- Skor, XP, badge, streak, dan anti-farming dihitung dan ditulis server di akhir sesi.
- Tabel `questions` sengaja **tidak punya policy SELECT** — tidak ada cara membaca kunci jawaban dari API.

Autentikasi memakai Supabase Auth email+password, tetapi user tidak pernah melihat email: username dipetakan ke email sintetis internal `username@users.quest-academy.local`. Konsekuensinya:

- Konfirmasi email harus dimatikan (`mailer_autoconfirm = true` di Supabase Auth) karena email sintetis tidak bisa menerima email.
- **Tidak ada reset password mandiri.** User yang lupa password direset manual oleh admin lewat dashboard Supabase (Authentication → Users).

## 🗂️ Struktur folder

```
app/                    Halaman (App Router)
  page.tsx              Beranda: daftar course + badge
  login/ register/      Form autentikasi
  leaderboard/          Papan peringkat
  course/[courseId]/    Daftar stage per course
    stage/[stageId]/    Hub stage: intisari + akses materi asli
      learn/            Penjelasan bertahap + checkpoint
      battle/           Arena battle boss
components/             AuthForm, Hud (XP bar), LearnFlow, Quiz, MarkStageRead
lib/
  game.ts               Konstanta game: rank, level, bintang, badge, pemetaan username→email
  sfx.ts                Efek suara WebAudio
  supabase/             Client Supabase (browser & server)
supabase/
  schema.sql            Skema lengkap: tabel, RLS, view statistik, RPC mesin kuis
  seed-*.sql            Konten: course, stage, sections, soal (dibangkitkan dari sumber)
scripts/
  apply_supabase_sql.py Menjalankan semua SQL di supabase/ ke project (dipakai CI)
.github/workflows/
  supabase-deploy.yml   GitHub Actions: terapkan SQL otomatis setiap merge ke main
middleware.ts           Refresh sesi Supabase
```

Model data inti: `profiles` · `courses` → `stages` → `sections` + `questions` (`kind`: `checkpoint`/`battle`) · `stage_progress` · `section_progress` · `attempts` · `user_badges` · `battle_sessions`.

## 🚀 Menjalankan lokal

Prasyarat: Node.js 20+ dan npm.

```bash
git clone https://github.com/LanangMengkerut/quest-academy.git
cd quest-academy
npm install
cp .env.example .env.local
```

Selesai — `.env.example` di repo ini **sudah terisi** URL project + anon key aslinya, jadi `.env.local` hasil salinan langsung bisa dipakai tanpa perlu meminta apa pun ke owner.

Lalu:

```bash
npm run dev        # http://localhost:3000
npm run build      # cek build production
```

Catatan keamanan: aplikasi **hanya** memakai anon key (memang dirancang publik, dilindungi RLS). Kunci `service_role` **tidak dipakai** dan tidak boleh pernah masuk repo/kode.

### Menyiapkan database dari nol (kalau fork ke project Supabase lain)

1. Buat project Supabase baru.
2. Jalankan `supabase/schema.sql` (SQL Editor), lalu `supabase/seed-00-courses.sql`, lalu semua `supabase/seed-*.sql`.
3. Di **Authentication → Settings**, aktifkan **mailer_autoconfirm** (wajib, lihat penjelasan email sintetis di atas).
4. Arahkan `.env.local` ke URL + anon key project baru.

## ➕ Menambah materi / stage baru

Konten sepenuhnya database-driven — tidak perlu mengubah kode:

1. Siapkan sumbernya (PDF / halaman web materi).
2. Pecah jadi: **intisari** (HTML), **sections** (satu baris per halaman penjelasan), **soal checkpoint** (±3) dan **soal battle** (5) — formatnya meniru file `supabase/seed-*.sql` yang sudah ada.
3. Konvensi ID: stage `jarkom-p8`, `ib-m8`, `pemweb-x1`; section `<stage>-s1`, `s2`, …; soal `<stage>-c1..` (checkpoint) dan `<stage>-b1..` (battle).
4. Masukkan file seed-nya ke folder `supabase/`, buat PR, dan merge ke `main`. GitHub Actions akan menerapkannya ke database secara otomatis (lihat bagian Deploy). Urutan opsi di file boleh apa adanya — pengacakan terjadi di server saat sesi dibuat.
5. Stage langsung muncul di web. Selesai.

## 🚢 Deploy

- Hosting aplikasi di **Vercel** (project `quest-academy`), env yang dibutuhkan hanya dua variabel `NEXT_PUBLIC_SUPABASE_*` di atas.
- Domain produksi: **belajar.antekashing.my.id** (CNAME di Cloudflare → `cname.vercel-dns.com`, status *DNS only*).
- **Database otomatis:** setiap push ke `main` yang mengubah folder `supabase/` memicu workflow **Deploy Supabase SQL** (GitHub Actions) yang menjalankan ulang `schema.sql` + semua `seed-*.sql` ke project Supabase. Semua file SQL ditulis idempotent, jadi aman dijalankan berulang. Workflow juga bisa dijalankan manual dari tab **Actions → Deploy Supabase SQL → Run workflow**.
- ⚠️ Status saat ini: project Vercel **belum terhubung Git**, jadi push ke GitHub **belum** otomatis men-deploy *aplikasinya*. Untuk mengaktifkan auto-deploy aplikasi: Vercel Dashboard → Project → Settings → Git → Connect ke repo ini. Selama belum terhubung, deploy aplikasi dilakukan manual dari dashboard/upload file.

### Pengaturan sekali jalan oleh owner repo (untuk workflow database)

Workflow database membutuhkan Personal Access Token Supabase **milik owner**, disimpan sebagai secret repo — bukan dibagikan ke siapa pun:

1. Ambil token di Supabase: **Account → Access Tokens** (token yang sama dengan yang dipakai owner; jangan kirim lewat chat/issue).
2. Di GitHub: repo **Settings → Secrets and variables → Actions → New repository secret**.
3. Name: `SUPABASE_ACCESS_TOKEN` — Value: tempel tokennya. Simpan.

Sesudah itu kolaborator tidak memerlukan akun Supabase sama sekali: cukup akses GitHub.

> Status: ✅ secret sudah terpasang dan run pertama workflow berhasil (16 Oktober 2026).

## 🤝 Panduan kolaborator

- Repo ini publik untuk dibaca siapa saja, tetapi hak kolaborator (push branch & PR dari dalam repo) hanya untuk yang diundang owner.
- **Kolaborator cukup punya akun GitHub.** Tidak perlu akun Supabase, tidak perlu tahu token siapa pun — perubahan database berjalan lewat repo ini dan GitHub Actions (lihat bagian Deploy).
- Baru bergabung dan memakai agen AI (Muse)? Salin **prompt siap pakai** di [docs/PROMPT-KOLABORATOR.md](docs/PROMPT-KOLABORATOR.md) sebagai pesan pertama ke agenmu — isinya konteks proyek, aturan akses, dan langkah setup.
- Kerjakan perubahan di branch sendiri lalu buat Pull Request ke `main` — jangan push langsung ke `main`.
- **PR diperiksa & di-merge otomatis.** Workflow *PR Checks & Auto-Merge* menjalankan build + pemeriksaan SQL (sintaks PostgreSQL asli, aturan idempotent, pindai rahasia) pada setiap PR; kalau semua hijau, PR langsung ter-merge dan SQL-nya diterapkan ke database. Pengecualian (menunggu review manusia): PR draft, PR berlabel `no-auto-merge`, dan PR yang mengubah folder `.github/`.
- **Jangan pernah commit** `.env.local` milikmu, kunci `service_role`, token, atau kredensial apa pun. `.env.example` memang sengaja berisi URL + anon key karena keduanya publik by design (anon key selalu terkirim ke browser pengunjung; keamanannya dijaga RLS) — bukan rahasia.
- Perubahan skema/konten database ditulis sebagai file SQL di folder `supabase/` dan disebutkan di PR; setelah merge, GitHub Actions menerapkannya otomatis. File SQL wajib idempotent (pakai `IF NOT EXISTS` / `ON CONFLICT DO UPDATE` seperti file yang sudah ada).
- Soal dan materi baru mengikuti alur "Menambah materi" di atas — tidak lewat kode.

## 🗺️ Roadmap

- [x] Deploy database otomatis via GitHub Actions (kolaborator cukup lewat GitHub)
- [ ] Materi Pemrograman Web (menunggu sumber)
- [ ] Auto-deploy GitHub → Vercel
- [ ] Kode pemulihan akun saat registrasi (antisipasi lupa password)
- [ ] Upload PDF materi ke Supabase Storage (sekarang masih tautan ke sumber asli)

---

Dibangun bareng tongkrongan. Ada ide fitur atau menemukan bug? Bikin issue / PR saja. 🎮
