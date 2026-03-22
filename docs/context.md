# Project Context (Quick Reference)

**Last updated:** [DATE]

---

## What This Is (Stable)

**[Project Name]** — [One sentence description of what this project does and who it serves.]

<!--
EXAMPLE:
**TaskFlow** — A lightweight task management API that helps small teams track
work items and deadlines without the overhead of full project management tools.
-->

### Core Value Props
- [Value 1]
- [Value 2]
- [Value 3]

### Tech Stack
- **Backend**: [e.g., Python FastAPI + PostgreSQL]
- **Frontend**: [e.g., Next.js 15 + TypeScript + Tailwind]
- **AI**: [e.g., Anthropic Claude]
- **Infrastructure**: [e.g., Docker + GitHub Actions]

<!--
EXAMPLE (Node.js API):
- **Backend**: Node.js 20 + Express 4 + SQLite
- **Auth**: JWT (jsonwebtoken)
- **Testing**: Jest + Supertest
- **Infrastructure**: Railway (hosting), GitHub Actions (CI)
-->

---

## Key Numbers (Volatile — update when code changes)

- [N] API endpoints
- [N] frontend components / pages
- [N] database tables
- [N] backend tests ([N]% coverage)
- [N] E2E tests

<!--
EXAMPLE:
- 12 API endpoints (GET/POST/PUT/DELETE on /tasks, /users, /teams)
- 3 database tables (tasks, users, team_memberships)
- 47 unit tests (82% coverage)
-->

---

## Data Storage

- **[Database]**: `[path]` — [what's in it]
- **[Cache]**: `[path]` — [what's cached, TTL]
- **[Files]**: `[path]` — [what's stored]

<!--
EXAMPLE:
- **SQLite**: `data/app.db` — tasks, users, team_memberships
- **File cache**: `data/cache/` — API response cache (1-hour TTL)
-->

---

## Key Files

- `[path]` — [what it does, why important]
- `[path]` — [what it does, why important]
- `[path]` — [what it does, why important]

<!--
EXAMPLE:
- `src/routes/tasks.js`    — CRUD endpoints for tasks (main feature)
- `src/middleware/auth.js` — JWT validation (applied to all /api/* routes)
- `src/db/schema.sql`      — Database schema (source of truth for data shape)
- `src/config.js`          — Environment config loader
-->

---

## Architecture Diagram

<!--
Draw a simple ASCII diagram of how the main components connect.

EXAMPLE:
  Browser
     │
     ▼
  Next.js (port 3000)
     │ fetch /api/*
     ▼
  Express API (port 8000)
     │
     ├── SQLite (data/app.db)
     └── External: Anthropic API
-->

```
[Your architecture here]
```

---

## Architecture Patterns

- **[Pattern name]**: [Brief description]
- **[Pattern name]**: [Brief description]
- **[Pattern name]**: [Brief description]

<!--
EXAMPLE:
- **Repository pattern**: DB queries isolated in `src/db/*.js` files, not inline in routes
- **Middleware chain**: auth → rate-limit → validation → handler
- **Error convention**: All errors return `{ error: string, code: string }` JSON
-->

---

## Current State

- ✅ [Working feature 1]
- ✅ [Working feature 2]
- 🚧 [In-progress feature]
- ❌ [Not yet implemented]

---

## Claude Code Configuration

**Project Rules:**
- `CLAUDE.md` — Core workflow, delegation, conventions, context management
- `.claude/rules/` — Anti-patterns, model assignments

**Agents:**
- `doc-scribe` — Updates docs/* only, uses Haiku (`memory: project`, `effort: low`)
- `test-runner` — Runs tests read-only, uses Haiku (`effort: low`)
- `code-reviewer` — Reviews diffs, uses Sonnet (`memory: project`, `effort: high`)

**Skills:**
- `/finish`, `/context-refresh` — Core workflow
- `/health-check`, `/improve`, `/audit` — Introspection system
- `/template-update` — Upstream sync check
- `/delegate`, `/update-memory-docs` — Reference guides
- `/add-api-endpoint`, `/debug-test-failure` — Examples (replace for your stack)

**Hooks:**
- PreCompact: Save HANDOFF.md before auto-compaction
- PostToolUse: Auto-format code after edits
- PreToolUse: Block direct .env file edits
