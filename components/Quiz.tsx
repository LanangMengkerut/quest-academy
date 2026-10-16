"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useSound } from "@/lib/useSound";
import { sfx } from "@/lib/sfx";
import { BADGES, starsForScore } from "@/lib/game";

type QuizQuestion = { id: string; q: string; options: string[] };

type StartResult = {
  session_id: string;
  stage_title: string;
  course_id: string;
  boss_icon: string;
  boss_name: string;
  questions: QuizQuestion[];
};

type AnswerResult = {
  correct: boolean;
  correct_option: number;
  explanation: string;
  answered: number;
  total: number;
  correct_count: number;
  player_hp: number;
  finished: boolean;
  passed?: boolean;
  score?: number;
  xp_earned?: number;
  prev_best?: number;
  new_badges?: string[];
};

export function Quiz({
  courseId,
  stageId,
  kind,
}: {
  courseId: string;
  stageId: string;
  kind: "battle" | "checkpoint";
}) {
  const router = useRouter();
  const [sound] = useSound();
  const muted = !sound;
  const [session, setSession] = useState<StartResult | null>(null);
  const [qi, setQi] = useState(0);
  const [picked, setPicked] = useState<number | null>(null);
  const [result, setResult] = useState<AnswerResult | null>(null);
  const [final, setFinal] = useState<AnswerResult | null>(null);
  const [bossHp, setBossHp] = useState(0);
  const [playerHp, setPlayerHp] = useState(3);
  const [error, setError] = useState<string | null>(null);
  const startedRef = useRef(false);

  const start = useCallback(async () => {
    const supabase = createClient();
    const { data, error } = await supabase.rpc("start_session", {
      p_stage_id: stageId,
      p_kind: kind,
    });
    if (error) {
      setError(error.message);
      return;
    }
    const s = data as StartResult;
    setSession(s);
    setBossHp(s.questions.length);
    setPlayerHp(3);
    setQi(0);
    setPicked(null);
    setResult(null);
    setFinal(null);
  }, [stageId, kind]);

  useEffect(() => {
    if (startedRef.current) return;
    startedRef.current = true;
    void start();
  }, [start]);

  if (error) {
    return (
      <div className="empty">
        <div className="big">⚠️</div>
        {error}
        <br />
        <br />
        <Link className="btn ghost" href={`/course/${courseId}/stage/${stageId}`}>
          Kembali ke stage
        </Link>
      </div>
    );
  }

  if (!session) {
    return (
      <div className="empty">
        <div className="big">⏳</div>
        Menyiapkan {kind === "battle" ? "battle" : "checkpoint"}...
      </div>
    );
  }

  if (final) {
    if (kind === "checkpoint") {
      return (
        <div className="result">
          <div className="big">{final.passed ? "✅" : "🔁"}</div>
          <h2 className={final.passed ? "win" : "lose"}>
            {final.passed ? "CHECKPOINT LULUS!" : "BELUM LULUS"}
          </h2>
          <p style={{ color: "var(--dim)" }}>
            Benar {final.correct_count}/{final.total}.{" "}
            {final.passed
              ? "Battle stage ini sekarang terbuka. Gas!"
              : "Baca lagi penjelasannya, lalu coba lagi. Kamu pasti bisa! 💪"}
          </p>
          <div className="rbtns">
            {final.passed ? (
              <Link
                className="btn gold"
                href={`/course/${courseId}/stage/${stageId}/battle`}
              >
                ⚔️ KE BATTLE
              </Link>
            ) : (
              <Link
                className="btn gold"
                href={`/course/${courseId}/stage/${stageId}/learn`}
              >
                📖 BACA LAGI
              </Link>
            )}
            <Link
              className="btn ghost"
              href={`/course/${courseId}/stage/${stageId}`}
            >
              ← Kembali
            </Link>
          </div>
        </div>
      );
    }
    const score = final.score ?? 0;
    const stars = starsForScore(score);
    const win = score >= 60;
    return (
      <div className="result">
        <div className="big">{win ? "🏆" : "💀"}</div>
        <h2 className={win ? "win" : "lose"}>{win ? "BOSS TUMBANG!" : "KALAH..."}</h2>
        <p style={{ color: "var(--dim)" }}>
          {session.stage_title} — benar {final.correct_count}/{final.total} ({score})
        </p>
        <div className="stars">
          {[0, 1, 2].map((k) => (
            <span
              key={k}
              className={k < stars ? "" : "off"}
              style={k < stars ? undefined : { color: "#3a4066" }}
            >
              ★
            </span>
          ))}
        </div>
        <div className="xp-gain">
          +{final.xp_earned ?? 0} XP
          {(final.prev_best ?? 0) > 0 && score <= (final.prev_best ?? 0)
            ? " (pengulangan: 10% XP)"
            : ""}
          <br />
          Skor terbaik stage ini: {Math.max(final.prev_best ?? 0, score)}
        </div>
        {final.new_badges && final.new_badges.length > 0 ? (
          <p style={{ color: "var(--gold)" }}>
            🏅 Badge baru:{" "}
            {final.new_badges
              .map((id) => BADGES.find((b) => b.id === id)?.name ?? id)
              .join(", ")}
          </p>
        ) : null}
        <div className="rbtns">
          <button
            className="btn gold"
            onClick={() => {
              sfx.click(muted);
              void start();
            }}
          >
            ⚔️ MAIN LAGI
          </button>
          <Link className="btn ghost" href={`/course/${courseId}`}>
            ← Kembali
          </Link>
          <Link className="btn ghost" href="/leaderboard">
            🏆 Leaderboard
          </Link>
        </div>
      </div>
    );
  }

  const q = session.questions[qi];
  const bossPct = session.questions.length
    ? (bossHp / session.questions.length) * 100
    : 0;
  const playPct = (playerHp / 3) * 100;

  const answer = async (i: number) => {
    if (picked !== null) return;
    setPicked(i);
    const supabase = createClient();
    const { data, error } = await supabase.rpc("answer_question", {
      p_session_id: session.session_id,
      p_question_id: q.id,
      p_option: i,
    });
    if (error) {
      setError(error.message);
      return;
    }
    const r = data as AnswerResult;
    setResult(r);
    setBossHp(r.total - r.correct_count);
    setPlayerHp(r.player_hp);
    if (r.correct) sfx.correct(muted);
    else sfx.wrong(muted);
    if (r.finished) {
      if (kind === "battle") {
        if ((r.score ?? 0) >= 60) sfx.win(muted);
        else sfx.lose(muted);
      }
      if (r.new_badges && r.new_badges.length > 0) sfx.badge(muted);
    }
  };

  const next = () => {
    sfx.click(muted);
    if (result?.finished) {
      setFinal(result);
      router.refresh();
      return;
    }
    setQi((v) => v + 1);
    setPicked(null);
    setResult(null);
  };

  return (
    <div>
      <div className="crumb">
        <Link href={`/course/${courseId}/stage/${stageId}`}>
          ← Menyerah &amp; kembali
        </Link>
      </div>
      <div className="arena" style={{ position: "relative" }}>
        {kind === "battle" ? (
          <div className="fighters">
            <div className="fighter you">
              <div className="fname">🧙 KAMU</div>
              <div className="femoji">🧙</div>
              <div className="fhp">
                <div style={{ width: `${playPct}%` }}></div>
              </div>
            </div>
            <div className="vs">VS</div>
            <div className="fighter boss">
              <div className="fname">
                {session.boss_icon} {session.boss_name}
              </div>
              <div className="femoji">{session.boss_icon}</div>
              <div className="fhp">
                <div style={{ width: `${bossPct}%` }}></div>
              </div>
            </div>
          </div>
        ) : (
          <p className="tagline" style={{ textAlign: "left" }}>
            🚧 Checkpoint — jawab semua soal ini untuk membuktikan kamu paham.
            Benar {result ? result.correct_count : 0} sejauh ini.
          </p>
        )}
        <div className="qcard">
          <div className="qnum">
            SOAL {qi + 1} / {session.questions.length}
          </div>
          <div className="qtext">{q.q}</div>
          <div id="opts">
            {q.options.map((o, i) => {
              let cls = "opt";
              if (picked !== null && result) {
                if (i === result.correct_option) cls += " correct";
                else if (i === picked) cls += " wrong";
              }
              return (
                <button
                  key={i}
                  className={cls}
                  disabled={picked !== null}
                  onClick={() => void answer(i)}
                >
                  <span className="k">{"ABCD"[i]}</span>
                  {o}
                </button>
              );
            })}
          </div>
          {result ? (
            <div id="xpl">
              <div className="explain">💡 {result.explanation}</div>
              <div style={{ marginTop: 14, textAlign: "right" }}>
                <button className="btn" onClick={next}>
                  {result.finished
                    ? "LIHAT HASIL 🏁"
                    : "SOAL BERIKUTNYA →"}
                </button>
              </div>
            </div>
          ) : null}
        </div>
      </div>
    </div>
  );
}
