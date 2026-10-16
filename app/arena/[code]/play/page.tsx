"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

type Fighter = {
  id: string;
  username: string;
  avatar: string;
  hp: number;
};

type Question = {
  q: string;
  options: string[];
  answered: number;
  total: number;
};

type Feedback = {
  correct: boolean;
  correctOption: number;
  explanation: string;
};

export default function ArenaBattle() {
  const params = useParams();
  const router = useRouter();
  const code = String(params.code ?? "").toUpperCase();

  const [roomId, setRoomId] = useState("");
  const [me, setMe] = useState<Fighter | null>(null);
  const [opp, setOpp] = useState<Fighter | null>(null);
  const [q, setQ] = useState<Question | null>(null);
  const [waitingOpp, setWaitingOpp] = useState(false);
  const [picked, setPicked] = useState<number | null>(null);
  const [fb, setFb] = useState<Feedback | null>(null);
  const [busy, setBusy] = useState(false);
  const [result, setResult] = useState<"win" | "lose" | "draw" | null>(null);
  const [myCorrect, setMyCorrect] = useState(0);
  const [myAnswered, setMyAnswered] = useState(0);
  const [hitMe, setHitMe] = useState(false);
  const [hitOpp, setHitOpp] = useState(false);
  const [err, setErr] = useState("");
  const hpRef = useRef({ me: 100, opp: 100 });

  const fetchFighters = useCallback(
    async (rid: string, myId: string) => {
      const supabase = createClient();
      const { data: pls } = await supabase
        .from("arena_players")
        .select("user_id, hp, answered, correct")
        .eq("room_id", rid)
        .neq("status", "left");
      const list = (pls ?? []) as {
        user_id: string;
        hp: number;
        answered: number;
        correct: number;
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
      for (const p of list) {
        const f: Fighter = {
          id: p.user_id,
          username: profMap.get(p.user_id)?.username ?? "?",
          avatar: profMap.get(p.user_id)?.avatar ?? "🧙",
          hp: p.hp,
        };
        if (p.user_id === myId) {
          if (p.hp < hpRef.current.me) {
            setHitMe(true);
            setTimeout(() => setHitMe(false), 450);
          }
          hpRef.current.me = p.hp;
          setMe(f);
          setMyCorrect(p.correct);
          setMyAnswered(p.answered);
        } else {
          if (p.hp < hpRef.current.opp) {
            setHitOpp(true);
            setTimeout(() => setHitOpp(false), 450);
          }
          hpRef.current.opp = p.hp;
          setOpp(f);
        }
      }
    },
    []
  );

  const resolveResult = useCallback(async (rid: string, myId: string) => {
    const supabase = createClient();
    const { data } = await supabase
      .from("arena_rooms")
      .select("winner_id")
      .eq("id", rid)
      .single();
    const w = (data as { winner_id: string | null } | null)?.winner_id ?? null;
    setResult(w === null ? "draw" : w === myId ? "win" : "lose");
    await fetchFighters(rid, myId);
  }, [fetchFighters]);

  const loadQuestion = useCallback(
    async (rid: string, myId: string) => {
      const supabase = createClient();
      const { data, error } = await supabase.rpc("arena_get_question", {
        p_room_id: rid,
      });
      if (error) {
        // Room mungkin sudah selesai (mis. lawan menyerah)
        const { data: rm } = await supabase
          .from("arena_rooms")
          .select("status")
          .eq("id", rid)
          .single();
        if ((rm as { status: string } | null)?.status === "finished") {
          await resolveResult(rid, myId);
        } else {
          setErr(error.message);
        }
        return;
      }
      const d = data as {
        done: boolean;
        q?: string;
        options?: string[];
        answered?: number;
        total?: number;
      };
      if (d.done) {
        setWaitingOpp(true);
        setQ(null);
      } else {
        setWaitingOpp(false);
        setQ({
          q: d.q ?? "",
          options: d.options ?? [],
          answered: d.answered ?? 0,
          total: d.total ?? 0,
        });
      }
      setPicked(null);
      setFb(null);
    },
    [resolveResult]
  );

  // init
  useEffect(() => {
    (async () => {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login");
        return;
      }
      const { data: r, error } = await supabase
        .from("arena_rooms")
        .select("id, status")
        .eq("code", code)
        .single();
      if (error || !r) {
        setErr("Room tidak ditemukan.");
        return;
      }
      const rm = r as { id: string; status: string };
      if (rm.status === "finished") {
        setRoomId(rm.id);
        await resolveResult(rm.id, user.id);
        return;
      }
      if (rm.status !== "playing") {
        router.push(`/arena/${code}`);
        return;
      }
      setRoomId(rm.id);
      hpRef.current = { me: 100, opp: 100 };
      await fetchFighters(rm.id, user.id);
      await loadQuestion(rm.id, user.id);
    })();
  }, [code, router, fetchFighters, loadQuestion, resolveResult]);

  // realtime: HP bar + akhir game
  useEffect(() => {
    if (!roomId) return;
    let myId = "";
    createClient()
      .auth.getUser()
      .then(({ data }) => {
        myId = data.user?.id ?? "";
      });
    const supabase = createClient();
    const ch = supabase
      .channel(`arena-play-${roomId}`)
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "arena_players",
          filter: `room_id=eq.${roomId}`,
        },
        async () => {
          const {
            data: { user },
          } = await supabase.auth.getUser();
          if (user) fetchFighters(roomId, user.id);
        }
      )
      .on(
        "postgres_changes",
        {
          event: "UPDATE",
          schema: "public",
          table: "arena_rooms",
          filter: `id=eq.${roomId}`,
        },
        async (payload) => {
          const s = (payload.new as { status?: string }).status;
          if (s === "finished" && myId) resolveResult(roomId, myId);
        }
      )
      .subscribe();
    return () => {
      supabase.removeChannel(ch);
    };
  }, [roomId, fetchFighters, resolveResult]);

  const answer = async (idx: number) => {
    if (busy || picked !== null || !roomId || result) return;
    setBusy(true);
    setPicked(idx);
    const supabase = createClient();
    const { data, error } = await supabase.rpc("arena_answer", {
      p_room_id: roomId,
      p_option: idx,
    });
    setBusy(false);
    if (error) {
      setErr(error.message);
      setPicked(null);
      return;
    }
    const d = data as {
      correct: boolean;
      correct_option: number;
      explanation: string;
      my_hp: number;
      opp_hp: number;
      my_answered: number;
      my_correct: number;
      game_over: boolean;
      result: "win" | "lose" | "draw" | null;
    };
    // animasi serangan langsung dari respons (lebih cepat dari realtime)
    if (d.correct && d.opp_hp < hpRef.current.opp) {
      setHitOpp(true);
      setTimeout(() => setHitOpp(false), 450);
    }
    hpRef.current = { me: d.my_hp, opp: d.opp_hp };
    setMe((m) => (m ? { ...m, hp: d.my_hp } : m));
    setOpp((o) => (o ? { ...o, hp: d.opp_hp } : o));
    setMyCorrect(d.my_correct);
    setMyAnswered(d.my_answered);
    setFb({
      correct: d.correct,
      correctOption: d.correct_option,
      explanation: d.explanation,
    });
    // Baca ulang dari DB sebagai konfirmasi (jaga-jaga kalau realtime tersendat)
    if (me) fetchFighters(roomId, me.id);
    if (d.game_over && d.result) {
      setTimeout(() => setResult(d.result), 1800);
    } else {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      setTimeout(() => {
        if (user) loadQuestion(roomId, user.id);
      }, 1700);
    }
  };

  const forfeit = async () => {
    if (!roomId || !confirm("Menyerah? Lawan otomatis menang.")) return;
    const supabase = createClient();
    await supabase.rpc("arena_leave", { p_room_id: roomId });
    router.push("/arena");
  };

  const rematch = async () => {
    const supabase = createClient();
    const { data, error } = await supabase.rpc("arena_create_room", {
      p_mode: "battle",
    });
    if (!error && data) router.push(`/arena/${(data as { code: string }).code}`);
  };

  if (result) {
    const conf =
      result === "win"
        ? { e: "🏆", t: "KAMU MENANG!", c: "var(--gold)" }
        : result === "lose"
          ? { e: "💀", t: "KAMU KALAH", c: "var(--red)" }
          : { e: "🤝", t: "SERI!", c: "var(--cyan)" };
    return (
      <div className="lbwrap">
        <div className="arena-result">
          <div className="big">{conf.e}</div>
          <h2 style={{ color: conf.c }}>{conf.t}</h2>
          <p>
            {me?.username} vs {opp?.username} — benar {myCorrect} dari{" "}
            {myAnswered} soal
          </p>
          <div
            style={{
              display: "flex",
              gap: 10,
              justifyContent: "center",
              marginTop: 24,
              flexWrap: "wrap",
            }}
          >
            <button className="btn gold" onClick={rematch}>
              🔄 Rematch
            </button>
            <Link href="/arena" className="btn ghost">
              Kembali ke Arena
            </Link>
            <Link href="/arena/leaderboard" className="btn ghost">
              🏆 Leaderboard
            </Link>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="lbwrap">
      <div className="fighters">
        <div className="fighter you">
          <div className="fname">
            {me?.avatar} {me?.username ?? "…"}
          </div>
          <div className="fhp">
            <div style={{ width: `${me?.hp ?? 100}%` }} />
          </div>
          <div style={{ fontSize: 12, color: "var(--dim)", marginTop: 4 }}>
            HP {me?.hp ?? 100}
          </div>
          <div className={`femoji${hitMe ? " hit" : ""}`}>{me?.avatar ?? "🧙"}</div>
        </div>
        <div className="vs">VS</div>
        <div className="fighter foe">
          <div className="fname">
            {opp?.avatar} {opp?.username ?? "…"}
          </div>
          <div className="fhp">
            <div style={{ width: `${opp?.hp ?? 100}%` }} />
          </div>
          <div style={{ fontSize: 12, color: "var(--dim)", marginTop: 4 }}>
            HP {opp?.hp ?? 100}
          </div>
          <div className={`femoji${hitOpp ? " hit" : ""}`}>{opp?.avatar ?? "🧙"}</div>
        </div>
      </div>

      {err && <p className="err">⚠️ {err}</p>}

      {waitingOpp ? (
        <div className="empty">
          <div className="big">⏳</div>
          Deck soalmu habis. Menunggu lawan menyelesaikan soalnya…
        </div>
      ) : q ? (
        <div className="qcard">
          <div className="qnum">
            SOAL {q.answered + 1} / {q.total} — benar = −10 HP lawan
          </div>
          <div className="qtext">{q.q}</div>
          {q.options.map((opt, i) => {
            let cls = "opt";
            if (fb) {
              if (i === fb.correctOption) cls += " correct";
              else if (i === picked && !fb.correct) cls += " wrong";
            } else if (i === picked) cls += " picked";
            return (
              <button
                key={i}
                className={cls}
                disabled={picked !== null || busy}
                onClick={() => answer(i)}
              >
                <span className="k">{String.fromCharCode(65 + i)}</span>
                {opt}
              </button>
            );
          })}
          {fb && (
            <p style={{ color: "var(--dim)", fontSize: 14, marginTop: 12 }}>
              {fb.correct ? "✅ Benar! Lawan −10 HP." : "❌ Kurang tepat."}{" "}
              {fb.explanation}
            </p>
          )}
        </div>
      ) : (
        <div className="empty">
          <div className="big">🎲</div>
          Menyiapkan soal…
        </div>
      )}

      <div style={{ textAlign: "center", marginTop: 20 }}>
        <button className="btn ghost" onClick={forfeit}>
          🏳️ Menyerah
        </button>
      </div>
    </div>
  );
}
