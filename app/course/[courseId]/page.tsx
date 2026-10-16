import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { starsForScore } from "@/lib/game";
import { Reveal } from "@/components/Reveal";
import type { Course, Stage, StageProgress } from "@/lib/types";

export default async function CoursePage({
  params,
}: {
  params: Promise<{ courseId: string }>;
}) {
  const { courseId } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: courseData } = await supabase
    .from("courses")
    .select("*")
    .eq("id", courseId)
    .single();
  if (!courseData) notFound();
  const course = courseData as Course;

  const { data: stagesData } = await supabase
    .from("stages")
    .select("*")
    .eq("course_id", courseId)
    .order("sort_order");
  const stages = (stagesData ?? []) as Stage[];

  const progress = new Map<string, StageProgress>();
  if (user) {
    const { data: prog } = await supabase
      .from("stage_progress")
      .select("stage_id, best_score, read_at, checkpoint_passed")
      .eq("user_id", user.id)
      .in(
        "stage_id",
        stages.map((s) => s.id),
      );
    for (const p of (prog ?? []) as StageProgress[]) progress.set(p.stage_id, p);
  }

  return (
    <div>
      <div className="crumb">
        <Link href="/">← Semua dunia</Link>
      </div>
      <div className={`course-head ${course.id}`}>
        <div className="cic">{course.icon}</div>
        <h2>{course.title.toUpperCase()}</h2>
      </div>
      <p className="tagline" style={{ textAlign: "left", marginBottom: 18 }}>
        {course.tagline} Baca penjelasannya halaman demi halaman, lulus
        checkpoint, lalu tantang boss di akhir setiap stage.
      </p>
      <Reveal>
      {stages.map((s, i) => {
        const p = progress.get(s.id);
        const best = p?.best_score ?? 0;
        const stars = starsForScore(best);
        const unlocked = !!p?.checkpoint_passed;
        return (
          <div key={s.id} className={`stage ${course.id}`}>
            <div className="num">{String(i + 1).padStart(2, "0")}</div>
            <div className="sinfo">
              <h3>{s.title}</h3>
              <div className="stars">
                {[0, 1, 2].map((k) => (
                  <span key={k} className={k < stars ? "" : "off"}>
                    ★
                  </span>
                ))}
                {unlocked ? (
                  <span className="donecheck" style={{ marginLeft: 8 }}>
                    ✅ checkpoint
                  </span>
                ) : null}
              </div>
            </div>
            <div className="sbtns">
              <Link
                className="btn ghost"
                href={`/course/${course.id}/stage/${s.id}`}
              >
                📖 MATERI
              </Link>
              {user && !unlocked ? (
                <Link
                  className="btn ghost"
                  href={`/course/${course.id}/stage/${s.id}/learn`}
                >
                  🔒 BATTLE
                </Link>
              ) : (
                <Link
                  className={`btn ${best > 0 ? "ghost" : "gold"}`}
                  href={`/course/${course.id}/stage/${s.id}/battle`}
                >
                  ⚔️ BATTLE
                </Link>
              )}
            </div>
          </div>
        );
      })}
      </Reveal>
      {!user ? (
        <p className="locknote">
          Kamu belum masuk.{" "}
          <Link href="/login">Masuk</Link> untuk menyimpan progres, membuka
          checkpoint, dan bertarung.
        </p>
      ) : null}
    </div>
  );
}
