import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { Reveal } from "@/components/Reveal";
import { Avatar } from "@/components/Avatar";
import { MusicScene } from "@/components/MusicScene";

type Row = {
  user_id: string;
  wins: number;
  losses: number;
  draws: number;
  played: number;
  profiles: { username: string; avatar: string } | null;
};

export default async function ArenaLeaderboard({
  searchParams,
}: {
  searchParams: Promise<{ mode?: string }>;
}) {
  const sp = await searchParams;
  const mode = sp.mode === "race" ? "race" : "battle";
  const supabase = await createClient();

  let rows: Row[] = [];
  if (mode === "battle") {
    const { data } = await supabase
      .from("arena_stats")
      .select("user_id, wins, losses, draws, played, profiles(username, avatar)")
      .eq("mode", "battle")
      .order("wins", { ascending: false })
      .order("played", { ascending: true })
      .limit(100);
    rows = (data ?? []) as unknown as Row[];
  }

  return (
    <div className="lbwrap">
      <MusicScene scene="arena" />
      <h1 className="logo" style={{ fontSize: 26 }}>
        🏆 LEADERBOARD ARENA
      </h1>
      <p className="tagline">
        Peringkat kemenangan mode PvP — terpisah dari leaderboard XP.
      </p>

      <div style={{ display: "flex", gap: 10, justifyContent: "center" }}>
        <Link
          href="/arena/leaderboard?mode=battle"
          className={`btn ${mode === "battle" ? "gold" : "ghost"}`}
        >
          ⚔️ Battle
        </Link>
        <Link
          href="/arena/leaderboard?mode=race"
          className={`btn ${mode === "race" ? "gold" : "ghost"}`}
        >
          🏁 Race
        </Link>
      </div>

      {mode === "race" ? (
        <div className="empty" style={{ marginTop: 24 }}>
          <div className="big">🏁</div>
          Mode Race segera hadir di Fase 2.
          <br />
          <br />
          <Link href="/arena" style={{ color: "var(--cyan)" }}>
            Main Battle dulu
          </Link>
        </div>
      ) : rows.length === 0 ? (
        <div className="empty" style={{ marginTop: 24 }}>
          <div className="big">⚔️</div>
          Belum ada battle yang selesai. Jadilah yang pertama!
          <br />
          <br />
          <Link href="/arena" style={{ color: "var(--cyan)" }}>
            Buat room battle
          </Link>
        </div>
      ) : (
        <Reveal>
          <table className="lb" style={{ marginTop: 24 }}>
            <thead>
              <tr>
                <th>#</th>
                <th>Pemain</th>
                <th>Menang</th>
                <th>Kalah</th>
                <th>Seri</th>
                <th>Main</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r, i) => (
                <tr key={r.user_id}>
                  <td>{i + 1}</td>
                  <td>
                    <span
                      style={{
                        display: "inline-flex",
                        alignItems: "center",
                        gap: 8,
                      }}
                    >
                      <Avatar value={r.profiles?.avatar ?? "wizard"} size={30} />
                      {r.profiles?.username ?? "?"}
                    </span>
                  </td>
                  <td style={{ color: "var(--gold)", fontWeight: 700 }}>
                    {r.wins}
                  </td>
                  <td>{r.losses}</td>
                  <td>{r.draws}</td>
                  <td>{r.played}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </Reveal>
      )}
    </div>
  );
}
