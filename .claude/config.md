# Claude Code Configuration

Single source of truth for model assignments and agent settings.
Update this file when changing models — then update each subagent's frontmatter to match.

---

## Model Assignments

| Agent | Model | Reason |
|-------|-------|--------|
| `doc-scribe` | `haiku` | Doc updates are simple edits; Haiku is ~40% cheaper than Sonnet |
| `test-runner` | `haiku` | Reading test output requires no deep reasoning |
| `code-reviewer` | `sonnet` | Security review and bug detection need strong reasoning |
| Main session | `sonnet` | Default for interactive coding sessions |

### Changing a Model

1. Update the table above
2. Edit the `model:` field in the relevant `.claude/subagents/*.md` frontmatter
3. Commit both files together so they stay in sync

### Available Models (as of 2025)

| Model ID | Alias | Best For |
|----------|-------|----------|
| `claude-haiku-4-5-20251001` | `haiku` | Fast, cheap: doc edits, test runs, simple searches |
| `claude-sonnet-4-6` | `sonnet` | Balanced: code review, architecture, interactive dev |
| `claude-opus-4-6` | `opus` | Strongest reasoning: complex refactors, security audits |

---

## Hook Configuration

Hooks are defined in `.claude/settings.local.json`. Current hooks:

| Hook | Trigger | Action |
|------|---------|--------|
| PostToolUse (Edit/Write) | After any file edit | Auto-format with `black` (change for your stack) |
| PreToolUse (Edit) | Before editing `.env` | Block edit, prompt user to edit manually |
| PreCompact | Before context compaction | Run `save-handoff.sh` to capture git state |

### Changing the Auto-Formatter

Edit `.claude/settings.local.json` — replace `black "$FILE"` with your formatter:

```bash
# Python
black "$FILE"

# JavaScript / TypeScript
prettier --write "$FILE"

# Go
gofmt -w "$FILE"

# Ruby
rubocop -a "$FILE"
```

---

## Subagent Tool Permissions

Each subagent's `allowedTools` / `deniedTools` frontmatter restricts what it can do.
See individual files for details:

- `.claude/subagents/doc-scribe.md` — Read-only on code, Edit on `docs/*` only
- `.claude/subagents/test-runner.md` — Bash (test commands only), no Edit/Write
- `.claude/subagents/code-reviewer.md` — Read + `git diff/log/show`, no writes
