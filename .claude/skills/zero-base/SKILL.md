---
name: zero-base
description: First-principles re-evaluation of the entire system — assumes nothing is sacred
disable-model-invocation: true
---

Do a zero-base re-evaluation of this entire system.

Assume no existing architectural decision is sacred. Using the current codebase, docs, behavior, and known constraints as evidence, determine whether this system would be designed the same way if we were starting today.

This is a first-principles systems analysis, not a code review.

## What to analyze

Read the full codebase — every file, every config, every doc. Then answer:

### 1. Problem definition
- What problem is this system supposed to solve?
- Who are the users and what do they actually need?
- Has the problem shifted since the system was designed?

### 2. Current architecture
- What architecture did we end up with?
- Map the actual dependency graph: what depends on what, what triggers what, what reads what.
- Where does complexity live? Is it in the right places?

### 3. What works
- Which parts are elegant and necessary?
- What would survive a rewrite unchanged?
- What patterns have proven their value through actual use (check git history for evidence)?

### 4. What doesn't work
- Which parts are legacy baggage, accidental complexity, or organizational scar tissue?
- What exists because of a constraint that no longer applies?
- What was over-engineered for a future that never arrived?
- What causes friction, confusion, or maintenance burden without proportional value?

### 5. Decision archaeology
- Which decisions were locally rational at the time but globally wrong in hindsight?
- What did we build because we could, not because we should?
- Where did we copy patterns from elsewhere without questioning whether they fit here?

### 6. The clean-sheet design
- If we rebuilt today with everything we know, what would the new design be?
- What would we keep, what would we cut, what would we add?
- What constraints have changed (new Claude Code features, new best practices, new understanding)?

### 7. The pragmatic path
- Would a rewrite, a partial replacement, or an incremental refactor create the most value?
- What is the cost of doing nothing?
- What is the risk of each path?

## Rules of engagement

- Be candid and opinionated.
- Do not protect prior decisions.
- Do not default to incrementalism unless it is actually the best answer.
- Call out the things we should never do this way again.
- Use evidence from the codebase and git history, not generic best practices.
- "It works" is not a sufficient defense. "It works and nothing simpler would" is.

## Output

End with three clear sections:

### Verdict
Would we build it differently today? Yes/No/Partially, with reasoning.

### Ideal architecture
The design if starting fresh, described concretely enough to implement.

### Pragmatic path
The most practical route from the current system to the ideal, with specific steps ordered by impact.
