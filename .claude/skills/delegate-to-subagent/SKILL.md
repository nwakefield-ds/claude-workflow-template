---
name: delegate-to-subagent
description: Guidance on when and how to delegate work to agents
---

# Delegation Strategy

## Available Agents

| Agent | Model | Purpose | Can do |
|-------|-------|---------|--------|
| doc-scribe | Haiku | Update docs/* | Read, Edit docs/ |
| test-runner | Haiku | Run tests, report results | Bash (tests), Read |
| code-reviewer | Sonnet | Review diffs for bugs/security | Read, Bash (git diff) |

## When to Delegate

**Do:** Verbose test runs, multi-doc updates, large diff reviews, multi-file searches (Explore agent).

**Don't:** Reading 1-3 files (Read), simple edits (Edit), quick searches (Grep/Glob).
