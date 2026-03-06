# Claude Code Workflow Template

A portable workflow system for Claude Code projects. Provides persistent memory, automated doc enforcement, code review, and session continuity.

## What's Included

```
CLAUDE.md                    ← Claude's instructions (auto-loaded)
HANDOFF.md                   ← Auto-saved session state before compaction
WORKING_SET.md               ← Manual multi-session investigation notes

docs/
  context.md                 ← What this project is (tech stack, key numbers)
  decisions.md               ← Why things are the way they are (ADRs)
  dev.md                     ← How to set up and run
  todos.md                   ← What to work on next (prioritized roadmap)

.claude/
  settings.local.json        ← Hooks (auto-format, block .env edits, save HANDOFF)
  hooks/
    save-handoff.sh          ← Captures git state before compaction
  subagents/
    doc-scribe.md            ← Haiku agent for updating docs (cost-effective)
    test-runner.md           ← Haiku agent for running tests (read-only)
    code-reviewer.md         ← Sonnet agent for reviewing diffs
  skills/
    add-api-endpoint.md      ← Step-by-step endpoint addition workflow
    update-memory-docs.md    ← Quick doc update patterns
    debug-test-failure.md    ← Systematic debugging workflow
    delegate-to-subagent.md  ← When/how to use subagents
  rules/
    common-pitfalls.md       ← Anti-patterns and how to avoid them

scripts/
  verify-memory-and-checks.sh  ← Pre-push hook: enforce docs + run tests
```

## Quick Start

### 1. Copy into your project

```bash
cp -r claude-workflow-template/. /path/to/your-project/
cd /path/to/your-project
```

### 2. Fill in the docs

```bash
# Either fill in manually:
vim docs/context.md   # Add your tech stack, key files, architecture
vim docs/dev.md       # Add your setup commands

# Or let Claude do it:
# Open Claude Code and run:
# "Read the codebase and populate docs/context.md, docs/dev.md, and docs/decisions.md"
```

### 3. Install the pre-push hook

```bash
chmod +x scripts/verify-memory-and-checks.sh
ln -s ../../scripts/verify-memory-and-checks.sh .git/hooks/pre-push
chmod +x .git/hooks/pre-push
```

### 4. Add stack-specific rules (optional)

Create `.claude/rules/backend/` or `.claude/rules/frontend/` with patterns for your stack:
- Error handling conventions
- Testing patterns
- Naming conventions
- Security rules

### 5. Adjust hooks for your language

Edit `.claude/settings.local.json` — the PostToolUse hook auto-formats Python with `black`.
Change to your formatter:
- **JS/TS:** `prettier --write "$FILE"`
- **Go:** `gofmt -w "$FILE"`
- **Ruby:** `rubocop -a "$FILE"`

## How It Works

**Memory docs** (`docs/`) are the source of truth. Claude reads them at the start of every session and updates them after every significant change.

**Graduated enforcement** — the verify script blocks `feat:` commits without doc updates, warns on `fix:` commits, and skips checks entirely for `chore:`/`refactor:` commits.

**Subagents** keep expensive work out of your main context window. `doc-scribe` (Haiku) handles doc updates for ~40% less cost than Sonnet. `code-reviewer` (Sonnet) catches bugs before they reach production.

**Session continuity** — `HANDOFF.md` is auto-saved before compaction and captures your git state so the next session can pick up where you left off.

## Slash Commands Available

After installing, these commands work in Claude Code:

- `/context-refresh` — Re-ground in docs at session start
- `/finish` — Full workflow: docs + tests + code review + commit message

## Customization

The template is intentionally minimal. Add your own:
- `.claude/rules/[stack]/` files for stack-specific patterns
- Additional subagents for specialized work (e.g., a `migration-writer`)
- Extra skills for your common workflows
