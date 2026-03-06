# Architectural Decisions

Record of significant architectural choices, with context and rationale.

**Status tags:** `[ACTIVE]` | `[SUPERSEDED]` | `[EXPERIMENTAL]` | `[DEPRECATED]`

---

## Entry Format

```markdown
## [Date]: [Decision Title] [STATUS]

**Context:** What problem were we solving?

**Decision:** What did we choose?

**Rationale:** Why this approach? What alternatives were considered?

**Consequences:**
- ✅ What this makes easier
- ⚠️ What this makes harder or trades off

**Files:** Which files implement this decision?
```

---

<!--
EXAMPLE ENTRY — copy and adapt for your own decisions:

## 2024-01-15: Use SQLite instead of PostgreSQL [ACTIVE]

**Context:** We need persistent storage for tasks and users. The app is
single-tenant with low write volume (<100 writes/day in initial phase).

**Decision:** Use SQLite with a file at `data/app.db`.

**Rationale:**
- Zero infrastructure setup (no separate DB server to manage)
- Sufficient for single-tenant, low-write workload
- Easy to back up (just copy the file)
- Alternative considered: PostgreSQL — rejected because it adds ops overhead
  with no benefit at this scale

**Consequences:**
- ✅ Simpler local dev (no docker-compose needed)
- ✅ Easy backups via file copy
- ⚠️ Will need migration to Postgres if we go multi-tenant or high write volume

**Files:** `src/db/connection.js`, `src/db/schema.sql`, `data/app.db`
-->

## [Date]: [Your First Decision] [ACTIVE]

**Context:** [What triggered this decision?]

**Decision:** [What was chosen?]

**Rationale:**
- [Reason 1]
- [Reason 2]
- Alternative considered: [What else was evaluated and why rejected]

**Consequences:**
- ✅ [What this makes easier]
- ⚠️ [What this makes harder or trades off]

**Files:** `[file1]`, `[file2]`
