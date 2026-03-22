# Claude Code Workflow Template

A self-improving workflow system for Claude Code projects. Provides project docs, automated enforcement, code review agents, session continuity, and built-in introspection that keeps your setup current as Claude Code evolves.

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
    doc-scribe.md            ← Haiku agent for updating docs (memory: project, effort: low)
    test-runner.md           ← Haiku agent for running tests (effort: low)
    code-reviewer.md         ← Sonnet agent for reviewing diffs (memory: project, effort: high, plan mode)
  skills/
    finish/SKILL.md          ← /finish — end-of-task workflow
    context-refresh/SKILL.md ← /context-refresh — session start workflow
    health-check/SKILL.md    ← /health-check — weekly drift detection
    improve/SKILL.md         ← /improve — monthly analysis and proposals
    audit/SKILL.md           ← /audit — full operating model review
    zero-base/SKILL.md       ← /zero-base — first-principles system re-evaluation
    template-update/SKILL.md ← /template-update — check for upstream template changes
    delegate/SKILL.md        ← /delegate — when/how to use agents
    update-memory-docs/SKILL.md ← Quick doc update patterns
    fix-issue/SKILL.md       ← /fix-issue — fix a GitHub issue end-to-end (uses $ARGUMENTS)
    debug-test-failure/SKILL.md ← Example: replace for your stack
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

> **Tip:** You can also run `/init` to generate a starter CLAUDE.md from your project structure, then layer the template's workflow rules on top.

### 3. Install the pre-push hook

```bash
chmod +x scripts/verify-memory-and-checks.sh
ln -s ../../scripts/verify-memory-and-checks.sh .git/hooks/pre-push
chmod +x .git/hooks/pre-push
```

### 4. Run the initial audit

```
/audit
```

This evaluates whether the default agent/skill/rule setup fits your repo and recommends adjustments.

### 5. Add stack-specific rules (optional)

Create `.claude/rules/backend.md` or `.claude/rules/frontend.md` with patterns for your stack:
- Error handling conventions
- Testing patterns
- Naming conventions
- Security rules

### 6. Adjust hooks for your language

Edit `.claude/settings.json` — the PostToolUse hook auto-formats Python with `black`.
Change to your formatter:
- **JS/TS:** `prettier --write "$FILE"`
- **Go:** `gofmt -w "$FILE"`
- **Ruby:** `rubocop -a "$FILE"`

> **Note:** Auto-formatting hooks run on every edit, which costs context tokens (each file modification triggers a system-reminder). If you notice high token usage, consider disabling the hook and running your formatter manually between sessions.

---

## How It Works

### Project docs as source of truth

`docs/` files are read at session start and updated after every significant change. Claude uses them to understand the project without re-reading source files every time.

### Graduated enforcement

The verify script blocks `feat:` commits without doc updates, warns on `fix:` and `refactor:` commits (but does not block), and skips checks entirely for `chore:`/`test:`/`ci:` commits. Rules are enforced at three levels:

- **Hook-enforced** (automatic): auto-format on save, `.env` edit blocking, HANDOFF.md save before compaction
- **Script-enforced** (manual): `verify-memory-and-checks.sh` — doc updates with code changes, lint, tests
- **Advisory** (LLM follows instructions): conventional commits, reading docs before coding, delegation patterns

### Cost-optimized agents

Agents keep expensive work out of your main context window:

| Agent | Model | Effort | Memory | Purpose |
|-------|-------|--------|--------|---------|
| `doc-scribe` | Haiku | Low | Project | Update docs cheaply |
| `test-runner` | Haiku | Low | — | Run tests, report results |
| `code-reviewer` | Sonnet | High | Project | Catch bugs and security issues (plan mode — can't edit code) |

### Session continuity

`HANDOFF.md` is auto-saved before compaction via a PreCompact hook, capturing git state so the next session picks up where you left off.

---

## Skills (Slash Commands)

| Command | What it does |
|---------|-------------|
| `/context-refresh` | Re-reads all `docs/` files and produces a structured project summary. Use at session start. |
| `/finish` | Full end-of-task workflow: update docs → run verify script → delegate to code-reviewer → suggest conventional commit message. |
| `/health-check` | Weekly drift-detection scan — stale references, unenforced rules, unused config, tooling mismatches. |
| `/improve` | Monthly deep analysis — work patterns, new capabilities, improvement proposals, upstream suggestions. |
| `/audit` | Full operating model review — evaluates whether your agent/skill/rule setup fits your repo. |
| `/template-update` | Checks if your template files are out of date with the upstream workflow template. Reports only. |
| `/fix-issue <number>` | Fix a GitHub issue end-to-end: fetch → search → implement → test → commit → PR. |
| `/zero-base` | First-principles re-evaluation — assumes nothing is sacred, proposes ideal architecture. |

Skill definitions live in `.claude/skills/` — edit them to customize the workflow for your project.

---

## Self-Improving Workflow

This template doesn't just configure Claude Code — it maintains and improves itself over time.

### The introspection cycle

```
Weekly:     /health-check  →  Catch config drift, stale references, tooling mismatches
Monthly:    /improve       →  Analyze work patterns, research new features, propose improvements
Quarterly:  /audit         →  Reassess the entire operating model
As needed:  /zero-base     →  First-principles re-evaluation — question everything
```

### How `/improve` works

Each month, `/improve` does four things:

1. **Reflects on the project** — analyzes git history, identifies recurring patterns, evaluates whether existing agents and skills are still earning their keep
2. **Researches what's new** — fetches the latest from [Claude Code best practices](https://code.claude.com/docs/en/best-practices) and [community recommendations](https://rosmur.github.io/claudecode-best-practices/), checks for new features and tooling updates
3. **Proposes improvements** — up to 5 changes ranked by impact, with effort estimates
4. **Feeds back to the template** — discoveries that would benefit all repos using this template get flagged for upstream contribution via GitHub issues

### How it stays current

The template evolves through two feedback loops:

- **Downstream → Upstream:** When `/improve` finds a gap that applies to all repos, it drafts a GitHub issue for this template. Other repos benefit when the fix is merged.
- **Upstream → Downstream:** Run `/template-update` to check if your copy is behind. It compares your local template files against the upstream repo and reports what's changed.

```
┌─────────────────┐     /template-update     ┌─────────────────┐
│  Your Project    │ ◄────────────────────── │  This Template   │
│                  │                          │                  │
│  /improve finds  │ ──── GitHub issue ────► │  Merged upstream │
│  a general fix   │                          │                  │
└─────────────────┘                          └─────────────────┘
```

---

## Example: What a Populated `docs/context.md` Looks Like

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

---

## Updating from the Template

If your project was created from this template, you can pull in future updates.

### Check for updates

Run `/template-update` in Claude Code. It compares your local template files against the upstream repo and reports what's changed, what's new, and what to do.

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

The skill `debug-test-failure` is included as an example — replace it with workflows that match your stack. The `/fix-issue` skill works with any repo that uses GitHub Issues.

Model assignments for agents are centralized in `.claude/rules/model-assignments.md`.
