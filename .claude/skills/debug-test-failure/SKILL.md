---
name: debug-test-failure
description: Systematic workflow for debugging failing tests
---

# Debug Test Failure

## Workflow

1. **Read the failing test** — understand assertions, fixtures, mocks
2. **Run it isolated:** `python3 -m pytest tests/test_file.py::test_name -vv -s`
3. **Check recent changes:** `git diff HEAD~1 -- <test_file>`
4. **Fix minimally** — don't refactor the whole suite
5. **Run full suite** to verify no regressions

## Common Patterns

- **Import errors** → missing dep or wrong import path
- **Assertion failures** → add `print()` before assertion, check test data
- **Mock not working** → verify patch target matches import path
- **Fixture not found** → check `tests/conftest.py`
