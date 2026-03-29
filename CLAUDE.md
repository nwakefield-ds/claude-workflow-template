# Claude Code Project Rules

**Code is truth. Docs are navigation. Read code for implementation context.**

---

## Workflow

### Before coding:
- Check `docs/todos.md` for current priorities
- Read the actual code files you'll be changing
- Plan your approach before implementing — outline what you'll change and why, especially for non-trivial tasks. Use plan mode for complex features.

### After coding:
- Update project docs if anything changed (see table below)
- Run `./scripts/verify-memory-and-checks.sh`
- Use `/finish` for commit workflow

### Test command:
```bash
# TODO: Replace with your project's test command
python3 -m pytest tests/ -v
```

### Enforcement model:
- **Hook-enforced** (automatic): auto-format on save, `.env` edit blocking, HANDOFF.md save before compaction
- **Script-enforced** (manual): `verify-memory-and-checks.sh` — doc updates with code changes, lint, tests
- **Advisory** (LLM follows instructions): conventional commits, reading docs before coding, delegation patterns

---

## Project Docs

| Doc | Purpose | When to read | When to update |
|-----|---------|-------------|----------------|
| `docs/todos.md` | Roadmap & priorities | Before starting work | Task completed or discovered |
| `docs/decisions.md` | Architectural decision records | Working in area with prior decisions | Made an architectural choice |
| `docs/context.md` | Quick nav — entry points, storage, config | Orienting in unfamiliar area | Rarely (entry points change infrequently) |
| `docs/dev.md` | Setup, commands, troubleshooting | Setting up or debugging env | Commands or setup changed |

---

## Delegation

- `doc-scribe` (Haiku) — Updates docs/* only
- `test-runner` (Haiku) — Runs tests, reports results
- `code-reviewer` (Sonnet) — Reviews diffs for bugs/security

Agents are defined in `.claude/agents/`. Use them for verbose tests, large diff reviews, multi-doc updates.
Use Read/Edit/Grep directly for 1-3 files.

---

## Conventions

- Conventional commits: `feat(scope):`, `fix(scope):`, `refactor:`, `docs:`, `test:`, `chore:`

---

## Introspection

This repo includes commands to maintain setup quality:
- `/health-check` — weekly, catch config drift
- `/improve` — monthly, find improvements and research new capabilities
- `/audit` — quarterly or when the repo's shape changes significantly
- `/zero-base` — as needed, first-principles re-evaluation that assumes nothing is sacred

---

## Context Management

- Compact at ~65% context (~130K tokens) with `/compact` (use `/compact Focus on X` for targeted compaction)
- Use `/clear` between unrelated tasks
- Use `/btw` for side questions that shouldn't enter context history
- Use `/rewind` or `Esc+Esc` to restore conversation and code to any checkpoint
- HANDOFF.md auto-saved before compaction (PreCompact hook)

## TODO system

This repo uses a structured TODO tracking system.

**Check project size first:** read `scripts/config.sh`. If `PROJECT_SIZE=small`, skip the structured TODO workflow — `docs/todos.md` is a free-form checklist and no format is enforced.

### Reading TODOs
- `docs/todos.md` is the lightweight index. Read it at the start of every session.
- Full specs live in `docs/plan/T-XX-slug.md`. Read the spec before starting work on a task.

### TODO.md entry format (enforced by linter)
Each entry under a section (Active / Blocked / Done) follows this pattern:
```
### T-XX: Short title `slug`
P1 | M | Status: open | Owner: backend
Spec: docs/plan/T-XX-slug.md
- [ ] deliverable 1
- [ ] deliverable 2
- [ ] deliverable 3
Files: `src/auth/`, `tests/auth/`
```

### Rules for agents
1. **Start of session:** read `docs/todos.md`. Identify your task or pick the highest priority open task.
2. **Claim work:** change Status from `open` to `in-progress` before starting.
3. **Read the spec:** open the linked spec file in `docs/plan/` before writing code.
4. **Check off deliverables:** mark `- [x]` as you complete each one.
5. **Update status:** set `done` when all deliverables are checked. Move the entry to the `## Done` section.
6. **Never delete entries:** completed tasks stay in `## Done` for history.
7. **Adding new tasks:** use `./scripts/todo.sh add <slug> "<title>"` or manually follow the format.
8. **Before committing:** run `./scripts/lint-todo.sh` to validate format.

### Valid values
- **Priority:** P0 (critical), P1 (high), P2 (medium), P3 (low)
- **Effort:** XS (<1h), S (1-4h), M (4h-2d), L (2-5d), XL (>5d)
- **Status:** open, in-progress, blocked, done
