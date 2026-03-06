# Development Guide

How to set up, run, and troubleshoot this project.

---

## Prerequisites

- [Runtime/language version, e.g., Python 3.11+, Node 20+]
- [Database, e.g., PostgreSQL 15+]
- [Other tools, e.g., Docker, Redis]

<!--
EXAMPLE (Node.js API):
- Node.js 20+
- npm 10+
- No external services required (uses SQLite)
-->

---

## Environment Variables

Copy `.env.example` to `.env` and fill in the required values:

```bash
cp .env.example .env
```

| Variable | Required | Description |
|----------|----------|-------------|
| `[VAR_NAME]` | Yes | [What it's for] |
| `[VAR_NAME]` | No | [What it's for, default value] |

<!--
EXAMPLE:
| Variable | Required | Description |
|----------|----------|-------------|
| `ANTHROPIC_API_KEY` | Yes | Claude API key — get from console.anthropic.com |
| `DATABASE_URL`      | No  | SQLite path (default: data/app.db) |
| `PORT`              | No  | Server port (default: 8000) |
| `NODE_ENV`          | No  | development / production (default: development) |
-->

---

## Setup

```bash
# 1. Clone
git clone [repo-url]
cd [project-name]

# 2. Environment
cp .env.example .env
# Edit .env and fill in required values

# 3. Install dependencies
[e.g., pip install -r requirements.txt]
[e.g., npm install]

# 4. Database setup
[e.g., python scripts/init_db.py]
[e.g., npm run db:migrate]

# 5. Verify
./scripts/verify-memory-and-checks.sh
```

<!--
EXAMPLE (Node.js API):
```bash
git clone https://github.com/you/taskflow.git
cd taskflow
cp .env.example .env          # Add your ANTHROPIC_API_KEY
npm install
npm run db:migrate            # Creates SQLite schema
./scripts/verify-memory-and-checks.sh
```
-->

---

## Running Locally

### Backend (Port [N])
```bash
[start command, e.g., uvicorn api:app --reload]
[e.g., npm run dev]
```

### Frontend (Port [N])
```bash
[start command, e.g., npm run dev]
```

<!--
EXAMPLE (Node.js API — single service):
```bash
npm run dev       # Starts on http://localhost:8000 with hot reload
npm start         # Production mode (no hot reload)
```
-->

---

## Testing

```bash
# All tests (with doc enforcement)
./scripts/verify-memory-and-checks.sh

# Backend only
[e.g., pytest backend/tests/ -v]
[e.g., npm test]

# Frontend only
[e.g., npm test -- --watchAll=false]

# E2E
[e.g., npx playwright test]

# Single test file
[e.g., pytest backend/tests/test_api.py -v]
[e.g., npm test -- --testPathPattern=tasks]
```

<!--
EXAMPLE (Node.js API):
```bash
./scripts/verify-memory-and-checks.sh   # Full check suite
npm test                                 # Jest unit + integration tests
npm test -- --testPathPattern=tasks      # Only task-related tests
npm run test:coverage                    # Generate coverage report
```
-->

---

## Common Commands

```bash
# Format code
[e.g., black backend/ && prettier --write frontend/src/]

# Lint
[e.g., ruff check backend/ && npm run lint]

# Database migrations
[e.g., alembic upgrade head]
[e.g., npm run db:migrate]

# Seed data
[e.g., python scripts/seed.py]
[e.g., npm run db:seed]
```

---

## Troubleshooting

### [Common Issue 1]
**Symptom:** [What the user sees]
**Cause:** [Why it happens]
**Fix:** [How to resolve]

### [Common Issue 2]
**Symptom:** [What the user sees]
**Fix:** [How to resolve]

<!--
EXAMPLE:
### "Cannot find module" on startup
**Symptom:** `Error: Cannot find module './db/connection'`
**Cause:** Dependencies not installed or wrong Node version
**Fix:** Run `npm install` and verify `node --version` is 20+

### Tests fail with "SQLITE_CANTOPEN"
**Symptom:** Jest tests fail on first run with database open error
**Cause:** `data/` directory doesn't exist yet
**Fix:** Run `npm run db:migrate` to create the directory and schema
-->

---

## Recovery Procedures

### Undo last commit (not pushed)
```bash
git reset --soft HEAD~1
```

### Revert pushed commit
```bash
git revert HEAD
git push origin main
```

### Bisect to find breaking commit
```bash
git bisect start
git bisect bad          # current state is broken
git bisect good [hash]  # known good commit
# test at each step, mark good/bad until root cause found
```

---

## CI/CD

- **CI:** [e.g., GitHub Actions — .github/workflows/ci.yml]
- **Triggers:** [e.g., push to main, PRs]
- **Steps:** [e.g., lint → test → build → deploy]
- **Secrets needed:** [e.g., ANTHROPIC_API_KEY, DATABASE_URL]

<!--
EXAMPLE:
- **CI:** GitHub Actions — `.github/workflows/ci.yml`
- **Triggers:** Every push and PR to `main`
- **Steps:** npm install → lint → test → (on main only) deploy to Railway
- **Secrets needed:** `ANTHROPIC_API_KEY`, `RAILWAY_TOKEN`
-->
