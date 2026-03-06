# Update Memory Docs Skill

**Lightweight skill for updating memory docs after small code changes.**

This is a simpler alternative to the `doc-scribe` subagent for quick updates.

---

## When to Use

Use this skill when:
- ✅ Key number changed (file count, endpoint count, router count)
- ✅ New file added to project
- ✅ Command or setup step changed
- ✅ Simple task completed (checkboxes in todos.md)

**Do NOT use for:**
- ❌ Architectural decisions (use `doc-scribe` subagent)
- ❌ Large refactors (use `doc-scribe` subagent)
- ❌ Complex changes spanning multiple memory docs

---

## Memory Docs Hierarchy

1. **docs/context.md** - What this project is
   - Tech stack
   - Key numbers (routers, endpoints, files, tests)
   - File structure
   - Architecture patterns

2. **docs/decisions.md** - Why things are the way they are
   - Architectural Decision Records (ADR format)
   - Status tags: [ACTIVE], [SUPERSEDED], [DEPRECATED]

3. **docs/dev.md** - How to set up and run
   - Environment setup
   - Commands (backend, frontend, observability)
   - Troubleshooting

4. **docs/todos.md** - What to work on next
   - Prioritized tasks (High/Medium/Low/Backlog)
   - Effort/value estimates
   - Acceptance criteria

---

## Quick Update Patterns

### Pattern 1: Endpoint Count Changed

```markdown
# docs/context.md

## Key Numbers
- 11 routers (hotels, discover, ...)
- 89 API endpoints total  # <- Increment this
- 148 test files
```

### Pattern 2: New Router Added

```markdown
# docs/context.md

## Key Numbers
- 11 routers → 12 routers  # Update count
- 89 endpoints → 94 endpoints  # Add new endpoints

## Key Files
...
**Routers:**
- `backend/routers/bookings.py` - Booking transactions  # <- Add this
```

### Pattern 3: Command Changed

```markdown
# docs/dev.md

### Backend (Port 8000)

```bash
cd backend
uvicorn api:app --reload  # <- Update command
```
```

### Pattern 4: Task Completed

```markdown
# docs/todos.md

## 🔴 High Priority

### T-38: Automate Verification Script
- [x] Install pre-push hook  # <- Check this
- [x] Test with dummy commit
- [x] Document in docs/dev.md

Status: ✅ COMPLETED 2026-02-15  # <- Add completion date
```

---

## Workflow

1. **Read the change**
   - What file was modified?
   - What numbers changed?
   - Was it a feature, refactor, or config change?

2. **Choose doc to update**
   - Key number → `docs/context.md`
   - Setup command → `docs/dev.md`
   - Task done → `docs/todos.md`

3. **Make minimal edit**
   - Update only what changed
   - Keep it concise (bullets, not essays)
   - No duplication from README or SPEC

4. **Verify accuracy**
   - Does count match `git ls-files | wc -l`?
   - Does command actually work?
   - Is todo checkbox state correct?

---

## Examples

### Example 1: Added 5 endpoints

**Change:** Added new admin router with 5 endpoints

**Update docs/context.md:**
```diff
  ## Key Numbers
- - 89 API endpoints total
+ - 94 API endpoints total (added 5 admin budget endpoints)
```

### Example 2: Completed task

**Change:** Implemented T-38 (pre-push hook)

**Update docs/todos.md:**
```diff
  ### T-38: Automate Verification Script

- - [ ] Install pre-push hook
- - [ ] Test with dummy commit
+ - [x] Install pre-push hook
+ - [x] Test with dummy commit

+ Status: ✅ COMPLETED 2026-02-15
```

### Example 3: New dev command

**Change:** Switched from `python api.py` to `uvicorn`

**Update docs/dev.md:**
```diff
  ### Backend

  ```bash
  cd backend
- python api.py
+ uvicorn api:app --reload --port 8000
  ```
```

---

## Success Criteria

- [ ] Updated correct memory doc (context/decisions/dev/todos)
- [ ] Edit is minimal (changed line(s) only)
- [ ] Numbers are accurate (verified with git/grep/wc)
- [ ] No duplicate info from README/SPEC
- [ ] Kept concise (bullets, not paragraphs)
