"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import type { Course } from "@/lib/types";

export type CourseStat = { courseId: string; stages: number; tq: number };

export function WorldGrid({
  courses,
  stats,
  done,
}: {
  courses: Course[];
  stats: CourseStat[];
  done: { courseId: string; done: number }[];
}) {
  const statOf = (id: string) =>
    stats.find((s) => s.courseId === id) ?? { stages: 0, tq: 0 };
  const doneOf = (id: string) => done.find((d) => d.courseId === id)?.done ?? 0;

  return (
    <div className="worlds">
      {courses.map((c, i) => {
        const st = statOf(c.id);
        const d = doneOf(c.id);
        const pct = st.stages ? Math.round((d / st.stages) * 100) : 0;
        return (
          <motion.div
            key={c.id}
            initial={{ opacity: 0, y: 34, scale: 0.96 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            transition={{ delay: 0.12 * i, type: "spring", stiffness: 90, damping: 16 }}
            whileHover={{ y: -6, scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            <Link className={`world ${c.id}`} href={`/course/${c.id}`}>
              <motion.div
                className="orb"
                animate={{ scale: [1, 1.25, 1], opacity: [0.7, 1, 0.7] }}
                transition={{ repeat: Infinity, duration: 2.6, delay: i * 0.4 }}
              ></motion.div>
              <div className="wic">{c.icon}</div>
              <h2>{c.title}</h2>
              <p>{c.tagline}</p>
              <div className="meta">
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
                  initial={{ width: 0 }}
                  animate={{ width: `${pct}%` }}
                  transition={{ delay: 0.3 + 0.12 * i, type: "spring", stiffness: 60, damping: 18 }}
                ></motion.div>
              </div>
              <div className="enter" style={{ marginTop: 14 }}>
                ▶ MASUK DUNIA
              </div>
            </Link>
          </motion.div>
        );
      })}
    </div>
  );
}
