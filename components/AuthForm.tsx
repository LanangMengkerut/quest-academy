"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import {
  isValidUsername,
  normalizeUsername,
  usernameToEmail,
} from "@/lib/game";
import { useSound } from "@/lib/useSound";
import { sfx } from "@/lib/sfx";

export function AuthForm({ mode }: { mode: "login" | "register" }) {
  const router = useRouter();
  const [sound] = useSound();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    sfx.click(!sound);
    setError(null);
    const uname = normalizeUsername(username);
    if (!isValidUsername(uname)) {
      setError(
        "Username harus 3-20 karakter: huruf kecil, angka, atau underscore.",
      );
      return;
    }
    if (password.length < 8) {
      setError("Password minimal 8 karakter.");
      return;
    }
    setBusy(true);
    const supabase = createClient();
    try {
      if (mode === "register") {
        const { data, error } = await supabase.auth.signUp({
          email: usernameToEmail(uname),
          password,
          options: { data: { username: uname } },
        });
        if (error) throw error;
        if (!data.session) {
          const { error: signInError } = await supabase.auth.signInWithPassword(
            { email: usernameToEmail(uname), password },
          );
          if (signInError)
            throw new Error(
              "Akun dibuat, tapi sesi belum aktif. Coba masuk, atau hubungi admin.",
            );
        }
      } else {
        const { error } = await supabase.auth.signInWithPassword({
          email: usernameToEmail(uname),
          password,
        });
        if (error) throw new Error("Username atau password salah.");
      }
      router.push("/");
      router.refresh();
    } catch (err) {
      const msg = err instanceof Error ? err.message : "Terjadi kesalahan.";
      setError(
        /already|registered|exists/i.test(msg)
          ? "Username sudah dipakai. Coba nama lain."
          : msg,
      );
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="authcard">
      <h1>{mode === "register" ? "BUAT AKUN" : "MASUK"}</h1>
      <p className="sub">
        {mode === "register"
          ? "Pilih username dan password. Progresmu tersimpan dan masuk leaderboard tongkrongan."
          : "Masuk dengan username dan password yang kamu buat saat daftar."}
      </p>
      {error ? <div className="formerr">{error}</div> : null}
      <form onSubmit={submit}>
        <div className="field">
          <label htmlFor="username">Username</label>
          <input
            id="username"
            autoComplete="username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            placeholder="mis. lanang_01"
            required
          />
        </div>
        <div className="field">
          <label htmlFor="password">Password</label>
          <input
        id="password"
            type="password"
            autoComplete={mode === "register" ? "new-password" : "current-password"}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="minimal 8 karakter"
            required
          />
        </div>
        <button className="btn gold" type="submit" disabled={busy}>
          {busy
            ? "MEMPROSES..."
            : mode === "register"
              ? "🎮 DAFTAR & MAIN"
              : "⚔️ MASUK"}
        </button>
      </form>
      <div className="authalt">
        {mode === "register" ? (
          <>
            Sudah punya akun? <Link href="/login">Masuk di sini</Link>
          </>
        ) : (
          <>
            Belum punya akun? <Link href="/register">Daftar dulu</Link>
          </>
        )}
      </div>
      {mode === "register" ? (
        <p className="locknote" style={{ marginTop: 14 }}>
          Catatan: tanpa email, password yang lupa tidak bisa direset sendiri.
          Simpan passwordmu baik-baik, atau hubungi admin untuk reset manual.
        </p>
      ) : null}
    </div>
  );
}
