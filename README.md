# Claude Code Workflow Template

A portable workflow system for Claude Code projects. Provides persistent project docs, automated doc enforcement, code review, and session continuity.

## What's Included

```
CLAUDE.md                    ← Claude's instructions (auto-loaded)

docs/
  context.md                 ← What this project is (tech stack, key numbers)
  decisions.md               ← Why things are the way they are (ADRs)
  dev.md                     ← How to set up and run
  todos.md                   ← What to work on next (prioritized roadmap)

.claude/
  settings.json              ← Hooks (auto-format, block .env edits, save HANDOFF)
  settings.local.example.json ← Template for personal local overrides (gitignored)
  hooks/
    save-handoff.sh          ← Captures git state before compaction
  agents/
    doc-scribe.md            ← Haiku agent for updating docs (cost-effective)
    test-runner.md           ← Haiku agent for running tests (read-only)
    code-reviewer.md         ← Sonnet agent for reviewing diffs
  skills/
    finish/SKILL.md          ← /finish — end-of-task workflow
    context-refresh/SKILL.md ← /context-refresh — session start workflow
    delegate/SKILL.md        ← /delegate — when/how to use agents
    update-memory-docs/SKILL.md ← Quick doc update patterns
    health-check/SKILL.md    ← /health-check — weekly drift detection
    improve/SKILL.md         ← /improve — monthly analysis and proposals
    audit/SKILL.md           ← /audit — full operating model review
    template-update/SKILL.md ← /template-update — check for upstream template changes
    add-api-endpoint/SKILL.md ← Example: endpoint addition workflow (replace for your stack)
    debug-test-failure/SKILL.md ← Example: pytest debugging workflow (replace for your stack)
  rules/
    common-pitfalls.md       ← Anti-patterns and how to avoid them
    model-assignments.md     ← Agent model assignments (single source of truth)

scripts/
  verify-memory-and-checks.sh  ← Pre-push hook: enforce docs + run tests

.env.example                 ← Template for required environment variables
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

Edit `.claude/settings.json` — the PostToolUse hook auto-formats Python with `black`.
Change to your formatter:
- **JS/TS:** `prettier --write "$FILE"`
- **Go:** `gofmt -w "$FILE"`
- **Ruby:** `rubocop -a "$FILE"`

> **Note:** Auto-formatting hooks run on every edit, which costs context tokens (each file modification triggers a system-reminder). If you notice high token usage, consider disabling the hook and running your formatter manually between sessions.

---

## How It Works

**Project docs** (`docs/`) are the source of truth. Claude reads them at the start of every session and updates them after every significant change.

**Graduated enforcement** — the verify script blocks `feat:` commits without doc updates, warns on `fix:` and `refactor:` commits (but does not block), and skips checks entirely for `chore:`/`test:`/`ci:` commits.

**Agents** keep expensive work out of your main context window. `doc-scribe` (Haiku) handles doc updates cheaply. `code-reviewer` (Sonnet) catches bugs before they reach production. Both use `memory: project` to accumulate knowledge across sessions, and `effort` levels are tuned to match task complexity.

**Session continuity** — `HANDOFF.md` is auto-saved before compaction and captures your git state so the next session can pick up where you left off.

---

## Skills (Slash Commands)

After installing, these commands work in Claude Code:

| Command | What it does |
|---------|-------------|
| `/context-refresh` | Re-reads all `docs/` files and produces a structured project summary. Use at session start. |
| `/finish` | Full end-of-task workflow: update docs → run verify script → delegate to code-reviewer → suggest conventional commit message. |
| `/health-check` | Weekly drift-detection scan — stale references, unenforced rules, unused config, tooling mismatches. |
| `/improve` | Monthly deep analysis — work patterns, new capabilities, improvement proposals, upstream suggestions. |
| `/audit` | Full operating model review — evaluates whether your agent/skill/rule setup fits your repo. |
| `/template-update` | Checks if your template files are out of date with the upstream workflow template. Reports only. |

Skill definitions live in `.claude/skills/` — edit them to customize the workflow for your project.

---

## Example: What a Populated `docs/context.md` Looks Like

Below is a before/after for a toy Node.js task API. The `[PLACEHOLDER]` template on the left becomes the real project context on the right.

**Before (template):**
```markdown
**[Project Name]** — [One sentence description]

### Tech Stack
- **Backend**: [e.g., Python FastAPI + PostgreSQL]
- **Frontend**: [e.g., Next.js 15 + TypeScript]

## Key Numbers
- [N] API endpoints
- [N] database tables
```

**After (populated):**
```markdown
**TaskFlow** — A lightweight REST API for team task management,
built for small teams that don't need full project management overhead.

### Tech Stack
- **Backend**: Node.js 20 + Express 4 + SQLite
- **Auth**: JWT (jsonwebtoken)
- **Testing**: Jest + Supertest
- **Infrastructure**: Railway (hosting), GitHub Actions (CI)

## Key Numbers
- 12 API endpoints (tasks: 5, users: 4, teams: 3)
- 3 database tables (tasks, users, team_memberships)
- 47 unit tests (82% coverage)
```

The populated version gives Claude exactly the context it needs to work accurately without re-reading source files every session.

---

## Keeping Your Setup Healthy

This template includes three commands for maintaining and improving your Claude Code configuration:

- **`/health-check`** — Run weekly. Fast scan for stale references, unenforced rules, unused config, and tooling drift. Takes a few minutes.
- **`/improve`** — Run monthly or after major changes. Analyzes your git history and work patterns, researches new Claude Code features and tooling updates, proposes improvements, and flags anything worth suggesting back to this template.
- **`/audit`** — Run on first setup or quarterly. Full operating model review — evaluates whether your current agent/skill/rule setup is the right fit for your repo.

The cycle: `/health-check` catches drift, `/improve` finds opportunities, `/audit` reassesses the whole model when needed. Improvements that generalize get suggested back to this template via GitHub issues.

---

## Updating from the Template

If your project was created from this template, you can pull in future updates.

### Check for updates

Run `/template-update` in Claude Code. It will compare your local template files against the upstream repo and report what's changed, what's new, and what to do.

### First time: add the template remote

```bash
git remote add template https://github.com/nwakefield-ds/claude-workflow-template.git
```

### Pull updates

```bash
git fetch template
git merge template/main --allow-unrelated-histories
```

Resolve any conflicts (your project-specific changes in `docs/`, `CLAUDE.md`, etc. take priority), then commit.

> **Tip:** Template files you haven't customized (agents, skills, scripts) will merge cleanly. Files you've edited (like `docs/context.md`) may conflict — just keep your version.

---

## Customization

The template is intentionally minimal. Add your own:
- `.claude/rules/` files for stack-specific patterns
- Additional agents in `.claude/agents/` for specialized work (e.g., a `migration-writer`)
- Extra skills in `.claude/skills/` for your common workflows

The skills `add-api-endpoint` and `debug-test-failure` are included as examples — replace them with workflows that match your stack.

Model assignments for agents are centralized in `.claude/rules/model-assignments.md`.
