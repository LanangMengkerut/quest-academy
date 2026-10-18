type Contributor = {
  login: string;
  html_url: string;
  avatar_url: string;
  contributions: number;
};

/** Shown if the GitHub API is unreachable — keep in sync roughly. */
const FALLBACK: Contributor[] = [
  {
    login: "LanangMengkerut",
    html_url: "https://github.com/LanangMengkerut",
    avatar_url: "https://avatars.githubusercontent.com/u/343059836?v=4",
    contributions: 21,
  },
  {
    login: "arSen-dot",
    html_url: "https://github.com/arSen-dot",
    avatar_url: "https://avatars.githubusercontent.com/u/232195451?v=4",
    contributions: 7,
  },
];

async function getContributors(): Promise<Contributor[]> {
  try {
    const res = await fetch(
      "https://api.github.com/repos/LanangMengkerut/quest-academy/contributors",
      {
        headers: { Accept: "application/vnd.github+json" },
        next: { revalidate: 3600 },
      },
    );
    if (!res.ok) return FALLBACK;
    const data = (await res.json()) as Contributor[];
    // bots (e.g. github-actions[bot] from auto-merge) are automation, not people
    const humans = data.filter((c) => !c.login.endsWith("[bot]"));
    return humans.length ? humans : FALLBACK;
  } catch {
    return FALLBACK;
  }
}

/** Site-wide footer: project credit + every GitHub contributor. */
export async function SiteFooter() {
  const contributors = await getContributors();
  return (
    <footer className="site-footer">
      <div className="pixel">QUEST ACADEMY</div>
      <div className="built-by">
        Built by <b>LanangMengkerut&rsquo;s Project</b>
      </div>
      <div className="contrib-label">CONTRIBUTED BY</div>
      <div className="contrib-chips">
        {contributors.map((c) => (
          <a
            key={c.login}
            className="contrib-chip"
            href={c.html_url}
            target="_blank"
            rel="noreferrer"
            title={`${c.contributions} kontribusi`}
          >
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={c.avatar_url} alt="" width={22} height={22} />
            <span>{c.login}</span>
          </a>
        ))}
      </div>
    </footer>
  );
}
