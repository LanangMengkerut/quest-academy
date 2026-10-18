"use client";

import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { AnimatePresence, motion } from "framer-motion";
import type { Course } from "@/lib/types";
import { Sprite, BOSS_SPRITES } from "@/components/Sprite";
import { setMusicMood } from "@/lib/music";

export type CourseStat = { courseId: string; stages: number; tq: number };

const COLOR_HEX: Record<string, string> = {
  cyan: "#22d3ee",
  magenta: "#f471b5",
  orange: "#fb923c",
  gold: "#ffd23f",
};

const hexOf = (c: Course) => COLOR_HEX[c.color] ?? "#ffd23f";

const variants = {
  enter: (dir: number) => ({ x: dir >= 0 ? 140 : -140, opacity: 0, scale: 0.95 }),
  center: { x: 0, opacity: 1, scale: 1 },
  exit: (dir: number) => ({ x: dir >= 0 ? -140 : 140, opacity: 0, scale: 0.95 }),
};

/**
 * World picker: one focused world card at a time. Navigate with the
 * arrows, keyboard, swipe/drag, or the chips below. The page background
 * and the procedural music mood follow the focused world, and every
 * card has exactly the same geometry regardless of its content.
 */
export function WorldCarousel({
  courses,
  stats,
  done,
}: {
  courses: Course[];
  stats: CourseStat[];
  done: { courseId: string; done: number }[];
}) {
  const [[index, direction], setState] = useState<[number, number]>([0, 0]);
  const n = courses.length;

  const goTo = useCallback(
    (i: number, dir?: number) => {
      if (n === 0) return;
      const next = ((i % n) + n) % n;
      setState(([cur]) => [next, dir ?? (next > cur ? 1 : -1)]);
    },
    [n],
  );
  const paginate = useCallback(
    (dir: number) => {
      setState(([cur]) => [(((cur + dir) % n) + n) % n, dir]);
    },
    [n],
  );

  const course = courses[index];
  useEffect(() => {
    if (course) setMusicMood(course.id);
  }, [course]);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "ArrowLeft") paginate(-1);
      else if (e.key === "ArrowRight") paginate(1);
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [paginate]);

  if (!course) return null;
  const hex = hexOf(course);
  const st = stats.find((s) => s.courseId === course.id) ?? { stages: 0, tq: 0 };
  const d = done.find((x) => x.courseId === course.id)?.done ?? 0;
  const pct = st.stages ? Math.round((d / st.stages) * 100) : 0;
  const boss =
    course.boss_sprite && BOSS_SPRITES[course.boss_sprite]
      ? BOSS_SPRITES[course.boss_sprite]
      : null;

  return (
    <div className="showcase">
      {/* background follows the focused world */}
      <AnimatePresence>
        <motion.div
          key={course.id}
          className="world-bg"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.7 }}
          style={{
            background: `radial-gradient(620px 420px at 82% 18%, ${hex}30, transparent 65%), radial-gradient(700px 520px at 12% 88%, ${hex}22, transparent 65%), radial-gradient(420px 300px at 50% 110%, ${hex}18, transparent 70%)`,
          }}
        />
      </AnimatePresence>

      <button
        className="sc-arrow left"
        aria-label="Dunia sebelumnya"
        onClick={() => paginate(-1)}
      >
        ‹
      </button>

      <div className="sc-stage">
        <AnimatePresence mode="popLayout" custom={direction} initial={false}>
          <motion.div
            key={course.id}
            className="sc-card"
            style={{ borderColor: hex, boxShadow: `0 0 42px ${hex}33` }}
            custom={direction}
            variants={variants}
            initial="enter"
            animate="center"
            exit="exit"
            transition={{ type: "spring", stiffness: 300, damping: 30 }}
            drag="x"
            dragConstraints={{ left: 0, right: 0 }}
            dragElastic={0.6}
            onDragEnd={(_, info) => {
              if (info.offset.x < -80) paginate(1);
              else if (info.offset.x > 80) paginate(-1);
            }}
          >
            <div className="sc-boss">
              <motion.div
                className="orb"
                style={{ background: hex }}
                animate={{ scale: [1, 1.25, 1], opacity: [0.6, 0.95, 0.6] }}
                transition={{ repeat: Infinity, duration: 2.6 }}
              />
              {boss ? (
                <Sprite
                  src={boss.src}
                  rows={1}
                  frameAspect={boss.aspect}
                  size={150}
                  speed={1.4}
                />
              ) : (
                <div className="sc-boss-emoji">{course.boss_icon}</div>
              )}
            </div>
            <div className="sc-bossname" style={{ color: hex }}>
              {course.boss_icon} BOSS: {course.boss_name}
            </div>
            <h2 style={{ color: hex }}>
              {course.icon} {course.title}
            </h2>
            <p className="sc-tag">{course.tagline}</p>
            <div className="meta sc-meta">
              <span>
                📚 <b>{st.stages}</b> materi
              </span>
              <span>
                ❓ <b>{st.tq}</b> soal
              </span>
              <span>
                ✅ <b>{d}/{st.stages}</b> selesai
              </span>
            </div>
            <div className="pbar">
              <motion.div
                key={course.id}
                initial={{ width: 0 }}
                animate={{ width: `${pct}%` }}
                transition={{ type: "spring", stiffness: 60, damping: 18 }}
              />
            </div>
            <Link className="btn gold sc-enter" href={`/course/${course.id}`}>
              ▶ MASUK DUNIA
            </Link>
          </motion.div>
        </AnimatePresence>
      </div>

      <button
        className="sc-arrow right"
        aria-label="Dunia berikutnya"
        onClick={() => paginate(1)}
      >
        ›
      </button>

      <div className="sc-chips">
        {courses.map((c, i) => {
          const ch = hexOf(c);
          const active = i === index;
          return (
            <button
              key={c.id}
              className={`sc-chip${active ? " on" : ""}`}
              style={active ? { borderColor: ch, color: ch } : undefined}
              onClick={() => goTo(i)}
            >
              {c.icon} {c.title}
            </button>
          );
        })}
      </div>
      <div className="sc-hint">
        {index + 1} / {n} — geser kartu, pakai panah ‹ ›, atau tombol ← →
      </div>
    </div>
  );
}
