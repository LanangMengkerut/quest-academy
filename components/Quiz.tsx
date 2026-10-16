"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { AnimatePresence, motion } from "framer-motion";
import { createClient } from "@/lib/supabase/client";
import { useExamGuard, exitFullscreen, MAX_VIOLATIONS } from "@/lib/useExamGuard";
import { ExamOverlay } from "@/components/ExamOverlay";
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

type Pose = "idle" | "attack" | "hit" | "dead" | "win" | "pass";
type Floater = { id: number; side: "player" | "boss" | "guardian"; text: string; cls: string };
type Bubble = { id: number; who: "player" | "boss" | "guardian"; text: string };

const BOSS_INTRO = [
  "Berani-beraninya masuk wilayahku!",
  "Hmph. Satu lagi yang mau coba-coba.",
  "Jawab dengan benar, atau pulang dengan malu!",
];
const BOSS_HURT = ["Argh!", "Lumayan juga kamu...", "Itu cuma goresan!", "Awas kamu ya!"];
const BOSS_TAUNT = ["Hahaha! Segitu saja?", "Pulang saja sana!", "Salah! Rasakan itu!", "Masih jauh, anak muda."];
const BOSS_ENRAGE = "GRAAAH! Aku serius sekarang!";
const PLAYER_GOOD = ["Kena kamu!", "Begitu dong!", "Satu lagi!", "Mantap!"];
const GUARDIAN_OK = ["Bagus. Kamu paham.", "Silakan lewat... sebentar lagi.", "Benar. Lanjutkan."];
const GUARDIAN_NO = ["Belum. Baca lagi materinya.", "Gerbang tetap tertutup.", "Jawaban itu belum cukup."];

const pick = (arr: string[]) => arr[Math.floor(Math.random() * arr.length)];

function poseAnimate(pose: Pose, dir: 1 | -1) {
  switch (pose) {
    case "attack":
      return { x: [0, 30 * dir, 0], rotate: [0, 4 * dir, 0], scale: [1, 1.08, 1] };
    case "hit":
      return {
        x: [0, -12 * dir, 9 * dir, -6 * dir, 3 * dir, 0],
        rotate: [0, -5 * dir, 4 * dir, -2 * dir, 0],
        scale: [1, 0.9, 1.05, 1],
      };
    case "dead":
      return { rotate: 78 * dir, y: 16, opacity: 0.5, scale: 0.94, x: 0 };
    case "win":
      return { y: [0, -18, 0, -18, 0], rotate: [0, -4, 0, 4, 0], x: 0, opacity: 1, scale: 1 };
    case "pass":
      return { y: [0, -12, 0], scale: [1, 1.12, 1], rotate: [0, -3, 0], x: 0, opacity: 1 };
    default:
      return { x: 0, rotate: 0, scale: 1, opacity: 1, y: 0 };
  }
}

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
  const [playerPose, setPlayerPose] = useState<Pose>("idle");
  const [bossPose, setBossPose] = useState<Pose>("idle");
  const [guardianPose, setGuardianPose] = useState<Pose>("idle");
  const [floaters, setFloaters] = useState<Floater[]>([]);
  const [bubble, setBubble] = useState<Bubble | null>(null);
  const [cpCorrect, setCpCorrect] = useState(0);
  const [begun, setBegun] = useState(false);
  const [dq, setDq] = useState(false);
  const startedRef = useRef(false);
  const timersRef = useRef<number[]>([]);
  const fxIdRef = useRef(0);
  const enragedRef = useRef(false);

  // Mode Fokus: battle only, checkpoint is never guarded.
  const exam = useExamGuard({
    active: kind === "battle" && begun && !!session && !final && !dq,
    onTerminate: () => setDq(true),
  });

  useEffect(() => {
    if (final || dq) exitFullscreen();
  }, [final, dq]);

  const later = useCallback((fn: () => void, ms: number) => {
    const id = window.setTimeout(fn, ms);
    timersRef.current.push(id);
  }, []);

  useEffect(() => {
    const timers = timersRef.current;
    return () => timers.forEach((t) => window.clearTimeout(t));
  }, []);

  const addFloater = useCallback(
    (side: Floater["side"], text: string, cls: string) => {
      const id = ++fxIdRef.current;
      setFloaters((f) => [...f.slice(-3), { id, side, text, cls }]);
      later(() => setFloaters((f) => f.filter((x) => x.id !== id)), 950);
    },
    [later],
  );

  const say = useCallback(
    (who: Bubble["who"], text: string) => {
      const id = ++fxIdRef.current;
      setBubble({ id, who, text });
      later(() => {
        setBubble((b) => (b && b.id === id ? null : b));
      }, 2300);
    },
    [later],
  );

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
    setPlayerPose("idle");
    setBossPose("idle");
    setGuardianPose("idle");
    setCpCorrect(0);
    enragedRef.current = false;
    if (kind === "battle") {
      later(() => say("boss", pick(BOSS_INTRO)), 350);
    }
  }, [stageId, kind, later, say]);

  useEffect(() => {
    if (kind !== "checkpoint") return; // battle starts from the Mode Fokus gate
    if (startedRef.current) return;
    startedRef.current = true;
    void start();
  }, [start, kind]);

  const beginBattle = () => {
    sfx.click(muted);
    setBegun(true);
    void exam.engage();
    void start();
  };

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

  if (kind === "battle" && !begun) {
    return (
      <div>
        <div className="crumb">
          <Link href={`/course/${courseId}/stage/${stageId}`}>
            ← Kembali ke stage
          </Link>
        </div>
        <div className="exam-box" style={{ margin: "0 auto" }}>
          <div className="big">🛡️</div>
          <h2>MODE FOKUS</h2>
          <p style={{ color: "var(--dim)" }}>
            Battle dimainkan dalam Mode Fokus anti-AI, biar leaderboard adil
            buat semua:
          </p>
          <ul
            style={{
              textAlign: "left",
              color: "var(--dim)",
              lineHeight: 1.9,
              fontSize: 14,
              paddingLeft: 20,
            }}
          >
            <li>Layar jadi fullscreen otomatis (bila browser mendukung).</li>
            <li>
              Jangan pindah tab/aplikasi, keluar fullscreen, atau membagi
              layar (split-screen) selama battle.
            </li>
            <li>
              Keluar di bawah ±2 detik dimaafkan; lebih dari itu dihitung
              pelanggaran dan sesi dijeda.
            </li>
            <li>
              {MAX_VIOLATIONS}× pelanggaran = sesi dihentikan tanpa XP.
            </li>
            <li>Boleh main di HP maupun PC. Checkpoint tidak memakai mode ini.</li>
          </ul>
          <div className="rbtns">
            <button className="btn gold" onClick={beginBattle}>
              ⚔️ MULAI BATTLE
            </button>
          </div>
        </div>
      </div>
    );
  }

  if (!session) {
    return (
      <div className="empty">
        <motion.div
          className="big"
          animate={{ rotate: [0, 12, -12, 0], scale: [1, 1.15, 1] }}
          transition={{ repeat: Infinity, duration: 1.2 }}
        >
          ⏳
        </motion.div>
        Menyiapkan {kind === "battle" ? "battle" : "checkpoint"}...
      </div>
    );
  }

  if (dq) {
    return (
      <div className="result">
        <div className="big">💀</div>
        <h2 className="lose">SESI DIHENTIKAN</h2>
        <p style={{ color: "var(--dim)" }}>
          Kamu melakukan {MAX_VIOLATIONS}× pelanggaran Mode Fokus, jadi
          battle ini dihentikan dan tidak menghasilkan XP. Main bersih ya —
          tanpa bantuan AI. 🛡️
        </p>
        <div className="rbtns">
          <button
            className="btn gold"
            onClick={() => {
              sfx.click(muted);
              setDq(false);
              setSession(null);
              setBegun(false);
              exam.reset();
            }}
          >
            ⚔️ COBA LAGI
          </button>
          <Link
            className="btn ghost"
            href={`/course/${courseId}/stage/${stageId}`}
          >
            ← Kembali ke stage
          </Link>
        </div>
      </div>
    );
  }

  if (final) {
    if (kind === "checkpoint") {
      return (
        <motion.div
          className="result"
          initial={{ opacity: 0, scale: 0.85 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ type: "spring", stiffness: 120, damping: 16 }}
        >
          <motion.div
            className="big"
            animate={final.passed ? { y: [0, -12, 0] } : { rotate: [0, -8, 8, 0] }}
            transition={{ repeat: 2, duration: 0.5 }}
          >
            {final.passed ? "✅" : "🔁"}
          </motion.div>
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
        </motion.div>
      );
    }
    const score = final.score ?? 0;
    const stars = starsForScore(score);
    const win = score >= 60;
    return (
      <motion.div
        className="result"
        initial={{ opacity: 0, scale: 0.85 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ type: "spring", stiffness: 120, damping: 16 }}
      >
        <motion.div
          className="big"
          animate={win ? { y: [0, -14, 0] } : { rotate: [0, -6, 6, 0] }}
          transition={{ repeat: 2, duration: 0.5 }}
        >
          {win ? "🏆" : "💀"}
        </motion.div>
        <h2 className={win ? "win" : "lose"}>{win ? "BOSS TUMBANG!" : "KALAH..."}</h2>
        <p style={{ color: "var(--dim)" }}>
          {session.stage_title} — benar {final.correct_count}/{final.total} ({score})
        </p>
        <div className="stars">
          {[0, 1, 2].map((k) => (
            <motion.span
              key={k}
              initial={{ scale: 0, rotate: -40 }}
              animate={{ scale: 1, rotate: 0 }}
              transition={{ delay: 0.35 + k * 0.22, type: "spring", stiffness: 200, damping: 12 }}
              className={k < stars ? "" : "off"}
              style={k < stars ? undefined : { color: "#3a4066" }}
            >
              ★
            </motion.span>
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
          <motion.p
            style={{ color: "var(--gold)" }}
            initial={{ scale: 0.6, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ delay: 0.5, type: "spring", stiffness: 160, damping: 13 }}
          >
            🏅 Badge baru:{" "}
            {final.new_badges
              .map((id) => BADGES.find((b) => b.id === id)?.name ?? id)
              .join(", ")}
          </motion.p>
        ) : null}
        <div className="rbtns">
          <button
            className="btn gold"
            onClick={() => {
              sfx.click(muted);
              void exam.restart();
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
      </motion.div>
    );
  }

  const q = session.questions[qi];
  const bossPct = session.questions.length
    ? (bossHp / session.questions.length) * 100
    : 0;
  const playPct = (playerHp / 3) * 100;
  const bossEnraged = kind === "battle" && bossHp > 0 && bossPct <= 34;

  const renderFloaters = (side: Floater["side"]) => (
    <div className="floaters">
      <AnimatePresence>
        {floaters
          .filter((f) => f.side === side)
          .map((f) => (
            <motion.div
              key={f.id}
              className={`floater ${f.cls}`}
              initial={{ opacity: 0, y: 6, scale: 0.7 }}
              animate={{ opacity: 1, y: -44, scale: 1.15 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.85, ease: "easeOut" }}
            >
              {f.text}
            </motion.div>
          ))}
      </AnimatePresence>
    </div>
  );

  const renderBubble = (who: Bubble["who"]) => (
    <AnimatePresence>
      {bubble && bubble.who === who ? (
        <motion.div
          key={bubble.id}
          className="bubble"
          initial={{ opacity: 0, scale: 0.6, y: 6 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.7 }}
          transition={{ type: "spring", stiffness: 260, damping: 18 }}
        >
          {bubble.text}
        </motion.div>
      ) : null}
    </AnimatePresence>
  );

  const answer = async (i: number) => {
    if (kind === "battle" && exam.covered) return; // Mode Fokus pause blocks answers
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

    if (kind === "checkpoint") {
      setCpCorrect(r.correct_count);
      if (r.correct) {
        setGuardianPose("pass");
        addFloater("guardian", "✔ BENAR", "good");
        if (Math.random() < 0.6) say("guardian", pick(GUARDIAN_OK));
      } else {
        setGuardianPose("hit");
        addFloater("guardian", "✘ SALAH", "bad");
        if (Math.random() < 0.7) say("guardian", pick(GUARDIAN_NO));
      }
      later(() => setGuardianPose("idle"), 600);
    } else if (r.correct) {
      setPlayerPose("attack");
      setBossPose("hit");
      addFloater("boss", "💥 HIT!", "dmg");
      if (Math.random() < 0.45) say("boss", pick(BOSS_HURT));
      else if (Math.random() < 0.35) say("player", pick(PLAYER_GOOD));
      later(() => {
        setPlayerPose("idle");
        setBossPose("idle");
      }, 600);
      const remaining = r.total - r.correct_count;
      if (!r.finished && remaining > 0 && remaining / r.total <= 0.34 && !enragedRef.current) {
        enragedRef.current = true;
        later(() => say("boss", BOSS_ENRAGE), 700);
      }
    } else {
      setBossPose("attack");
      setPlayerPose("hit");
      addFloater("player", "-1 HP", "dmg");
      if (Math.random() < 0.55) say("boss", pick(BOSS_TAUNT));
      later(() => {
        setBossPose("idle");
        setPlayerPose("idle");
      }, 600);
    }

    if (r.correct) sfx.correct(muted);
    else sfx.wrong(muted);
    if (r.finished) {
      if (kind === "battle") {
        const playerWon = (r.score ?? 0) >= 60;
        later(() => {
          setBossPose(playerWon ? "dead" : "win");
          setPlayerPose(playerWon ? "win" : "dead");
          if (playerWon) say("player", "Menang! 🎉");
        }, 650);
        if (playerWon) sfx.win(muted);
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
    setBubble(null);
  };

  return (
    <div
      onContextMenu={kind === "battle" ? (e) => e.preventDefault() : undefined}
      onCopy={kind === "battle" ? (e) => e.preventDefault() : undefined}
    >
      <div className="crumb">
        <Link href={`/course/${courseId}/stage/${stageId}`}>
          ← Menyerah &amp; kembali
        </Link>
      </div>
      {kind === "battle" ? (
        <div style={{ marginBottom: 10 }}>
          <span
            className={`exam-chip${exam.violations >= MAX_VIOLATIONS - 1 ? " warn" : ""}`}
          >
            🛡️ Mode Fokus — pelanggaran {exam.violations}/{MAX_VIOLATIONS}
          </span>
        </div>
      ) : null}
      <div className="arena" style={{ position: "relative" }}>
        {kind === "battle" ? (
          <div className="fighters">
            <div className="fighter you">
              <div className="fname">🧙 KAMU</div>
              <div className="fstage">
                {renderBubble("player")}
                {renderFloaters("player")}
                <motion.div
                  animate={poseAnimate(playerPose, 1)}
                  transition={{ duration: 0.55, ease: "easeInOut" }}
                >
                  <motion.div
                    className="femoji"
                    animate={{ y: [0, -6, 0] }}
                    transition={{ repeat: Infinity, duration: 2.1, ease: "easeInOut" }}
                  >
                    {playerHp === 1 && playerPose === "idle" ? "😰" : "🧙"}
                  </motion.div>
                </motion.div>
                <div className="fshadow" />
              </div>
              <div className="fhp">
                <motion.div
                  animate={{ width: `${playPct}%` }}
                  transition={{ type: "spring", stiffness: 90, damping: 20 }}
                ></motion.div>
              </div>
            </div>
            <motion.div
              className="vs"
              animate={{ scale: [1, 1.15, 1], rotate: [0, -3, 3, 0] }}
              transition={{ repeat: Infinity, duration: 1.8 }}
            >
              VS
            </motion.div>
            <div className={`fighter boss ${bossEnraged ? "enraged" : ""}`}>
              <div className="fname">
                {session.boss_icon} {session.boss_name}
                {bossEnraged ? " 🔥" : ""}
              </div>
              <div className="fstage">
                {renderBubble("boss")}
                {renderFloaters("boss")}
                <motion.div
                  animate={poseAnimate(bossPose, -1)}
                  transition={{ duration: 0.55, ease: "easeInOut" }}
                >
                  <motion.div
                    className="femoji"
                    animate={{ y: [0, -8, 0], rotate: [0, -2, 2, 0] }}
                    transition={{ repeat: Infinity, duration: 2.6, ease: "easeInOut" }}
                  >
                    {session.boss_icon}
                  </motion.div>
                </motion.div>
                <div className="fshadow" />
              </div>
              <div className="fhp">
                <motion.div
                  animate={{ width: `${bossPct}%` }}
                  transition={{ type: "spring", stiffness: 90, damping: 20 }}
                ></motion.div>
              </div>
            </div>
          </div>
        ) : (
          <div className="guardian">
            <div className="fstage">
              {renderBubble("guardian")}
              {renderFloaters("guardian")}
              <motion.div
                animate={poseAnimate(guardianPose, 1)}
                transition={{ duration: 0.55, ease: "easeInOut" }}
              >
                <motion.div
                  className="femoji"
                  animate={{ y: [0, -5, 0] }}
                  transition={{ repeat: Infinity, duration: 2.4, ease: "easeInOut" }}
                >
                  🗿
                </motion.div>
              </motion.div>
              <div className="fshadow" />
            </div>
            <p className="tagline" style={{ textAlign: "center", marginTop: 10 }}>
              🚧 <b>PENJAGA GERBANG</b> — jawab semua soal ini untuk membuktikan kamu
              paham. Benar {cpCorrect}/{session.questions.length} sejauh ini.
            </p>
          </div>
        )}
        <div
          className="qcard"
          style={kind === "battle" ? { userSelect: "none" } : undefined}
        >
          <AnimatePresence>
            <motion.div
              key={qi}
              initial={{ opacity: 0, x: 40 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -40, transition: { duration: 0.09 } }}
              transition={{ duration: 0.16, ease: "easeOut" }}
            >
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
                  } else if (picked !== null && i === picked) {
                    cls += " picked";
                  }
                  return (
                    <motion.button
                      key={i}
                      className={cls}
                      disabled={picked !== null}
                      onClick={() => void answer(i)}
                      whileHover={picked === null ? { scale: 1.02, x: 4 } : undefined}
                      whileTap={picked === null ? { scale: 0.97 } : undefined}
                    >
                      <span className="k">{"ABCD"[i]}</span>
                      {o}
                    </motion.button>
                  );
                })}
              </div>
            </motion.div>
          </AnimatePresence>
          {result ? (
            <motion.div
              id="xpl"
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.25 }}
            >
              <div className="explain">💡 {result.explanation}</div>
              <div style={{ marginTop: 14, textAlign: "right" }}>
                <button className="btn" onClick={next}>
                  {result.finished ? "LIHAT HASIL 🏁" : "SOAL BERIKUTNYA →"}
                </button>
              </div>
            </motion.div>
          ) : null}
        </div>
      </div>
      {kind === "battle" ? (
        <ExamOverlay
          covered={exam.covered}
          paused={exam.paused}
          violations={exam.violations}
          onResume={() => void exam.resume()}
        />
      ) : null}
    </div>
  );
}
