"use client";

import { useEffect } from "react";
import { startDungeonMusic, stopDungeonMusic } from "@/lib/music";

/**
 * Owns the dungeon music engine. Audio may only start after a user
 * gesture, so when the preference is ON we arm one-time listeners for
 * the first interaction; the toggle event starts/stops immediately
 * (a toggle click is itself a gesture).
 */
export function MusicEngine() {
  useEffect(() => {
    const prefOn = () => {
      try {
        return localStorage.getItem("qa-music") !== "off";
      } catch {
        return true;
      }
    };

    const arm = () => {
      const kick = () => startDungeonMusic();
      window.addEventListener("pointerdown", kick, { once: true });
      window.addEventListener("keydown", kick, { once: true });
      return () => {
        window.removeEventListener("pointerdown", kick);
        window.removeEventListener("keydown", kick);
      };
    };

    let disarm: (() => void) | null = null;
    if (prefOn()) disarm = arm();

    const onChange = () => {
      if (prefOn()) {
        startDungeonMusic();
      } else {
        stopDungeonMusic();
        if (disarm) disarm();
        disarm = null;
      }
    };
    window.addEventListener("qa-music-change", onChange);
    return () => {
      window.removeEventListener("qa-music-change", onChange);
      if (disarm) disarm();
    };
  }, []);

  return null;
}
