import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { MarkStageRead } from "@/components/MarkStageRead";
import type { Course, Stage } from "@/lib/types";

export default async function StagePage({
  params,
}: {
  params: Promise<{ courseId: string; stageId: string }>;
}) {
  const { courseId, stageId } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: courseData } = await supabase
    .from("courses")
    .select("*")
    .eq("id", courseId)
    .single();
  const { data: stageData } = await supabase
    .from("stages")
    .select("*")
    .eq("id", stageId)
    .eq("course_id", courseId)
    .single();
  if (!courseData || !stageData) notFound();
  const course = courseData as Course;
  const stage = stageData as Stage;

  const { data: sections } = await supabase
    .from("sections")
    .select("id")
    .eq("stage_id", stageId);
  const sectionCount = sections?.length ?? 0;

  const { data: readRows } = await supabase
    .from("section_progress")
    .select("section_id, sections!inner(stage_id)")
    .eq("user_id", user.id)
    .eq("sections.stage_id", stageId);
  const readCount = readRows?.length ?? 0;

  const { data: prog } = await supabase
    .from("stage_progress")
    .select("best_score, checkpoint_passed")
    .eq("user_id", user.id)
    .eq("stage_id", stageId)
    .maybeSingle();
  const checkpointPassed = !!prog?.checkpoint_passed;
  const best = prog?.best_score ?? 0;

  const { count: checkpointCount } = await supabase
    .from("checkpoint_stats")
    .select("stage_id", { count: "exact", head: true })
    .eq("stage_id", stageId);
  const hasCheckpoint = (checkpointCount ?? 0) > 0;
  const battleUnlocked = checkpointPassed || !hasCheckpoint;

  return (
    <div>
      <MarkStageRead stageId={stageId} />
      <div className="crumb">
        <Link href={`/course/${courseId}`}>← {course.title}</Link>
      </div>
      <div className="questlog">
        <h2>📜 QUEST LOG — {stage.title.toUpperCase()}</h2>
        <div className="qsub">Intisari</div>
        <div
          className="body sectbody"
          dangerouslySetInnerHTML={{ __html: stage.summary }}
        />
      </div>

      <div className="stage-actions">
        <Link
          className="btn gold"
          href={`/course/${courseId}/stage/${stageId}/learn`}
        >
          📖 BELAJAR BERTAHAP ({readCount}/{sectionCount} HALAMAN)
        </Link>
        {stage.source_url ? (
          <a
            className="btn ghost srcbtn"
            href={stage.source_url}
            target="_blank"
            rel="noopener noreferrer"
          >
            📄 {stage.source_label ?? "SUMBER ASLI"}
          </a>
        ) : null}
        {battleUnlocked ? (
          <Link
            className="btn gold"
            href={`/course/${courseId}/stage/${stageId}/battle`}
          >
            ⚔️ TANTANG BOSS {best > 0 ? `(TERBAIK ${best})` : ""}
          </Link>
        ) : (
          <Link
            className="btn ghost"
            href={`/course/${courseId}/stage/${stageId}/learn`}
          >
            🔒 BATTLE (LULUS CHECKPOINT DULU)
          </Link>
        )}
      </div>
      <p className="locknote">
        Alur stage ini: baca intisari atau dokumen aslinya, ikuti penjelasan
        halaman demi halaman, lulus checkpoint
        {hasCheckpoint ? "" : " (stage ini belum punya checkpoint)"}, lalu
        kalahkan boss-nya untuk XP.
        {checkpointPassed ? (
          <span className="donecheck"> Checkpoint sudah lulus ✅</span>
        ) : null}
      </p>
    </div>
  );
}
