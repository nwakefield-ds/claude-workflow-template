# /migrate-todos

Convert an existing or free-form `docs/todos.md` to the structured T-XX format required by this repo's TODO system.

## When to use

- A project has just adopted this template and has existing todos in a non-standard format
- `./scripts/lint-todo.sh` reports errors on the current `docs/todos.md`
- The file has informal bullet lists, old-style headers, or mixed formats

## Steps

1. **Read the current state**
   ```
   Read docs/todos.md
   Run: bash scripts/lint-todo.sh docs/todos.md   (note all errors)
   ```

2. **Assign T-XX IDs**
   - Find the highest existing T-XX number (use `grep -oP 'T-\d+' docs/todos.md | sort -V | tail -1`)
   - Assign sequential IDs to all new entries, continuing from the current max
   - Preserve any entries that already have valid T-XX IDs

3. **Convert each entry to structured format**

   For each existing task, extract or infer:
   - **Title** — the task name (keep it short, under 60 chars)
   - **Slug** — a `kebab-case` identifier (2-4 words)
   - **Priority** — P0/P1/P2/P3 (map from urgency language: "blocker"→P0, "soon"→P1, "someday"→P3; default P1)
   - **Effort** — XS/S/M/L/XL (map from time estimates or size language; default M)
   - **Status** — open/in-progress/blocked/done (default open)
   - **Owner** — who owns it (default unassigned)
   - **Deliverables** — convert acceptance criteria or bullet points to `- [ ]` checklist items
   - **Files** — extract any file paths mentioned, or use `TBD`

   Write each entry in this exact format:
   ```
   ### T-XX: Title `slug`
   P1 | M | Status: open | Owner: unassigned
   Spec: docs/plan/T-XX-slug.md
   - [ ] deliverable 1
   - [ ] deliverable 2
   Files: `path/to/relevant/file`
   ```

4. **Place entries in the correct section**
   - `## Active` — open and in-progress tasks
   - `## Blocked` — blocked tasks
   - `## Done` — completed tasks

5. **Create spec files**
   For each entry, create `docs/plan/T-XX-slug.md` using the template at `docs/plan/TEMPLATE.md`.
   Fill in as much detail as exists in the original entry. It's OK to leave sections as placeholders.

6. **Validate**
   ```
   bash scripts/lint-todo.sh docs/todos.md
   ```
   Fix any errors reported before finishing.

## Handling edge cases

- **Duplicate tasks** — merge into one entry, combining deliverables
- **Vague tasks** — keep them; use a broad deliverable like `- [ ] investigate and implement`
- **Completed items** — place in `## Done` with `Status: done`, check off their deliverables
- **Ideas / unscoped items** — assign P3, effort XS, note "needs scoping" in the spec's Why section
- **Missing information** — use defaults and note `TBD` in the spec; don't block on perfect data

## What NOT to do

- Don't discard any existing information — everything should be preserved in the structured format or spec file
- Don't invent deliverables that weren't implied by the original entry
- Don't change priorities unless the original entry clearly indicates a different urgency
