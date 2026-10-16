"use client";

import { useCallback, useEffect, useRef, useState } from "react";

/**
 * Mode Fokus (anti-AI guard) for battle & arena sessions.
 *
 * Design (agreed with owner, "level sedang", mobile-friendly):
 * - No device requirement: phones are welcome. Fullscreen is requested
 *   when the browser supports it (Android/desktop) and silently skipped
 *   where it does not (iPhone Safari) — detection carries the weight.
 * - Breach signals: tab/app switch (visibilitychange), window blur,
 *   fullscreen exit, and a split-screen heuristic (viewport suddenly
 *   shrinks >35% while playing, rotation excluded).
 * - A breach episode is forgiven if the player returns within GRACE_MS;
 *   after that it counts as one violation and the session stays paused
 *   behind an overlay until the player taps resume.
 * - MAX_VIOLATIONS breaches terminate the session (onTerminate).
 *
 * Enforcement is client-side by design: the threat model is a friend
 * group norm, not exam-grade proctoring.
 */

export const MAX_VIOLATIONS = 3;
const GRACE_MS = 2000;

export function fullscreenSupported(): boolean {
  return (
    typeof document !== "undefined" &&
    typeof document.documentElement?.requestFullscreen === "function"
  );
}

export function exitFullscreen(): void {
  try {
    if (typeof document !== "undefined" && document.fullscreenElement) {
      void document.exitFullscreen();
    }
  } catch {
    /* ignore */
  }
}

type GuardState = {
  engaged: boolean;
  breached: boolean;
  paused: boolean;
  terminated: boolean;
  violations: number;
  fs: boolean;
  baseline: { w: number; h: number };
};

const freshState = (): GuardState => ({
  engaged: false,
  breached: false,
  paused: false,
  terminated: false,
  violations: 0,
  fs: false,
  baseline: { w: 0, h: 0 },
});

export function useExamGuard({
  active,
  onTerminate,
}: {
  active: boolean;
  onTerminate: () => void;
}) {
  const [engaged, setEngaged] = useState(false);
  const [covered, setCovered] = useState(false);
  const [paused, setPaused] = useState(false);
  const [violations, setViolations] = useState(0);

  const s = useRef<GuardState>(freshState());
  const graceTimer = useRef<number | null>(null);
  const lastRotate = useRef(0);
  const activeRef = useRef(active);
  activeRef.current = active;
  const onTerminateRef = useRef(onTerminate);
  onTerminateRef.current = onTerminate;

  // Leaving the guarded page (SPA navigation) releases fullscreen.
  useEffect(() => {
    return () => exitFullscreen();
  }, []);

  const clearGrace = useCallback(() => {
    if (graceTimer.current !== null) {
      window.clearTimeout(graceTimer.current);
      graceTimer.current = null;
    }
  }, []);

  const isClean = useCallback((): boolean => {
    if (document.hidden) return false;
    if (typeof document.hasFocus === "function" && !document.hasFocus())
      return false;
    if (s.current.fs && !document.fullscreenElement) return false;
    return true;
  }, []);

  const signalBreach = useCallback(() => {
    const st = s.current;
    if (!activeRef.current || !st.engaged || st.terminated || st.paused)
      return;
    if (st.breached) return; // one count per episode
    st.breached = true;
    setCovered(true); // cover questions immediately (also app-switcher preview)
    clearGrace();
    graceTimer.current = window.setTimeout(() => {
      graceTimer.current = null;
      if (!s.current.breached || s.current.paused || s.current.terminated)
        return;
      const v = s.current.violations + 1;
      s.current.violations = v;
      setViolations(v);
      if (v >= MAX_VIOLATIONS) {
        s.current.terminated = true;
        setCovered(false);
        onTerminateRef.current();
      } else {
        s.current.paused = true;
        setPaused(true);
      }
    }, GRACE_MS);
  }, [clearGrace]);

  const maybeForgive = useCallback(() => {
    const st = s.current;
    if (!st.breached || st.paused || st.terminated) return;
    if (!isClean()) return;
    clearGrace();
    st.breached = false;
    setCovered(false);
    st.baseline = { w: window.innerWidth, h: window.innerHeight };
  }, [clearGrace, isClean]);

  useEffect(() => {
    const onVis = () => {
      if (document.hidden) signalBreach();
      else maybeForgive();
    };
    const onFs = () => {
      if (s.current.fs && !document.fullscreenElement) signalBreach();
      else maybeForgive();
    };
    const onBlur = () => signalBreach();
    const onFocus = () => maybeForgive();
    const onResize = () => {
      const st = s.current;
      if (!activeRef.current || !st.engaged || st.breached || st.paused)
        return;
      if (Date.now() - lastRotate.current < 1200) return; // rotation, not split-screen
      const { w, h } = st.baseline;
      if (!w || !h) return;
      if (window.innerHeight < h * 0.65 || window.innerWidth < w * 0.65)
        signalBreach();
    };
    const onRotate = () => {
      lastRotate.current = Date.now();
      window.setTimeout(() => {
        if (isClean()) {
          s.current.baseline = {
            w: window.innerWidth,
            h: window.innerHeight,
          };
        }
      }, 900);
    };
    document.addEventListener("visibilitychange", onVis);
    document.addEventListener("fullscreenchange", onFs);
    window.addEventListener("blur", onBlur);
    window.addEventListener("focus", onFocus);
    window.addEventListener("resize", onResize);
    window.addEventListener("orientationchange", onRotate);
    return () => {
      document.removeEventListener("visibilitychange", onVis);
      document.removeEventListener("fullscreenchange", onFs);
      window.removeEventListener("blur", onBlur);
      window.removeEventListener("focus", onFocus);
      window.removeEventListener("resize", onResize);
      window.removeEventListener("orientationchange", onRotate);
    };
  }, [signalBreach, maybeForgive, isClean]);

  const tryFullscreen = useCallback(async () => {
    if (!fullscreenSupported()) return;
    try {
      await document.documentElement.requestFullscreen();
      if (document.fullscreenElement) s.current.fs = true;
    } catch {
      /* unsupported or denied — detection still applies */
    }
  }, []);

  /** First activation from a user gesture (start button). */
  const engage = useCallback(async () => {
    s.current.engaged = true;
    s.current.baseline = { w: window.innerWidth, h: window.innerHeight };
    setEngaged(true);
    await tryFullscreen();
  }, [tryFullscreen]);

  /** Resume after a committed violation (tap on the overlay). */
  const resume = useCallback(async () => {
    await tryFullscreen();
    if (isClean()) {
      s.current.paused = false;
      s.current.breached = false;
      s.current.baseline = { w: window.innerWidth, h: window.innerHeight };
      setPaused(false);
      setCovered(false);
    }
  }, [tryFullscreen, isClean]);

  /** Full reset for a brand-new session (e.g. "main lagi"). */
  const restart = useCallback(async () => {
    clearGrace();
    const keepFs = s.current.fs;
    s.current = freshState();
    s.current.fs = keepFs;
    setViolations(0);
    setPaused(false);
    setCovered(false);
    s.current.engaged = true;
    s.current.baseline = { w: window.innerWidth, h: window.innerHeight };
    setEngaged(true);
    await tryFullscreen();
  }, [clearGrace, tryFullscreen]);

  const reset = useCallback(() => {
    clearGrace();
    s.current = freshState();
    setEngaged(false);
    setViolations(0);
    setPaused(false);
    setCovered(false);
  }, [clearGrace]);

  return {
    engaged,
    covered,
    paused,
    violations,
    maxViolations: MAX_VIOLATIONS,
    engage,
    resume,
    restart,
    reset,
  };
}
