# Claude Code Project Rules

**Code is truth. Docs are navigation. Read code for implementation context.**

---

## Workflow

### Before coding:
- Check `docs/todos.md` for current priorities
- Read the actual code files you'll be changing
- Plan your approach before implementing — outline what you'll change and why, especially for non-trivial tasks. Use plan mode for complex features.

### After coding:
- Update `docs/todos.md` if a task was completed or discovered
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

---

## Context Management

- Compact at ~65% context (~130K tokens) with `/compact`
- Use `/clear` between unrelated tasks
- HANDOFF.md auto-saved before compaction (PreCompact hook)
