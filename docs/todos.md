# TODO & Roadmap

Prioritized list of next actions. Each item includes acceptance criteria, effort estimate, and value rating.

**Effort:** S (< 1 day), M (1-2 days), L (3-5 days), XL (1-2 weeks)
**Value:** Low, Medium, High, Critical
**Priority:** P0 (blocker/this week), P1 (next sprint), P2 (next month), P3 (parked)

<!--
PRIORITY GUIDE:
P0 — Blocking launch or a teammate. Do this now.
P1 — High value, planned for next sprint. Do this soon.
P2 — Good idea, not urgent. Schedule it.
P3 — Parked. Revisit when circumstances change.

EXAMPLE ENTRIES — copy and adapt:

### T-01: Add rate limiting to API `P0` `backend`
| Effort | Value | Priority |
|--------|-------|----------|
| S | Critical | P0 |

**Why:** Without rate limiting, a single client can exhaust the server.

**Acceptance Criteria:**
- [ ] 100 req/min limit per IP on all /api/* routes
- [ ] Returns 429 with Retry-After header when exceeded
- [ ] Limit configurable via env var RATE_LIMIT_RPM

**Files:** `src/middleware/rate-limit.js`

---

### T-02: Add pagination to GET /tasks `P1` `backend`
| Effort | Value | Priority |
|--------|-------|----------|
| S | High | P1 |

**Why:** Response grows unbounded as tasks accumulate.

**Acceptance Criteria:**
- [ ] Accepts ?page=N&limit=N query params
- [ ] Returns { data, total, page, pages } envelope
- [ ] Default limit: 20, max: 100

**Files:** `src/routes/tasks.js`
-->

---

## 🔴 P0 — Do This Week

### T-01: [First Task Name] `scope`

| Effort | Value | Priority |
|--------|-------|----------|
| M | High | P0 |

**Why:** [One sentence explaining the urgency.]

**Acceptance Criteria:**
- [ ] [Specific, verifiable outcome]
- [ ] [Specific, verifiable outcome]
- [ ] [Specific, verifiable outcome]

**Files:** `[file1]`, `[file2]`

---

## 🟡 P1 — Next Sprint

### T-02: [Second Task Name] `scope`

| Effort | Value | Priority |
|--------|-------|----------|
| S | Medium | P1 |

**Why:** [One sentence.]

**Acceptance Criteria:**
- [ ] [Outcome]

---

## 🟢 P2 — Next Month

### T-03: [Future Task] `scope`

| Effort | Value | Priority |
|--------|-------|----------|
| L | Low | P2 |

**Why:** [One sentence.]

---

## ⬜ P3 — Parked

Tasks to tackle when circumstances change (pre-launch, team growth, etc.).

### T-04: Add Authentication `all`

| Effort | Value | Priority |
|--------|-------|----------|
| L | Critical | P3 |

**Why:** No auth — unsafe for public deployment. Parked until launch prep.

---

## 📋 Recently Completed

<details>
<summary>Click to expand</summary>

- ✅ **[Task name]** - [Date] — [Brief description of what was done]

</details>

---

## 💡 Ideas (Not Prioritized Yet)

- [Idea 1]
- [Idea 2]
- [Idea 3]
