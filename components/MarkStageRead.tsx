"use client";

import { useEffect, useRef } from "react";
import { createClient } from "@/lib/supabase/client";

export function MarkStageRead({ stageId }: { stageId: string }) {
  const done = useRef(false);
  useEffect(() => {
    if (done.current) return;
    done.current = true;
    const supabase = createClient();
    void supabase.rpc("mark_stage_read", { p_stage_id: stageId });
  }, [stageId]);
  return null;
}
