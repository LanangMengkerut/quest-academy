import type { Metadata } from "next";
import "./globals.css";
import { createClient } from "@/lib/supabase/server";
import { Hud, TopNav, type ProfileLite } from "@/components/Hud";

export const metadata: Metadata = {
  title: "Quest Academy — Belajar Sambil Main",
  description:
    "Sarana belajar berkedok game untuk tongkrongan: baca materi, lewati checkpoint, kalahkan boss-nya, naikkan levelmu.",
  icons: {
    icon: "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🎮</text></svg>",
  },
};

export default async function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  let profile: ProfileLite | null = null;
  if (user) {
    const { data } = await supabase
      .from("profiles")
      .select("username, avatar, xp, streak")
      .eq("id", user.id)
      .single();
    if (data) profile = data as ProfileLite;
  }

  return (
    <html lang="id">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link
          rel="preconnect"
          href="https://fonts.gstatic.com"
          crossOrigin="anonymous"
        />
        <link
          href="https://fonts.googleapis.com/css2?family=Press+Start+2P&family=Space+Grotesk:wght@400;500;700&display=swap"
          rel="stylesheet"
        />
      </head>
      <body>
        <div id="app">
          {profile ? <Hud profile={profile} /> : null}
          <TopNav loggedIn={!!user} />
          {children}
        </div>
      </body>
    </html>
  );
}
