import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { BADGES } from "@/lib/game";
import type { Course } from "@/lib/types";

export default async function HomePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: coursesData } = await supabase
    .from("courses")
    .select("*")
    .order("sort_order");
  const courses = (coursesData ?? []) as Course[];

  // Per-course stage counts + question counts (from a public stats view).
  const { data: statsData } = await supabase
    .from("course_stats")
    .select("course_id, stages, battle_questions");
  const stats = new Map(
    (statsData ?? []).map((s) => [
      s.course_id as string,
      { stages: s.stages as number, tq: s.battle_questions as number },
    ]),
  );

  let doneByCourse = new Map<string, number>();
  let earnedBadges = new Set<string>();
  if (user) {
    const { data: prog } = await supabase
      .from("stage_progress")
      .select("stage_id, best_score, stages(course_id)")
      .eq("user_id", user.id);
    for (const row of prog ?? []) {
      const rel = row.stages as unknown as { course_id: string } | null;
      if (rel && row.best_score > 0) {
        doneByCourse.set(
          rel.course_id,
          (doneByCourse.get(rel.course_id) ?? 0) + 1,
        );
      }
    }
    const { data: badges } = await supabase
      .from("user_badges")
      .select("badge_id")
      .eq("user_id", user.id);
    earnedBadges = new Set((badges ?? []).map((b) => b.badge_id as string));
  }

  return (
    <div>
      <h1 className="logo">QUEST ACADEMY</h1>
      <p className="tagline">
        Sarana belajar berkedok game. Baca materinya, lewati checkpoint-nya,
        kalahkan boss-nya, naikkan levelmu.
      </p>
      {!user ? (
        <p className="tagline" style={{ marginBottom: 18 }}>
          <Link href="/login" style={{ color: "var(--cyan)" }}>
            Masuk
          </Link>{" "}
          atau{" "}
          <Link href="/register" style={{ color: "var(--cyan)" }}>
            daftar
          </Link>{" "}
          supaya progresmu tersimpan dan masuk leaderboard.
        </p>
      ) : null}
      <div className="press-start">▼ PILIH DUNIAMU ▼</div>
      <div className="worlds">
        {courses.map((c) => {
          const st = stats.get(c.id) ?? { stages: 0, tq: 0 };
          const done = doneByCourse.get(c.id) ?? 0;
          const pct = st.stages
            ? Math.round((done / st.stages) * 100)
            : 0;
          return (
            <Link key={c.id} className={`world ${c.id}`} href={`/course/${c.id}`}>
              <div className="orb"></div>
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
                  ✅ <b>{done}/{st.stages}</b> selesai
                </span>
              </div>
              <div className="pbar">
                <div style={{ width: `${pct}%` }}></div>
              </div>
              <div className="enter" style={{ marginTop: 14 }}>
                ▶ MASUK DUNIA
              </div>
            </Link>
          );
        })}
      </div>
      {user ? (
        <div className="badges">
          <h3>🏅 PENCAPAIAN</h3>
          <div className="badge-row">
            {BADGES.map((b) => {
              const un = earnedBadges.has(b.id);
              return (
                <div
                  key={b.id}
                  className={`badge ${un ? "unlocked" : ""}`}
                  title={b.desc}
                >
                  <span className="bic">{b.icon}</span>
                  <span>
                    <b>{b.name}</b>
                    <br />
                    <small>{b.desc}</small>
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      ) : null}
      <footer>
        <div className="pixel">QUEST ACADEMY v2.0 — DINAMIS</div>
        <div style={{ marginTop: 8 }}>
          {user
            ? "Progres tersimpan di akunmu, bisa lanjut di perangkat mana pun."
            : "Progres tersimpan di akunmu setelah kamu masuk."}
        </div>
      </footer>
    </div>
  );
}
