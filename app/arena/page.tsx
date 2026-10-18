"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { MusicScene } from "@/components/MusicScene";

export default function ArenaHub() {
  const router = useRouter();
  const [code, setCode] = useState("");
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState("");

  const needLogin = async () => {
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      router.push("/login");
      return null;
    }
    return supabase;
  };

  const createRoom = async () => {
    setBusy(true);
    setErr("");
    const supabase = await needLogin();
    if (!supabase) return;
    const { data, error } = await supabase.rpc("arena_create_room", {
      p_mode: "battle",
    });
    if (error) {
      setErr(error.message);
      setBusy(false);
      return;
    }
    router.push(`/arena/${(data as { code: string }).code}`);
  };

  const joinRoom = async (e: React.FormEvent) => {
    e.preventDefault();
    const c = code.trim().toUpperCase();
    if (c.length < 4) {
      setErr("Masukkan kode room yang valid.");
      return;
    }
    setBusy(true);
    setErr("");
    const supabase = await needLogin();
    if (!supabase) return;
    const { data, error } = await supabase.rpc("arena_join_room", {
      p_code: c,
    });
    if (error) {
      setErr(error.message);
      setBusy(false);
      return;
    }
    router.push(`/arena/${(data as { code: string }).code}`);
  };

  return (
    <div className="lbwrap">
      <MusicScene scene="arena" />
      <h1 className="logo" style={{ fontSize: 26 }}>
        ⚔️ ARENA
      </h1>
      <p className="tagline">
        Duel PvP lawan tongkronganmu. Setiap jawaban benar mengurangi 10 HP
        lawan — yang HP-nya habis duluan, kalah. Soal diambil acak dari seluruh
        materi, urutannya sama untuk kedua pemain biar adil.
      </p>

      <div className="arena-grid">
        <div className="arena-card">
          <h2>⚔️ BATTLE 1v1</h2>
          <p>
            Buat room, bagikan kodenya ke lawan (janjian dulu!), lalu mulai.
            Tiap pemain punya 100 HP. Jawab benar = serang lawan (−10 HP).
            Berakhir saat ada yang KO — atau setelah 25 soal, HP tertinggi
            menang.
          </p>
          <button className="btn gold" onClick={createRoom} disabled={busy}>
            {busy ? "Membuat…" : "Buat Room Battle"}
          </button>
        </div>

        <div className="arena-card">
          <h2>🔑 GABUNG ROOM</h2>
          <p>
            Punya kode dari temanmu? Masukkan di bawah ini untuk bergabung ke
            ruang tunggunya.
          </p>
          <form onSubmit={joinRoom}>
            <div className="field">
              <input
                value={code}
                onChange={(e) => setCode(e.target.value.toUpperCase())}
                placeholder="CONTOH: KX7Q2M"
                maxLength={6}
                style={{ textTransform: "uppercase", letterSpacing: 4 }}
              />
            </div>
            <button className="btn" type="submit" disabled={busy}>
              {busy ? "Bergabung…" : "Gabung"}
            </button>
          </form>
        </div>
      </div>

      <div className="arena-grid">
        <div className="arena-card disabled">
          <h2>🏁 RACE (SEGERA HADIR)</h2>
          <p>
            Balapan 2–10 pemain: jawaban benar = karaktermu maju selangkah.
            Yang pertama menjawab 10 soal dengan benar memenangkan balapan.
          </p>
          <button className="btn ghost" disabled>
            Segera Hadir
          </button>
        </div>

        <div className="arena-card">
          <h2>🏆 LEADERBOARD ARENA</h2>
          <p>
            Peringkat terpisah per mode, dihitung dari jumlah kemenangan —
            bukan XP. Menang battle, namamu naik.
          </p>
          <Link href="/arena/leaderboard" className="btn ghost">
            Lihat Leaderboard
          </Link>
        </div>
      </div>

      {err && <p className="err">⚠️ {err}</p>}
    </div>
  );
}
