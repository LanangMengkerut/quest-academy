"use client";

import { MAX_VIOLATIONS } from "@/lib/useExamGuard";

/**
 * Full-screen cover for Mode Fokus. Shown the instant a breach signal
 * fires (so the question is hidden, including from app-switcher
 * previews). Two states:
 * - grace: the episode is still inside the forgiveness window; the
 *   overlay disappears by itself if the player returns in time.
 * - paused: a violation was committed; the player must tap resume.
 */
export function ExamOverlay({
  covered,
  paused,
  violations,
  onResume,
}: {
  covered: boolean;
  paused: boolean;
  violations: number;
  onResume: () => void;
}) {
  if (!covered) return null;
  return (
    <div className="exam-overlay" role="alertdialog" aria-modal="true">
      <div className="exam-box">
        <div className="big">{paused ? "⚠️" : "⏸️"}</div>
        {paused ? (
          <>
            <h2>
              PELANGGARAN {violations}/{MAX_VIOLATIONS}
            </h2>
            <p style={{ color: "var(--dim)" }}>
              Kamu terdeteksi keluar dari Mode Fokus — pindah tab/aplikasi,
              keluar fullscreen, atau membagi layar. Sesi dijeda. Pada
              pelanggaran ke-{MAX_VIOLATIONS}, sesi langsung dihentikan
              tanpa hadiah.
            </p>
            <div className="rbtns">
              <button className="btn gold" onClick={onResume}>
                🛡️ Kembali ke Mode Fokus
              </button>
            </div>
          </>
        ) : (
          <>
            <h2>SESI DIJEDA</h2>
            <p style={{ color: "var(--dim)" }}>
              Fokusmu terdeteksi terputus. Kembali ke halaman ini sekarang
              untuk melanjutkan — terlambat kembali akan dihitung sebagai
              pelanggaran ({violations}/{MAX_VIOLATIONS}).
            </p>
          </>
        )}
      </div>
    </div>
  );
}
