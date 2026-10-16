#!/usr/bin/env python3
"""Automatic PR checks for Quest Academy (run by .github/workflows/pr-checks.yml).

Checks, all must pass before a PR may auto-merge:
  1. Every supabase/*.sql file parses with the real PostgreSQL grammar
     (pglast / libpg_query) — catches syntax errors before Actions applies
     the files to the production database on merge.
  2. SQL idempotency rules, because the whole supabase/ folder is re-applied
     on every merge: INSERT needs ON CONFLICT, CREATE TABLE / CREATE INDEX
     need IF NOT EXISTS, CREATE FUNCTION / CREATE VIEW need OR REPLACE.
  3. Secret scan: no credential files (.env.local, *.pem, private keys) and
     no token patterns (Supabase PAT sbp_..., GitHub PATs) or the string
     "service_role" anywhere in code/SQL. The anon key in .env.example is
     public by design and intentionally allowed.

Exit code 0 = all green. Run from the repo root.
"""
import pathlib
import re
import sys

ROOT = pathlib.Path.cwd()
FAILURES: list[str] = []


def fail(msg: str) -> None:
    FAILURES.append(msg)
    print(f"FAIL  {msg}")


def statements_of(sql: str):
    """Split SQL into statement texts using the real PG parser positions."""
    from pglast import parse_sql

    parsed = parse_sql(sql)
    out = []
    for raw in parsed:
        loc = raw.stmt_location
        length = raw.stmt_len
        if loc is None or loc < 0:
            continue
        text = sql[loc : loc + length] if length else sql[loc:]
        out.append(text)
    return out


def check_sql() -> None:
    try:
        import pglast  # noqa: F401
    except ImportError:
        fail("pglast is not installed (CI installs it before running checks)")
        return
    files = sorted((ROOT / "supabase").glob("*.sql"))
    if not files:
        print("OK    no SQL files")
        return
    for f in files:
        sql = f.read_text(encoding="utf-8")
        try:
            stmts = statements_of(sql)
        except Exception as e:  # pglast raises ParseError with position info
            fail(f"{f.name}: syntax error — {str(e)[:220]}")
            continue
        for st in stmts:
            low = st.lower().lstrip()
            if re.match(r"insert\s+into", low) and "on conflict" not in low:
                fail(f"{f.name}: INSERT without ON CONFLICT (must be idempotent)")
            elif re.match(r"create\s+table", low) and "if not exists" not in low:
                fail(f"{f.name}: CREATE TABLE without IF NOT EXISTS")
            elif re.match(r"create\s+(unique\s+)?index", low) and "if not exists" not in low:
                fail(f"{f.name}: CREATE INDEX without IF NOT EXISTS")
            elif re.match(r"create\s+function", low) and "or replace" not in low:
                fail(f"{f.name}: CREATE FUNCTION without OR REPLACE")
            elif re.match(r"create\s+view", low) and "or replace" not in low:
                fail(f"{f.name}: CREATE VIEW without OR REPLACE")
        print(f"OK    {f.name}: {len(stmts)} statements valid + idempotent")


FORBIDDEN_NAMES = [
    re.compile(r"^\.env\.(?!example$).+"),  # .env.local, .env.production, ...
    re.compile(r".*\.pem$"),
    re.compile(r"^id_(rsa|dsa|ecdsa|ed25519)$"),
]
TOKEN_PATTERNS = [
    re.compile(r"sbp_[A-Za-z0-9_-]{15,}"),  # Supabase personal access token
    re.compile(r"ghp_[A-Za-z0-9]{20,}"),  # GitHub PAT (classic)
    re.compile(r"github_pat_[A-Za-z0-9_]{20,}"),  # GitHub PAT (fine-grained)
    re.compile(r"-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----"),
]
SKIP_DIRS = {".git", "node_modules", ".next", ".vercel"}
CODE_DIRS = {"app", "components", "lib", "supabase", "scripts"}


def tracked_files() -> list[pathlib.Path]:
    """Files that are part of the PR: git-tracked when .git exists (CI
    checkout), otherwise a plain walk (local runs). This keeps local-only
    gitignored files such as the developer's own .env.local out of scope."""
    git_dir = ROOT / ".git"
    if git_dir.exists():
        import subprocess

        out = subprocess.run(
            ["git", "ls-files"], cwd=ROOT, capture_output=True, text=True
        )
        if out.returncode == 0:
            return [ROOT / line for line in out.stdout.splitlines() if line]
    return [
        p
        for p in sorted(ROOT.rglob("*"))
        if p.is_file()
        and not any(part in SKIP_DIRS for part in p.relative_to(ROOT).parts)
    ]


def check_secrets() -> None:
    scanned = 0
    for p in tracked_files():
        if not p.is_file():
            continue
        rel = p.relative_to(ROOT)
        for pat in FORBIDDEN_NAMES:
            if pat.match(p.name):
                fail(f"forbidden credential file: {rel}")
        try:
            text = p.read_text(encoding="utf-8", errors="strict")
        except (UnicodeDecodeError, ValueError):
            continue
        scanned += 1
        for pat in TOKEN_PATTERNS:
            if pat.search(text):
                fail(f"token pattern {pat.pattern[:24]}... found in {rel}")
        if (
            rel.parts
            and rel.parts[0] in CODE_DIRS
            and "service_role" in text
            and rel != pathlib.Path("scripts/pr_checks.py")  # the checker itself
        ):
            fail(f"'service_role' must never appear in code/SQL: {rel}")
    print(f"OK    secret scan: {scanned} files clean")


def main() -> int:
    check_sql()
    check_secrets()
    if FAILURES:
        print(f"\n{len(FAILURES)} check(s) FAILED — PR must not merge.")
        return 1
    print("\nAll checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
