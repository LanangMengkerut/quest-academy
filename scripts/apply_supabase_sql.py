#!/usr/bin/env python3
"""Apply all SQL files in supabase/ to the Supabase project, in order.

Used by the GitHub Actions workflow (.github/workflows/supabase-deploy.yml)
so collaborators never need direct Supabase access or anyone's access token.

Order: schema.sql first, then seed-00-courses.sql, then the remaining
seed-*.sql files alphabetically. Every file in this repo is written to be
idempotent (IF NOT EXISTS / CREATE OR REPLACE / ON CONFLICT DO UPDATE),
so re-running the whole set is safe.

Required environment:
  SUPABASE_ACCESS_TOKEN  Personal Access Token of the project OWNER,
                         stored as a GitHub Actions secret. Never commit it.
  SUPABASE_PROJECT_REF   Project ref (not a secret; also visible in the
                         project's API URL).
"""
import json
import os
import pathlib
import sys
import urllib.error
import urllib.request

API = "https://api.supabase.com"


def apply_file(ref: str, token: str, path: pathlib.Path) -> None:
    sql = path.read_text(encoding="utf-8")
    body = json.dumps({"query": sql}).encode("utf-8")
    req = urllib.request.Request(
        f"{API}/v1/projects/{ref}/database/query",
        data=body,
        method="POST",
    )
    req.add_header("Authorization", f"Bearer {token}")
    req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            status = resp.status
            resp.read()
    except urllib.error.HTTPError as e:
        detail = e.read().decode("utf-8", errors="replace")[:500]
        raise SystemExit(f"FAILED {path.name}: HTTP {e.code} {detail}")
    if status not in (200, 201):
        raise SystemExit(f"FAILED {path.name}: HTTP {status}")
    print(f"OK {path.name} ({len(sql)} bytes)")


def main() -> int:
    token = os.environ.get("SUPABASE_ACCESS_TOKEN", "").strip()
    ref = os.environ.get("SUPABASE_PROJECT_REF", "").strip()
    if not token:
        raise SystemExit(
            "SUPABASE_ACCESS_TOKEN is not set. The repo owner must add it under "
            "GitHub repo Settings -> Secrets and variables -> Actions."
        )
    if not ref:
        raise SystemExit("SUPABASE_PROJECT_REF is not set in the workflow env.")

    sql_dir = pathlib.Path("supabase")
    ordered: list[pathlib.Path] = []
    schema = sql_dir / "schema.sql"
    if schema.exists():
        ordered.append(schema)
    courses = sql_dir / "seed-00-courses.sql"
    if courses.exists():
        ordered.append(courses)
    ordered += sorted(
        p
        for p in sql_dir.glob("seed-*.sql")
        if p.name != "seed-00-courses.sql"
    )
    if not ordered:
        print("No SQL files found, nothing to do.")
        return 0

    for path in ordered:
        apply_file(ref, token, path)
    print(f"Done: {len(ordered)} file(s) applied to project {ref}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
