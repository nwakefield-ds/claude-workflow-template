---
name: improve
description: Monthly deep analysis — reflects on work patterns, researches new capabilities, proposes improvements
---

Reflect on how this project actually works, research what's new, propose improvements, and flag anything worth suggesting back to the shared workflow template. Do not make changes — propose only.

## Part 1: Project reflection

**Project profile** — Characterize the project based on evidence: language(s), framework(s), architecture style, approximate size and complexity, primary domain. Note any changes in project shape since the last time this was run.

**Work pattern analysis** — Look at recent git history (last 4–6 weeks) to identify: most frequent change types, which repo areas are touched most often, whether changes tend to be isolated or cross-cutting, recurring multi-step workflows, and patterns in review feedback if visible.

**Agent and skill gap analysis** — Based on findings above, evaluate whether any of the following would provide concrete value. Require evidence from git history or repo structure — don't propose based on generic best practices alone.

- Specialist agents: Only propose for patterns that recur at least weekly and involve enough context that a focused agent outperforms a general prompt.
- Skills / commands: Look for multi-step workflows where steps are stable but details change each time.
- Hooks: Validation steps that should run automatically but aren't wired up.
- MCP integrations: External services that would reduce context-switching during common tasks.

For anything proposed, include: the recurring pattern it addresses (cite evidence), what it would do, expected quality or speed gain, and effort to build (trivial / small / medium).

**Existing agent/skill review** — For agents, skills, and commands that already exist, check: built for a workflow that's changed? Overlap with a Claude Code built-in? Could be consolidated? Under-scoped or over-scoped?

## Part 2: External research

Search the web for recent developments. Focus on what's actionable for this repo.

**Claude Code updates** — Search for new Claude Code features released in the last 30 days (docs.anthropic.com, changelog, GitHub). Note what each does, whether it replaces custom config, whether it enables new capabilities, and concrete next steps.

**Code quality tooling** — Identify the tools this repo uses from package.json / pyproject.toml / CI, then search for notable updates. Flag new versions with quality improvements, new rules or plugins for relevant bug categories, and deprecations.

**Workflow practices** — Search for recent posts or docs on Claude Code workflows, CLAUDE.md design, or AI-assisted code quality (last 60 days, primary sources only). Surface only practices that address a real gap in this repo, are concrete enough to implement, and come from credible sources.

## Part 3: Proposals

Based on Parts 1 and 2, propose up to 5 improvements ranked by impact. For each: what to change and where, which part surfaced it, what problem it solves, effort estimate, and whether to do it now or queue it. "No changes recommended" is a valid outcome.

## Part 4: Upstream template suggestions

This repo was set up from the shared workflow template at: https://github.com/nwakefield-ds/claude-workflow-template

Review the improvements from Part 3 and learnings from Parts 1–2. Flag discoveries that would benefit other repos using the same template.

An improvement belongs upstream if it meets at least two of: fixes a gap any repo using the template would have, reflects a new Claude Code capability, is a better default that generalizes, replaces something in the template, or is a pattern that proved valuable and isn't project-specific. Keep it local if it only makes sense for this project's language, framework, or domain.

For each upstream suggestion: what to change in the template, which template file is affected, and why it generalizes.

If there are suggestions, draft them as a GitHub issue body for https://github.com/nwakefield-ds/claude-workflow-template/issues with title format "Template improvement suggestions — [month] [year]". If nothing generalizes: "No upstream suggestions this cycle."

## Output format

**Project Profile:** 3–5 lines, note changes since last run.

**Work Patterns:** Top 3–5 recurring task types with frequency and areas.

**Agent/Skill Assessment** — for each candidate: 🛠️ Worth building / ⏳ Not yet / ➖ Not justified. For existing ones: ✅ Still earning its keep / 🔄 Needs update / 🗑️ Candidate for removal.

**What's New** — for each research area: 🆕 Worth adopting / 👀 Worth watching / ➖ Nothing notable.

**Top Improvements:** Numbered list of up to 5, or "Setup is current. No changes recommended."

**Upstream Suggestions:** List or "No upstream suggestions this cycle." Include draft issue body if applicable.
