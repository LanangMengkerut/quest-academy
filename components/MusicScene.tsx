"use client";

import { useEffect } from "react";
import { setMusicScene, type MusicScene as Scene } from "@/lib/music";

/** Sets the music scene while mounted; resets to dashboard on leave. */
export function MusicScene({ scene }: { scene: Scene }) {
  useEffect(() => {
    setMusicScene(scene);
    return () => setMusicScene("dashboard");
  }, [scene]);
  return null;
}
