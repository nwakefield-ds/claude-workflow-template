# Development Guide

How to set up, run, and troubleshoot this project.

---

## Prerequisites

- [Runtime/language version, e.g., Python 3.11+, Node 20+]
- [Database, e.g., PostgreSQL 15+]
- [Other tools, e.g., Docker, Redis]

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

# 5. Verify
./scripts/verify-memory-and-checks.sh
```

---

## Running Locally

### Backend (Port [N])
```bash
[start command, e.g., uvicorn api:app --reload]
```

### Frontend (Port [N])
```bash
[start command, e.g., npm run dev]
```

---

## Testing

```bash
# All tests
./scripts/verify-memory-and-checks.sh

# Backend only
[e.g., pytest backend/tests/ -v]

# Frontend only
[e.g., npm test -- --watchAll=false]

# E2E
[e.g., npx playwright test]
```

---

## Common Commands

```bash
# Format code
[e.g., black backend/ && prettier --write frontend/src/]

# Lint
[e.g., ruff check backend/ && npm run lint]

# Database migrations
[e.g., alembic upgrade head]

# Seed data
[e.g., python scripts/seed.py]
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
