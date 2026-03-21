---
name: template-update
description: Check if local template files are out of date with the upstream workflow template
---

Check whether this project's Claude Code template files are up to date with the upstream workflow template. Do not make changes — report only.

## Steps

### 1. Ensure the template remote exists

Run `git remote -v` and look for a remote named `template` pointing to:
`https://github.com/nwakefield-ds/claude-workflow-template`

If it doesn't exist, add it:
```bash
git remote add template https://github.com/nwakefield-ds/claude-workflow-template.git
```

### 2. Fetch the latest template

```bash
git fetch template main --quiet
```

### 3. Compare template files

Compare the following paths between the local repo and `template/main`. For each file, run `git diff HEAD template/main -- <path>` and categorize the result.

**Template-managed files** (check all of these):
- `.claude/agents/*.md`
- `.claude/skills/*/SKILL.md`
- `.claude/rules/*.md`
- `.claude/settings.json`
- `.claude/hooks/*.sh`
- `scripts/verify-memory-and-checks.sh`

**Project-owned files** (skip these — they're meant to diverge):
- `CLAUDE.md`
- `docs/*`
- `.env.example`
- `README.md`
- `.gitignore`

### 4. Check for new upstream files

Run `git diff --name-status HEAD template/main --diff-filter=A` to find files that exist upstream but not locally. These may be new skills, agents, or rules added to the template since this project was created.

### 5. Check for removed upstream files

Run `git diff --name-status HEAD template/main --diff-filter=D` scoped to `.claude/` and `scripts/` to find files that were removed upstream (deprecated features).

### 6. Report

**Output format:**

```
Template Update Check
Source: https://github.com/nwakefield-ds/claude-workflow-template

## Status: [Up to date | N files behind | N files behind, N new available]

### Updated upstream (your copy is outdated)
- `path/to/file` — [brief summary of what changed]

### New in template (not in your project yet)
- `path/to/file` — [what it does]

### Removed from template (may want to delete locally)
- `path/to/file` — [why it was removed, if visible from commit message]

### Locally customized (intentional divergence)
- `path/to/file` — [has local changes, skipping]

## Recommended action
[One of:]
- "You're up to date. No action needed."
- "Run: git merge template/main --allow-unrelated-histories"
- "N files have upstream updates. Review the changes above, then run: git merge template/main --allow-unrelated-histories"
```

If the diff is large, summarize the key changes rather than showing full diffs. Focus on what the user needs to decide: merge everything, cherry-pick specific files, or skip this cycle.
