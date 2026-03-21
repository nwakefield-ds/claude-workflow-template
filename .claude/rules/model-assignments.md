# Model Assignments

Single source of truth for agent model assignments.
Update this file when changing models — then update each agent's frontmatter to match.

## Current Assignments

| Agent | Model | Reason |
|-------|-------|--------|
| `doc-scribe` | `haiku` | Doc updates are simple edits; Haiku is cheaper than Sonnet |
| `test-runner` | `haiku` | Reading test output requires no deep reasoning |
| `code-reviewer` | `sonnet` | Security review and bug detection need strong reasoning |
| Main session | `sonnet` | Default for interactive coding sessions |

## Changing a Model

1. Update the table above
2. Edit the `model:` field in the relevant `.claude/agents/*.md` frontmatter
3. Commit both files together so they stay in sync

## Available Models

| Alias | Best For |
|-------|----------|
| `haiku` | Fast, cheap: doc edits, test runs, simple searches |
| `sonnet` | Balanced: code review, architecture, interactive dev |
| `opus` | Strongest reasoning: complex refactors, security audits |
| `opusplan` | Opus in plan mode, Sonnet in execution |
