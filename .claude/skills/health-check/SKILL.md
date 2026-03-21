---
name: health-check
description: Weekly drift-detection scan for Claude Code setup — reports only, no changes
---

Run a quick drift-detection scan on the Claude Code setup for this repo. Do not make changes — report only. Keep this fast.

**Checks:**

1. **Stale references**: Scan CLAUDE.md, .claude/rules/, and any agent/skill definitions for file paths, command names, or config keys that no longer exist in the repo. List anything broken.
2. **Instruction vs. enforcement gap**: For each quality rule in CLAUDE.md or .claude/rules/ (e.g. "run tests before committing"), check whether it's enforced by a hook, CI step, or script. Flag rules that rely purely on the LLM following instructions.
3. **Unused config**: Check .claude/ for agents, skills, commands, or rules that don't match current workflow patterns. Flag candidates for removal.
4. **Tooling drift**: Compare lint/format/typecheck/test commands referenced in Claude Code config against what's actually in package.json / pyproject.toml / Makefile. Flag mismatches.
5. **MCP config**: If .mcp.json exists, verify the servers listed are still relevant. Flag any that look stale.
6. **Complexity creep**: Count total custom rules, agents, skills, and commands. Flag anything added since the last check and whether it's earning its keep.

**Output:** For each check, report one of:

- ✅ Healthy — [one line]
- ⚠️ Drifted — [what and suggested fix]
- ❌ Broken — [what's wrong and what to do]

End with: "N healthy, N drifted, N broken — [no action needed / cleanup pass / needs attention]"

If you spot something that needs deeper analysis, suggest running /improve.
