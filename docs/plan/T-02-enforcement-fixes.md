# T-02: Fix fail-open enforcement layer

## Problem

The September 2026 /improve run found every "hook-enforced" mechanism silently
broken (fail-open), verified empirically:

1. `scripts/lint-todo.sh:54` — the skip-line `[[ "$line" =~ ^# ]]` also matched
   `### T-XX` entry headers, so the linter parsed nothing and passed any file.
2. `.claude/settings.json` PreToolUse `.env` block — written for the legacy flat
   hook JSON schema; the current contract nests arguments under `tool_input` and
   blocks on exit 2 (not exit 1). The guard never triggered.
3. PostToolUse auto-format hook — piped the literal string `$CLAUDE_TOOL_INPUT`
   into the JSON parser; never fired since inception.

Root cause of the rot: nothing exercised the enforcement tooling — no CI, no
self-tests, and /health-check only scans for stale references, not behavior.

## Solution

- One-character-class linter fix: `^#` → `^#[^#]`.
- `.env` hook rewritten for the current contract (stdin JSON, `tool_input`,
  stderr + exit 2).
- Auto-format hook deleted (never missed; auto-format hooks are a known
  token-burn anti-pattern). See ADR 2026-09-04 in docs/decisions.md.
- `scripts/selftest.sh` + `scripts/fixtures/malformed-todos.md`: feeds known-bad
  inputs through the linter and every configured PreToolUse hook; fails unless
  they reject them. Wired into /health-check (check 7) and
  `.github/workflows/selftest.yml`.
- Alongside: starter allow/deny permission lists in settings.json, stale model
  alias fix, doc/skill updates.

## Verification

`./scripts/selftest.sh` → 5/5 passing; `bash scripts/lint-todo.sh docs/todos.md`
passes; malformed fixture fails with 3 errors.
