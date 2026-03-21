---
name: finish
description: Full end-of-task workflow — update docs, run checks, review code, suggest commit
---

# /finish

Full end-of-task workflow: update docs, run checks, review code, suggest commit.

Run this when you've completed a feature or fix and are ready to commit.

---

## Steps

### 1. Update Project Docs

At minimum, update one doc to reflect the changes made:

- **Code changed key numbers?** → `docs/context.md` (endpoint count, table count, etc.)
- **Architectural decision made?** → `docs/decisions.md` (new ADR entry)
- **Commands or setup changed?** → `docs/dev.md`
- **Task completed or new work found?** → `docs/todos.md` (mark done, add new items)

Use the `doc-scribe` agent if multiple docs need updating:
```
Delegate to doc-scribe: "Update docs to reflect [describe changes]"
```

### 2. Run Verification

```bash
./scripts/verify-memory-and-checks.sh
```

If it fails:
- Fix the reported issues before continuing
- Do NOT use `--skip-doc-check` unless truly an emergency

### 3. Code Review

Invoke the `code-reviewer` agent on the current diff:

```
Delegate to code-reviewer: "Review the changes since origin/main for bugs and security issues"
```

If the reviewer finds **critical issues** → fix them before committing.
If the reviewer finds **warnings** → use judgment, note them in the commit message if deferred.

### 4. Suggest a Commit Message

Generate a conventional commit message following this format:

```
<type>(<scope>): <short summary>

<optional body — what changed and why, if not obvious>

<optional footer — breaking changes, closes issues>
```

**Types:**
- `feat:` — New feature (triggers doc enforcement in verify script)
- `fix:` — Bug fix (warns if docs not updated)
- `refactor:` — Internal restructure, no behavior change (warns about docs)
- `chore:` — Maintenance, no logic change (skips doc check)
- `docs:` — Documentation only
- `test:` — Tests only
- `ci:` — CI/CD changes

**Example:**
```
feat(api): add pagination to GET /tasks endpoint

Adds ?page=N&limit=N query params. Default limit: 20, max: 100.
Returns { data, total, page, pages } envelope.

Closes #42
```

### 5. Confirm with User

Present the commit message and ask the user to confirm before committing.
Do NOT auto-commit without explicit user approval.

---

## Quick Reference

```
/finish
  │
  ├── 1. Update docs/ (or delegate to doc-scribe)
  ├── 2. Run ./scripts/verify-memory-and-checks.sh
  ├── 3. Delegate to code-reviewer
  └── 4. Suggest commit message → wait for user approval
```
