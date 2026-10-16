import { notFound, redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { LearnFlow, type SectionLite } from "@/components/LearnFlow";
import type { Stage } from "@/lib/types";

export default async function LearnPage({
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

  const { data: sectionsData } = await supabase
    .from("sections")
    .select("id, title, body")
    .eq("stage_id", stageId)
    .order("sort_order");
  const sections = (sectionsData ?? []) as SectionLite[];

  const { data: readRows } = await supabase
    .from("section_progress")
    .select("section_id")
    .eq("user_id", user.id)
    .in(
      "section_id",
      sections.map((s) => s.id),
    );
  const readSectionIds = (readRows ?? []).map((r) => r.section_id as string);

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

  return (
    <LearnFlow
      courseId={courseId}
      stageId={stageId}
      stageTitle={stage.title}
      sections={sections}
      readSectionIds={readSectionIds}
      checkpointPassed={!!prog?.checkpoint_passed}
      hasCheckpoint={(checkpointCount ?? 0) > 0}
    />
  );
}
