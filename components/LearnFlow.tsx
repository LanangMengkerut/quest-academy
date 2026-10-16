"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { useSound } from "@/lib/useSound";
import { sfx } from "@/lib/sfx";
import { Quiz } from "./Quiz";

export type SectionLite = { id: string; title: string; body: string };

export function LearnFlow({
  courseId,
  stageId,
  stageTitle,
  sections,
  readSectionIds,
  checkpointPassed,
  hasCheckpoint,
}: {
  courseId: string;
  stageId: string;
  stageTitle: string;
  sections: SectionLite[];
  readSectionIds: string[];
  checkpointPassed: boolean;
  hasCheckpoint: boolean;
}) {
  const [sound] = useSound();
  const muted = !sound;
  const [idx, setIdx] = useState(0);
  const [showCheckpoint, setShowCheckpoint] = useState(false);
  const [read, setRead] = useState<Set<string>>(new Set(readSectionIds));
  const markedRef = useRef<Set<string>>(new Set(readSectionIds));

  const section = sections[idx];
  const total = sections.length;
  const isLast = idx >= total - 1;

  useEffect(() => {
    if (!section) return;
    if (markedRef.current.has(section.id)) return;
    markedRef.current.add(section.id);
    setRead((prev) => new Set(prev).add(section.id));
    const supabase = createClient();
    void supabase.rpc("mark_section_read", { p_section_id: section.id });
  }, [section]);

  if (showCheckpoint) {
    return (
      <div>
        <div className="crumb">
          <Link href={`/course/${courseId}/stage/${stageId}`}>
            ← {stageTitle}
          </Link>
        </div>
        <Quiz courseId={courseId} stageId={stageId} kind="checkpoint" />
      </div>
    );
  }

  const pct = total ? Math.round(((idx + 1) / total) * 100) : 100;

  return (
    <div>
      <div className="crumb">
        <Link href={`/course/${courseId}/stage/${stageId}`}>
          ← {stageTitle}
        </Link>
      </div>
      <div className="questlog">
        <h2>📜 PENJELASAN — {stageTitle.toUpperCase()}</h2>
        <div className="qsub">
          {section ? section.title : "Tidak ada penjelasan"}
        </div>
        {section ? (
          <div
            className="body sectbody"
            dangerouslySetInnerHTML={{ __html: section.body }}
          />
        ) : (
          <div className="body">
            <p>Penjelasan bertahap untuk stage ini belum tersedia.</p>
          </div>
        )}
      </div>
      <div className="pbar thin">
        <div style={{ width: `${pct}%` }}></div>
      </div>
      <div className="pager">
        <button
          className="btn ghost"
          disabled={idx === 0}
          onClick={() => {
            sfx.click(muted);
            setIdx((v) => Math.max(0, v - 1));
          }}
        >
          ← SEBELUMNYA
        </button>
        <span className="pinfo">
          HALAMAN {total ? idx + 1 : 0} / {total} · {read.size} DIBACA
        </span>
        {!isLast ? (
          <button
            className="btn gold"
            onClick={() => {
              sfx.click(muted);
              setIdx((v) => Math.min(total - 1, v + 1));
            }}
          >
            BERIKUTNYA →
          </button>
        ) : hasCheckpoint ? (
          <button
            className="btn gold"
            onClick={() => {
              sfx.click(muted);
              setShowCheckpoint(true);
            }}
          >
            🚧 KE CHECKPOINT
          </button>
        ) : (
          <Link
            className="btn gold"
            href={`/course/${courseId}/stage/${stageId}/battle`}
          >
            ⚔️ KE BATTLE
          </Link>
        )}
      </div>
      {isLast && checkpointPassed ? (
        <p className="donecheck" style={{ marginTop: 14 }}>
          ✅ Checkpoint stage ini sudah kamu luluskan. Battle terbuka.
        </p>
      ) : null}
    </div>
  );
}
