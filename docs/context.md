# Project Context (Quick Reference)

**Last updated:** [DATE]

---

## What This Is (Stable)

**[Project Name]** — [One sentence description of what this project does and who it serves.]

### Core Value Props
- [Value 1]
- [Value 2]
- [Value 3]

### Tech Stack
- **Backend**: [e.g., Python FastAPI + PostgreSQL]
- **Frontend**: [e.g., Next.js 15 + TypeScript + Tailwind]
- **AI**: [e.g., Anthropic Claude]
- **Infrastructure**: [e.g., Docker + GitHub Actions]

---

## Key Numbers (Volatile — update when code changes)

- [N] API endpoints
- [N] frontend components / pages
- [N] database tables
- [N] backend tests ([N]% coverage)
- [N] E2E tests

---

## Data Storage

- **[Database]**: `[path]` — [what's in it]
- **[Cache]**: `[path]` — [what's cached, TTL]
- **[Files]**: `[path]` — [what's stored]

---

## Key Files

- `[path]` — [what it does, why important]
- `[path]` — [what it does, why important]
- `[path]` — [what it does, why important]

---

## Architecture Patterns

- **[Pattern name]**: [Brief description]
- **[Pattern name]**: [Brief description]
- **[Pattern name]**: [Brief description]

---

## Current State

- ✅ [Working feature 1]
- ✅ [Working feature 2]
- 🚧 [In-progress feature]
- ❌ [Not yet implemented]

---

## Claude Code Configuration

**Project Rules:**
- `CLAUDE.md` — Memory system, core workflow, delegation basics, context management
- `.claude/rules/` — Stack-specific patterns

**Subagents:**
- `doc-scribe` — Updates docs/* only, uses Haiku
- `test-runner` — Runs tests read-only, uses Haiku
- `code-reviewer` — Reviews diffs, uses Sonnet

**Skills:**
- `.claude/skills/` — add-api-endpoint, update-memory-docs, debug-test-failure, delegate-to-subagent

**Hooks:**
- PreCompact: Save HANDOFF.md before auto-compaction
- PostToolUse: Auto-format code after edits
- PreToolUse: Block direct .env file edits
