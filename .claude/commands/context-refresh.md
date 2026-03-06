# /context-refresh

Re-ground in project memory at the start of a session or after context drift.

---

## Steps

1. **Read memory docs in order:**

```
docs/context.md     ← What the project is (tech stack, key files, numbers)
docs/decisions.md   ← Why things are the way they are (ADRs)
docs/dev.md         ← How to set up and run
docs/todos.md       ← What to work on next
```

2. **Check HANDOFF.md** for state from the previous session:

```
HANDOFF.md          ← Auto-saved git state before last compaction
```

3. **Output a structured summary** covering:

```
## Project: [Name]
[One sentence description]

## Tech Stack
[Language, framework, database]

## Current State
[What's working, what's in progress, what's blocked]

## Top Priority
[The P0/P1 task from docs/todos.md that should be worked on next]

## Previous Session
[Summary of HANDOFF.md — branch, uncommitted changes, last task]

## Ready
[Confirm ready to start work]
```

4. **Ask the user** what they'd like to work on, or confirm the top priority task.

---

## When to Use

- Start of every new session
- After `/compact` or context reset
- When the session feels confused or stale
- After switching branches or tasks

---

## Notes

- Do NOT start coding until the summary is produced
- If `docs/` files are missing or empty, prompt the user to fill them in
- HANDOFF.md may be stale (from a previous day) — note the timestamp
