"use client";

import Link from "next/link";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { motion } from "framer-motion";
import { levelOf, RANKS, xpForLevel } from "@/lib/game";
import { useSound } from "@/lib/useSound";
import { useMusic } from "@/lib/useMusic";
import { sfx } from "@/lib/sfx";
import { createClient } from "@/lib/supabase/client";
import { Avatar } from "./Avatar";
import { AvatarPicker } from "./AvatarPicker";

export type ProfileLite = {
  username: string;
  avatar: string;
  xp: number;
  streak: number;
};

export function Hud({ profile }: { profile: ProfileLite }) {
  const [sound, toggleSound] = useSound();
  const [pickOpen, setPickOpen] = useState(false);
  const lvl = levelOf(profile.xp);
  const cur = xpForLevel(lvl);
  const nxt = xpForLevel(lvl + 1);
  const pct = Math.min(100, ((profile.xp - cur) / (nxt - cur)) * 100);
  const rank = RANKS[Math.min(lvl - 1, RANKS.length - 1)];

  return (
    <div className="hud">
      <div
        className="avatar"
        onClick={() => setPickOpen(true)}
        title="Ganti karakter"
        role="button"
      >
        <Avatar value={profile.avatar} size={40} />
      </div>
      {pickOpen && (
        <AvatarPicker
          current={profile.avatar}
          onClose={() => setPickOpen(false)}
        />
      )}
      <div className="who">
        <div className="lvl">LV {lvl}</div>
        <div className="rank">
          {rank} · {profile.username}
        </div>
      </div>
      <div className="xpwrap">
        <div className="xpbar">
          <motion.div
            initial={{ width: 0 }}
            animate={{ width: `${pct}%` }}
            transition={{ type: "spring", stiffness: 60, damping: 18 }}
          ></motion.div>
        </div>
        <div className="xplabel">{profile.xp} XP</div>
      </div>
      <div className="streak">🔥{profile.streak}</div>
      <button
        className="iconbtn"
        title="Suara"
        onClick={() => {
          toggleSound();
        }}
      >
        {sound ? "🔊" : "🔇"}
      </button>
    </div>
  );
}

export function TopNav({ loggedIn }: { loggedIn: boolean }) {
  const router = useRouter();
  const [sound] = useSound();
  const [music, toggleMusic] = useMusic();

  const logout = async () => {
    sfx.click(!sound);
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/login");
    router.refresh();
  };

  return (
    <nav className="topnav">
      <Link href="/">🏠 Beranda</Link>
      <Link href="/leaderboard">🏆 Leaderboard</Link>
      <Link href="/arena">⚔️ Arena</Link>
      <button
        className="linkbtn"
        onClick={toggleMusic}
        title="Musik latar dungeon (nyala/mati)"
      >
        {music ? "🎵 Musik: Nyala" : "🔇 Musik: Mati"}
      </button>
      <span className="spacer" />
      {loggedIn ? (
        <button className="linkbtn" onClick={logout}>
          Keluar
        </button>
      ) : (
        <>
          <Link href="/login">Masuk</Link>
          <Link href="/register">Daftar</Link>
        </>
      )}
    </nav>
  );
}
