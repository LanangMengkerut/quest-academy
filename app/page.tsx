import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { BADGES } from "@/lib/game";
import { WorldCarousel } from "@/components/WorldCarousel";
import { Reveal } from "@/components/Reveal";
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
      <WorldCarousel
        courses={courses}
        stats={Array.from(stats.entries()).map(([courseId, v]) => ({
          courseId,
          stages: v.stages,
          tq: v.tq,
        }))}
        done={Array.from(doneByCourse.entries()).map(([courseId, done]) => ({
          courseId,
          done,
        }))}
      />
      {user ? (
        <Reveal className="badges">
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
        </Reveal>
      ) : null}
    </div>
  );
}
