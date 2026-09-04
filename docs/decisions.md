# Architectural Decisions

Record of significant architectural choices, with context and rationale.

**Status tags:** `[ACTIVE]` | `[SUPERSEDED]` | `[EXPERIMENTAL]` | `[DEPRECATED]`

---

## Entry Format

```markdown
## [Date]: [Decision Title] [STATUS]

**Context:** What problem were we solving?

**Decision:** What did we choose?

**Rationale:** Why this approach? What alternatives were considered?

**Consequences:**
- ✅ What this makes easier
- ⚠️ What this makes harder or trades off

**Files:** Which files implement this decision?
```

---

<!--
EXAMPLE ENTRY — copy and adapt for your own decisions:

## 2024-01-15: Use SQLite instead of PostgreSQL [ACTIVE]

**Context:** We need persistent storage for tasks and users. The app is
single-tenant with low write volume (<100 writes/day in initial phase).

**Decision:** Use SQLite with a file at `data/app.db`.

**Rationale:**
- Zero infrastructure setup (no separate DB server to manage)
- Sufficient for single-tenant, low-write workload
- Easy to back up (just copy the file)
- Alternative considered: PostgreSQL — rejected because it adds ops overhead
  with no benefit at this scale

**Consequences:**
- ✅ Simpler local dev (no docker-compose needed)
- ✅ Easy backups via file copy
- ⚠️ Will need migration to Postgres if we go multi-tenant or high write volume

**Files:** `src/db/connection.js`, `src/db/schema.sql`, `data/app.db`
-->

## [Date]: [Your First Decision] [ACTIVE]

**Context:** [What triggered this decision?]

**Decision:** [What was chosen?]

**Rationale:**
- [Reason 1]
- [Reason 2]
- Alternative considered: [What else was evaluated and why rejected]

**Consequences:**
- ✅ [What this makes easier]
- ⚠️ [What this makes harder or trades off]

**Files:** `[file1]`, `[file2]`

## 2026-09-04: Enforcement layer must be self-tested; auto-format hook removed [ACTIVE]

**Context:** A /improve audit found all three "hook-enforced" mechanisms silently
fail-open: the TODO linter's `^#` catch-all skipped every `### T-XX` entry header,
the `.env` block parsed a legacy hook JSON schema (current contract nests input
under `tool_input`) and used a non-blocking exit code, and the auto-format hook
piped the literal string `$CLAUDE_TOOL_INPUT`. Nothing ever exercised the
enforcement tooling, so the rot was invisible for months.

**Decision:** Fix the linter and `.env` hook against the current hook contract
(stdin JSON, `tool_input` nesting, exit 2 + stderr to block); delete the
auto-format hook instead of fixing it; add `scripts/selftest.sh` (run by
/health-check and CI) that feeds known-bad inputs through the linter and hooks
and fails unless they reject them.

**Rationale:**
- Enforcement that isn't itself tested decays silently — reference-level checks
  (/health-check's stale-path scan) cannot catch behavioral failures.
- The format hook was never missed while broken, and current community guidance
  flags auto-format hooks as a token-burn/retrigger anti-pattern. Deleting beats
  fixing. Alternative considered: fixing it — rejected as unearned complexity.

**Consequences:**
- ✅ Fail-open regressions in hooks/linter now surface in /health-check and CI
- ✅ Downstream repos cloned from the template inherit working guards
- ⚠️ Python formatting is no longer automatic; run formatters via the verify
  script or a git hook

**Files:** `scripts/selftest.sh`, `scripts/fixtures/malformed-todos.md`, `scripts/lint-todo.sh`, `.claude/settings.json`, `.github/workflows/selftest.yml`
