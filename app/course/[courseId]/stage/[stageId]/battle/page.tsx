import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { Quiz } from "@/components/Quiz";
import type { Stage } from "@/lib/types";

export default async function BattlePage({
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

  const { data: stageData } = await supabase
    .from("stages")
    .select("*")
    .eq("id", stageId)
    .eq("course_id", courseId)
    .single();
  if (!stageData) notFound();
  const stage = stageData as Stage;

  const { data: prog } = await supabase
    .from("stage_progress")
    .select("checkpoint_passed")
    .eq("user_id", user.id)
    .eq("stage_id", stageId)
    .maybeSingle();

  const { count: checkpointCount } = await supabase
    .from("checkpoint_stats")
    .select("stage_id", { count: "exact", head: true })
    .eq("stage_id", stageId);
  const hasCheckpoint = (checkpointCount ?? 0) > 0;

  if (hasCheckpoint && !prog?.checkpoint_passed) {
    return (
      <div className="empty">
        <div className="big">🔒</div>
        Battle stage ini masih terkunci.
        <br />
        Lulus checkpoint dulu lewat penjelasan bertahapnya.
        <br />
        <br />
        <Link
          className="btn gold"
          href={`/course/${courseId}/stage/${stageId}/learn`}
        >
          📖 KE PENJELASAN &amp; CHECKPOINT
        </Link>
      </div>
    );
  }

  return (
    <div>
      <p className="tagline" style={{ textAlign: "left" }}>
        ⚔️ {stage.title} — jawab benar untuk menyerang boss. Tiga kali salah,
        kamu tumbang.
      </p>
      <Quiz courseId={courseId} stageId={stageId} kind="battle" />
    </div>
  );
}
