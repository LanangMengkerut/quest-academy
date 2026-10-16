"use client";

import { useCallback, useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

type Room = {
  id: string;
  code: string;
  mode: string;
  status: string;
  created_by: string;
};

type Player = {
  user_id: string;
  is_host: boolean;
  status: string;
  username: string;
  avatar: string;
};

export default function ArenaWaiting() {
  const params = useParams();
  const router = useRouter();
  const code = String(params.code ?? "").toUpperCase();

  const [me, setMe] = useState<string>("");
  const [room, setRoom] = useState<Room | null>(null);
  const [players, setPlayers] = useState<Player[]>([]);
  const [busy, setBusy] = useState(false);
  const [copied, setCopied] = useState(false);
  const [err, setErr] = useState("");

  const load = useCallback(async () => {
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      router.push("/login");
      return;
    }
    setMe(user.id);

    const { data: r, error: rErr } = await supabase
      .from("arena_rooms")
      .select("id, code, mode, status, created_by")
      .eq("code", code)
      .single();
    if (rErr || !r) {
      setErr("Room tidak ditemukan atau kamu bukan pemainnya.");
      return;
    }
    const rm = r as Room;
    setRoom(rm);
    if (rm.status === "playing") {
      router.push(`/arena/${code}/play`);
      return;
    }
    if (rm.status === "finished") {
      router.push("/arena");
      return;
    }

    const { data: pls } = await supabase
      .from("arena_players")
      .select("user_id, is_host, status")
      .eq("room_id", rm.id)
      .neq("status", "left");
    const list = (pls ?? []) as {
      user_id: string;
      is_host: boolean;
      status: string;
    }[];
    const ids = list.map((p) => p.user_id);
    const profMap = new Map<string, { username: string; avatar: string }>();
    if (ids.length > 0) {
      const { data: profs } = await supabase
        .from("profiles")
        .select("id, username, avatar")
        .in("id", ids);
      for (const p of (profs ?? []) as {
        id: string;
        username: string;
        avatar: string;
      }[]) {
        profMap.set(p.id, { username: p.username, avatar: p.avatar });
      }
    }
    setPlayers(
      list.map((p) => ({
        ...p,
        username: profMap.get(p.user_id)?.username ?? "?",
        avatar: profMap.get(p.user_id)?.avatar ?? "🧙",
      }))
    );
  }, [code, router]);

  useEffect(() => {
    load();
  }, [load]);

  useEffect(() => {
    if (!room) return;
    const supabase = createClient();
    const ch = supabase
      .channel(`arena-wait-${room.id}`)
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "arena_players",
          filter: `room_id=eq.${room.id}`,
        },
        () => load()
      )
      .on(
        "postgres_changes",
        {
          event: "UPDATE",
          schema: "public",
          table: "arena_rooms",
          filter: `id=eq.${room.id}`,
        },
        (payload) => {
          const s = (payload.new as { status?: string }).status;
          if (s === "playing") router.push(`/arena/${code}/play`);
          if (s === "finished") router.push("/arena");
        }
      )
      .subscribe();
    return () => {
      supabase.removeChannel(ch);
    };
  }, [room, code, router, load]);

  const start = async () => {
    if (!room) return;
    setBusy(true);
    setErr("");
    const supabase = createClient();
    const { error } = await supabase.rpc("arena_start_room", {
      p_room_id: room.id,
    });
    if (error) {
      setErr(error.message);
      setBusy(false);
      return;
    }
    router.push(`/arena/${code}/play`);
  };

  const leave = async () => {
    if (!room) return;
    setBusy(true);
    const supabase = createClient();
    await supabase.rpc("arena_leave", { p_room_id: room.id });
    router.push("/arena");
  };

  const copyLink = async () => {
    try {
      await navigator.clipboard.writeText(
        `${window.location.origin}/arena/${code}`
      );
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {
      setErr("Gagal menyalin link.");
    }
  };

  const isHost = players.some((p) => p.user_id === me && p.is_host);

  if (err && !room) {
    return (
      <div className="lbwrap">
        <div className="empty">
          <div className="big">🌀</div>
          {err}
          <br />
          <br />
          <Link href="/arena" style={{ color: "var(--cyan)" }}>
            Kembali ke Arena
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="lbwrap">
      <h1 className="logo" style={{ fontSize: 26 }}>
        ⚔️ RUANG TUNGGU
      </h1>
      <p className="tagline">
        Bagikan kode atau link ini ke lawanmu. Battle dimulai saat host menekan
        tombol mulai.
      </p>

      <div className="codebox">{code}</div>
      <div style={{ display: "flex", gap: 10, justifyContent: "center" }}>
        <button className="btn ghost" onClick={copyLink}>
          {copied ? "✅ Tersalin!" : "📋 Salin Link"}
        </button>
      </div>

      <h2
        style={{
          fontFamily: "var(--font-pixel)",
          fontSize: 11,
          color: "var(--gold)",
          marginTop: 28,
        }}
      >
        PEMAIN ({players.length}/2)
      </h2>
      {players.map((p) => (
        <div className="player-row" key={p.user_id}>
          <span className="pemoji">{p.avatar}</span>
          <span className="pname">
            {p.username}
            {p.user_id === me ? " (kamu)" : ""}
          </span>
          {p.is_host && <span className="ptag">HOST</span>}
        </div>
      ))}
      {players.length < 2 && (
        <p className="tagline">Menunggu lawan bergabung…</p>
      )}

      {err && <p className="err">⚠️ {err}</p>}

      <div
        style={{
          display: "flex",
          gap: 10,
          marginTop: 24,
          justifyContent: "center",
          flexWrap: "wrap",
        }}
      >
        {isHost && (
          <button
            className="btn gold"
            onClick={start}
            disabled={busy || players.length < 2}
          >
            {busy ? "Memulai…" : "⚔️ Mulai Battle"}
          </button>
        )}
        <button className="btn ghost" onClick={leave} disabled={busy}>
          Keluar Room
        </button>
      </div>
    </div>
  );
}
