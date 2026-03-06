# Debug Test Failure Skill

**Agent-callable skill for systematic debugging of test failures.**

This skill provides a structured approach to investigating and fixing failing tests.

---

## Inputs

- **test_file**: Path to failing test file (e.g., `backend/tests/test_routers.py`)
- **test_name**: Specific test that failed (optional - if blank, debugs all failures in file)
- **error_message**: Error message from test output

---

## Debugging Workflow

### Phase 1: Gather Information

**1. Read test file**
```bash
cat {test_file}
```

Understand:
- What is being tested?
- What are the assertions?
- What fixtures/mocks are used?

**2. Run single test with verbose output**
```bash
# Backend (Python)
python3 -m pytest {test_file}::{test_name} -vv -s

# Frontend (JavaScript)
npm test -- --testNamePattern="{test_name}" --verbose
```

**3. Check recent changes**
```bash
git diff HEAD~1 {test_file}
git log --oneline -5 -- {test_file}
```

Did recent changes break the test?

### Phase 2: Identify Root Cause

**Common failure patterns:**

#### Import Error
```
ModuleNotFoundError: No module named 'foo'
```
**Fix:** Install dependency or check import path
```bash
pip install foo
# or
python3 -c "import foo"  # Verify it works
```

#### Assertion Failure
```
AssertionError: assert 200 == 404
```
**Fix:**
1. Check if endpoint exists: `grep -r "/api/path" backend/`
2. Verify response: Add `print(response.json())` before assertion
3. Check request payload: Ensure test data matches API expectations

#### Mock Not Working
```
AttributeError: Mock object has no attribute 'foo'
```
**Fix:**
1. Check mock setup: `mock.return_value` vs `mock.side_effect`
2. Verify mock is patched at correct location
3. Ensure mock is called: `mock.assert_called_once()`

#### Fixture Error
```
fixture 'client' not found
```
**Fix:**
1. Check conftest.py exists: `ls backend/tests/conftest.py`
2. Verify fixture is defined: `grep -n "def client" backend/tests/conftest.py`
3. Import fixture if needed: `from conftest import client`

#### Timing/Race Condition
```
Test passed locally but fails in CI
```
**Fix:**
1. Add `time.sleep()` or `await asyncio.sleep()`
2. Use `waitFor()` in frontend tests
3. Increase timeout: `timeout=10` parameter

### Phase 3: Fix and Verify

**1. Make minimal fix**

Don't refactor the entire test suite. Fix the specific failure.

**2. Run test again**
```bash
python3 -m pytest {test_file}::{test_name} -vv
```

**3. Run full test suite**
```bash
# Backend
python3 -m pytest backend/tests/

# Frontend
npm test -- --watchAll=false
```

Ensure fix didn't break other tests.

**4. Check coverage**
```bash
python3 -m pytest --cov=backend --cov-report=term-missing backend/tests/
```

Did fix reduce coverage? If yes, add missing assertions.

### Phase 4: Document (if pattern found)

If debugging revealed a **common pattern**, add to MEMORY.md:

```markdown
## Debugging Patterns

### Frontend npm test requires npm ci first
If `npm test` fails with module errors, run `npm ci` to install dependencies first.

### Pytest fixture not found
Check `backend/tests/conftest.py` for fixture definitions.
Fixtures must be in conftest.py or imported explicitly.
```

---

## Common Commands

**Run specific test:**
```bash
# Python - single test
python3 -m pytest backend/tests/test_api.py::test_get_hotels -vv

# Python - test class
python3 -m pytest backend/tests/test_api.py::TestHotels -vv

# JavaScript - pattern match
npm test -- --testNamePattern="Hotel component"
```

**Run with debugging:**
```bash
# Python - drop into debugger on failure
python3 -m pytest --pdb backend/tests/test_api.py

# Python - print output
python3 -m pytest -s backend/tests/test_api.py

# JavaScript - run without watch
npm test -- --watchAll=false
```

**Check test coverage:**
```bash
# Python
python3 -m pytest --cov=backend --cov-report=html backend/tests/
open htmlcov/index.html

# JavaScript
npm test -- --coverage --watchAll=false
```

---

## Success Criteria

- [ ] Identified root cause of failure
- [ ] Made minimal fix (no unnecessary refactoring)
- [ ] Test now passes in isolation
- [ ] Full test suite still passes
- [ ] Coverage maintained or improved
- [ ] Documented pattern if reusable (add to MEMORY.md)

---

## Escalation

If unable to fix after 3 attempts:

1. **Check for external dependencies**
   - Is API running? Database seeded?
   - Are env vars set? `.env` file present?

2. **Compare with working tests**
   - Find similar passing test
   - Diff the setup/fixtures

3. **Search git history**
   ```bash
   git log --all -p -S "test_name"
   ```
   When was this test last working?

4. **Ask for help**
   - Include: test file, error message, what you tried
   - Attach: git diff, test output, relevant code
