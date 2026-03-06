# Common Anti-Patterns (Don't Do This)

**Scope:** All code changes across backend, frontend, and infrastructure.

---

## ❌ Making changes without reading docs first

**Why bad:** You'll miss context, make inconsistent changes, and duplicate work that's already documented.

**Do instead:**
```bash
# Always start here
cat docs/context.md      # What this project is
cat docs/decisions.md    # Why things are the way they are
cat docs/dev.md         # How to set up, run, test
cat docs/todos.md       # What to work on next
```

---

## ❌ Large, unfocused commits (500+ lines)

**Why bad:** Hard to review, hard to revert, high risk of introducing bugs, mixes multiple concerns.

**Do instead:**
- Break into smaller, logical commits (<300 lines each)
- One feature/fix per commit
- Each commit should be independently testable
- Use git add -p for selective staging if needed

**Example of good commit sequence:**
```
feat: add API endpoint for specialist chat (120 lines)
test: add tests for specialist chat endpoint (80 lines)
docs: update context.md with new endpoint count (5 lines)
```

---

## ❌ Changing code without updating docs

**Why bad:** Docs become stale, future Claude (or developers) lose context, memory system breaks down.

**Do instead:** Update at least one memory doc every code commit:
- Changed key numbers? → Update `docs/context.md`
- Made architectural choice? → Add to `docs/decisions.md`
- Changed setup/commands? → Update `docs/dev.md`
- Completed/added work? → Update `docs/todos.md`

---

## ❌ Skipping verification script

**Why bad:** Pushes broken code, docs get out of sync, CI fails, wastes time debugging later.

**Do instead:** Always run before committing:
```bash
./scripts/verify-memory-and-checks.sh
```

Or use the pre-push hook to enforce automatically.

---

## ❌ Trying to hold all context in chat history

**Why bad:** Context limits hit, important info lost during auto-compaction, relying on chat memory instead of durable docs.

**Do instead:** Trust the memory docs system:
- Write decisions to `docs/decisions.md` immediately
- Update `docs/context.md` with key numbers as they change
- Use HANDOFF.md for session-to-session continuity
- Use WORKING_SET.md for multi-day investigations
- Compact manually at ~65% context usage (`/compact`)

---

## ❌ Making architectural decisions without documenting them

**Why bad:** Future you (or other developers) won't understand why, leads to inconsistent changes, decision rationale is lost.

**Do instead:** Add entry to `docs/decisions.md` with:
```markdown
## [Date]: [Decision Title] [STATUS TAG]

**Context:** What problem were we solving?

**Decision:** What did we choose?

**Rationale:** Why did we choose this? What alternatives were considered?

**Files:** Which files implement this decision?
```

---

## ❌ Bare except clauses (`except:`)

**Why bad:** Catches SystemExit and KeyboardInterrupt, makes debugging impossible, hides real errors.

**Do instead:**
```python
# ❌ BAD
try:
    risky_operation()
except:  # Catches EVERYTHING including Ctrl+C
    pass

# ✅ GOOD
try:
    risky_operation()
except ValueError as e:  # Specific exception
    logger.error(f"Invalid input: {e}")
    raise HTTPException(status_code=400, detail=str(e))
except Exception as e:  # Catch-all for unexpected errors
    logger.error(f"Unexpected error: {e}")
    raise HTTPException(status_code=500, detail="Internal server error")
```

---

## ❌ Not using type hints (Python) or TypeScript (JS)

**Why bad:** No autocomplete, runtime type errors, harder to refactor, unclear interfaces.

**Do instead:**
```python
# ✅ GOOD (Python)
def search_hotels(location: str, radius_km: float) -> list[Hotel]:
    ...

# ✅ GOOD (TypeScript)
function searchHotels(location: string, radiusKm: number): Hotel[] {
    ...
}
```

---

## ❌ Hardcoding configuration values

**Why bad:** Can't change without code deploy, different values for dev/prod, secrets leak into git.

**Do instead:**
```python
# ❌ BAD
api_key = "sk-1234567890abcdef"
timeout = 30

# ✅ GOOD
from backend.config import get_config
config = get_config()
api_key = config.google_api_key  # From .env
timeout = config.discovery_timeout  # Configurable via admin panel
```

---

## ❌ String concatenation for SQL queries

**Why bad:** SQL injection vulnerability, brittle quoting, hard to read.

**Do instead:**
```python
# ❌ BAD
query = f"SELECT * FROM hotels WHERE name = '{hotel_name}'"  # SQL injection!

# ✅ GOOD
query = "SELECT * FROM hotels WHERE name = ?"
cursor.execute(query, (hotel_name,))  # Parameterized query
```

---

## ❌ Not cleaning up resources (files, connections, processes)

**Why bad:** Resource leaks, file handle exhaustion, connection pool exhaustion, orphaned processes.

**Do instead:**
```python
# ❌ BAD
conn = sqlite3.connect('data/hotels.db')
result = conn.execute("SELECT * FROM hotels")
# Connection never closed if exception occurs

# ✅ GOOD
with self.connection() as conn:  # Context manager ensures cleanup
    result = conn.execute("SELECT * FROM hotels")
    return result.fetchall()
# Connection closed automatically, even on exception
```

---

## ❌ Pushing to main without tests passing

**Why bad:** Breaks CI, breaks other developers, creates technical debt.

**Do instead:**
```bash
# 1. Run tests locally
./scripts/verify-memory-and-checks.sh

# 2. Commit only if passing
git add .
git commit -m "feat: add new feature"

# 3. Push
git push origin main

# 4. Or use pre-push hook to enforce automatically
```

---

## ❌ Ignoring linting warnings

**Why bad:** Inconsistent code style, potential bugs (unused imports, undefined variables), harder to review.

**Do instead:**
```bash
# Backend
black backend/  # Auto-format (PostToolUse hook does this automatically)
ruff check backend/  # Lint

# Frontend
npm run lint  # ESLint
npm run format  # Prettier
```

---

## ❌ Using `any` type everywhere (TypeScript)

**Why bad:** Defeats the purpose of TypeScript, loses type safety, no autocomplete.

**Do instead:**
```typescript
// ❌ BAD
const data: any = await fetch('/api/data')  // Type safety lost

// ✅ GOOD
interface ExpeditionResponse {
  id: string
  destination: string
  routes: RouteOption[]
}
const data: ExpeditionResponse = await fetch('/api/data')  // Typed!
```

---

## ❌ Editing .env files directly via Claude

**Why bad:** Secrets get logged in chat history, risk of committing secrets to git.

**Do instead:**
- Use `.env.example` as template (this is safe to edit)
- User manually copies to `.env` and fills in secrets
- PreToolUse hook blocks direct .env edits automatically

---

## ❌ Not testing edge cases

**Why bad:** Production bugs with null, empty input, very large values, off-by-one errors.

**Do instead:**
```python
# Test edge cases
def test_search_empty_location():
    with pytest.raises(ValueError):
        search_hotels(location="", radius_km=10)

def test_search_negative_radius():
    with pytest.raises(ValueError):
        search_hotels(location="Paris", radius_km=-5)

def test_search_very_large_radius():
    # Should cap at max radius, not crash
    result = search_hotels(location="Paris", radius_km=999999)
    assert result is not None
```

---

## ❌ Copying code without understanding it

**Why bad:** Introduces bugs, inconsistent patterns, technical debt, can't debug when it breaks.

**Do instead:**
- Read the code you're copying
- Understand what it does and why
- Adapt it to your use case
- Add comments explaining non-obvious logic
- Better: refactor into a shared utility if used in multiple places

---

## Recovery

**Made a mistake? Don't panic:**

```bash
# Undo last commit (not pushed)
git reset --soft HEAD~1

# Revert pushed commit
git revert HEAD
git push origin main

# Find breaking commit (bisect)
git bisect start
git bisect bad  # Current state is broken
git bisect good <commit-hash>  # Known good commit
# Test at each step, mark good/bad
```

**See docs/dev.md for detailed recovery procedures.**
