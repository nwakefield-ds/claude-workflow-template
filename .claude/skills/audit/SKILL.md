---
name: audit
description: Full operating model audit — evaluates whether current agent/skill/rule setup fits the repo
---

Audit the current setup and propose the smallest coherent operating model that gives us high confidence and high code quality. Do not implement changes yet.

We want to default to simplicity — single-agent mode for most work, escalating to subagents or agent teams only when clearly justified. We want quality enforced by tooling, not just instructions. We want minimal config that actually gets used. We want config that stays accurate over time, agents and skills that reflect actual work patterns, continuous improvement, and feeding learnings back to the shared template.

Tell us what's wrong today, not what an ideal setup looks like in theory.

## Audit scope (in priority order)

1. CLAUDE.md and any nested CLAUDE.md files
2. .claude/ directory (rules, settings, agents, skills, commands)
3. .mcp.json and MCP-related config
4. Build tooling: package.json / pyproject.toml / Makefile / scripts
5. CI config (e.g. GitHub Actions)
6. Lint / format / typecheck / test commands
7. Docs on engineering workflow, contribution standards, or release process

## Produce these sections only where justified by evidence. If a section isn't warranted, write "Not needed — [reason]" and move on.

1. **Current-state audit** — What exists, what's used vs. merely present, what's missing. Quote file paths and config keys.
2. **Built-ins vs. custom config** — Where Claude Code built-ins are sufficient and where they aren't. If unsure whether a capability exists, say so rather than speculating.
3. **Gaps and risks** — Instruction-only rules not enforced by tooling, coordination gaps, maintenance complexity not paying for itself, config drifted from repo state.
4. **Recommended operating model** — Default mode and escalation triggers based on evidence: repo areas touched, coupling, parallelism needs, context pressure, validation complexity. If subagents or agent teams aren't justified, say so and skip routing details.
5. **Proposed changes** — File path, purpose, why it belongs there, whether needed now or later. Draft snippets for the 2–3 most important files only.
6. **Recurring introspection** — Confirm /health-check and /improve commands are present and appropriate. Recommend cadence. Define what "healthy" vs. "drifted" means for this repo.
7. **Rollout plan** — Minimum viable now, next improvements, optional later.
8. **Final recommendation** — One of: "Keep it simple — single-agent with better guardrails" / "Add a few specialists — [which and why]" / "Use agent teams for [specific task shape] only"

## Constraints

Read first, propose second. Base on evidence, flag inferences. If something is inaccessible, say so. If a referenced capability doesn't exist, say so. Prefer deleting config over adding. Be honest about tradeoffs.
