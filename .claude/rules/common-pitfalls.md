# Common Anti-Patterns

## Workflow Anti-Patterns

| Don't | Do instead |
|-------|-----------|
| Start coding without reading docs | Read `docs/context.md`, `decisions.md`, `dev.md`, `todos.md` first |
| Make large unfocused commits (500+ lines) | One feature/fix per commit, <300 lines each |
| Change code without updating docs | Update at least one memory doc per code commit |
| Skip verification script | Always run `./scripts/verify-memory-and-checks.sh` before committing |
| Hold all context in chat history | Write decisions to `docs/decisions.md`, use HANDOFF.md for session continuity |
| Make architectural decisions without documenting | Add ADR to `docs/decisions.md` with context, decision, rationale |
| Push to main without tests passing | Run verify script first, use pre-push hook |
| Edit .env files directly | Use `.env.example` as template; user fills in secrets manually |

## Code Anti-Patterns

| Don't | Do instead |
|-------|-----------|
| Bare `except:` clauses | Catch specific exceptions (`except ValueError as e:`) |
| Skip type hints (Python) or use `any` (TS) | Add type annotations to function signatures |
| Hardcode config values or secrets | Use config files / env vars |
| String-concatenate SQL queries | Use parameterized queries |
| Leave resources unclosed | Use context managers (`with`) or try/finally |
| Ignore linting warnings | Run formatter and linter before committing |
| Copy code without understanding it | Read, understand, adapt — or extract shared utility |
| Skip edge case tests | Test null, empty, boundary values, negative cases |

## Recovery

```bash
# Undo last commit (not pushed)
git reset --soft HEAD~1

# Revert pushed commit
git revert HEAD && git push origin main

# Find breaking commit
git bisect start && git bisect bad && git bisect good <hash>
```

See `docs/dev.md` for detailed recovery procedures.
