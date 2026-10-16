"use client";

import { useEffect, useState } from "react";

const KEY = "qa-sound";

export function useSound(): [boolean, () => void] {
  const [sound, setSound] = useState(true);

  useEffect(() => {
    const read = () => {
      try {
        setSound(localStorage.getItem(KEY) !== "off");
      } catch {
        setSound(true);
      }
    };
    read();
    window.addEventListener("qa-sound-change", read);
    return () => window.removeEventListener("qa-sound-change", read);
  }, []);

  const toggle = () => {
    const next = !sound;
    setSound(next);
    try {
      localStorage.setItem(KEY, next ? "on" : "off");
    } catch {
      /* ignore */
    }
    window.dispatchEvent(new Event("qa-sound-change"));
  };

  return [sound, toggle];
}
