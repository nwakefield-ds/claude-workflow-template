# TODO

<!--
  Format rules (enforced by scripts/lint-todo.sh):
  - Each entry: ### T-XX: Title `slug` followed by metadata line
  - Metadata line: priority | effort | Status: status | Owner: owner
  - Then a deliverables checklist (- [ ] or - [x] items)
  - Then a Files: line listing relevant paths
  - Spec link points to docs/plan/T-XX-slug.md for full context
  - Valid priorities: P0, P1, P2, P3
  - Valid efforts: XS, S, M, L, XL
  - Valid statuses: open, in-progress, blocked, done
  - Agents: read this file at session start. Pick tasks marked open or in-progress.
    Update status and check off deliverables as you complete them.
    Do NOT delete entries — mark done when finished.
-->

## Active

<!-- open and in-progress tasks go here -->

### T-01: Configure project test command `test-setup`
P1 | XS | Status: open | Owner: unassigned
Spec: docs/plan/T-01-test-setup.md
- [ ] Replace placeholder test command in CLAUDE.md with real command
- [ ] Verify test command runs successfully
Files: `CLAUDE.md`, `scripts/verify-memory-and-checks.sh`

## Blocked

<!-- blocked tasks go here — include reason in spec -->

## Done

<!-- completed tasks moved here for history, pruned monthly -->
