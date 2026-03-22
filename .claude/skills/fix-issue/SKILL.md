---
name: fix-issue
description: Fix a GitHub issue end-to-end — fetch, implement, test, commit, PR
disable-model-invocation: true
---

Analyze and fix the GitHub issue: $ARGUMENTS

1. Use `gh issue view $ARGUMENTS` to get the issue details
2. Understand the problem described in the issue
3. Search the codebase for relevant files
4. Implement the necessary changes to fix the issue
5. Write and run tests to verify the fix
6. Ensure code passes linting and type checking
7. Run `./scripts/verify-memory-and-checks.sh`
8. Create a descriptive commit message following conventional commits
9. Push and create a PR with `gh pr create`
