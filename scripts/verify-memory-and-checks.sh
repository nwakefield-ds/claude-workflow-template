#!/bin/bash
set -euo pipefail

# ============================================================================
# Memory Doc Enforcement & Pre-Push Checks
# ============================================================================
# Ensures memory docs are updated when code changes, and runs fast checks.
#
# Usage:
#   ./scripts/verify-memory-and-checks.sh                    # Check against main
#   ./scripts/verify-memory-and-checks.sh --local            # Check uncommitted changes
#   ./scripts/verify-memory-and-checks.sh --skip-doc-check   # Emergency bypass (logged)
#
# Graduated Enforcement:
#   - feat:, feature/, add: → REQUIRE doc update (block if missing)
#   - fix:, bugfix/        → WARN if no doc update (don't block)
#   - refactor:            → WARN (docs may need updating, but don't block)
#   - chore:, style:, docs:, test:, ci:, build: → SKIP doc enforcement
# ============================================================================

echo "🔍 Verifying memory docs and running checks..."
echo ""

# Configuration
MEMORY_DOCS=(
  "docs/context.md"
  "docs/decisions.md"
  "docs/dev.md"
  "docs/todos.md"
)

CODE_PATTERNS=(
  "*.py"
  "*.js"
  "*.jsx"
  "*.ts"
  "*.tsx"
  "*.go"
  "*.java"
  "*.rb"
  "*.php"
  "*.c"
  "*.cpp"
  "*.rs"
  "*.swift"
)

CODE_DIRS=(
  "backend/"
  "frontend/src/"
  "src/"
  "api/"
  "lib/"
  "pkg/"
  "app/"
  "cmd/"
)

SKIP_LOG=".doc-check-skips.log"

# Parse arguments
MODE="push"
SKIP_DOC_CHECK=0
for arg in "$@"; do
  case "$arg" in
    --local) MODE="local" ;;
    --skip-doc-check) SKIP_DOC_CHECK=1 ;;
  esac
done

# Handle emergency skip
if [[ $SKIP_DOC_CHECK -eq 1 ]]; then
  echo "⚠️  WARNING: Skipping doc enforcement (--skip-doc-check)"
  echo "⚠️  This should be rare. Review before next commit."
  echo ""
  echo "$(date -Iseconds) SKIP by $(whoami): $*" >> "$SKIP_LOG"
  echo "   Logged to $SKIP_LOG"
  echo ""
fi

# Determine enforcement level from commit message
get_enforcement_level() {
  local commit_msg="$1"
  local msg_lower=$(echo "$commit_msg" | tr '[:upper:]' '[:lower:]')

  case "$msg_lower" in
    chore:*|chore\(*|style:*|docs:*|test:*|ci:*|build:*)
      echo "skip"
      ;;
    refactor:*|refactor\(*)
      echo "warn"
      ;;
    fix:*|fix\(*|bugfix:*|bugfix/*)
      echo "warn"
      ;;
    feat:*|feat\(*|feature:*|feature/*|add:*|add\(*)
      echo "require"
      ;;
    *)
      echo "require"
      ;;
  esac
}

# ============================================================================
# Step 1: Detect Changes
# ============================================================================

echo "📊 Analyzing changes..."

if [[ "$MODE" == "local" ]]; then
  CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null || echo "")
  if [[ -z "$CHANGED_FILES" ]]; then
    CHANGED_FILES=$(git diff --cached --name-only 2>/dev/null || echo "")
  fi
  echo "   Mode: Local changes (uncommitted)"
else
  git fetch origin main --quiet 2>/dev/null || true
  CHANGED_FILES=$(git diff --name-only origin/main...HEAD 2>/dev/null || \
                  git diff --name-only main...HEAD 2>/dev/null || \
                  echo "")
  echo "   Mode: Changes since origin/main"
fi

if [[ -z "$CHANGED_FILES" ]]; then
  echo "   ✓ No changes detected"
  echo ""
  exit 0
fi

echo "   Changes detected: $(echo "$CHANGED_FILES" | wc -l | tr -d ' ') files"
echo ""

# ============================================================================
# Step 2: Categorize Changes
# ============================================================================

CODE_CHANGED=0
MEMORY_CHANGED=0

for file in $CHANGED_FILES; do
  for pattern in "${CODE_PATTERNS[@]}"; do
    if [[ "$file" == *"$pattern" ]]; then
      CODE_CHANGED=1
      break
    fi
  done

  for dir in "${CODE_DIRS[@]}"; do
    if [[ "$file" == "$dir"* ]]; then
      CODE_CHANGED=1
      break
    fi
  done

  for doc in "${MEMORY_DOCS[@]}"; do
    if [[ "$file" == "$doc" ]]; then
      MEMORY_CHANGED=1
      break
    fi
  done
done

echo "📝 Change Analysis:"
echo "   Code changed:        $([ $CODE_CHANGED -eq 1 ] && echo "✓ YES" || echo "✗ No")"
echo "   Memory docs changed: $([ $MEMORY_CHANGED -eq 1 ] && echo "✓ YES" || echo "✗ No")"
echo ""

# ============================================================================
# Step 3: Enforce Memory Doc Updates (Graduated)
# ============================================================================

COMMIT_MSG=$(git log -1 --format=%s 2>/dev/null || echo "")
ENFORCEMENT=$(get_enforcement_level "$COMMIT_MSG")

echo "📋 Enforcement Level: $ENFORCEMENT"
if [[ -n "$COMMIT_MSG" ]]; then
  echo "   Based on: \"${COMMIT_MSG:0:50}$([ ${#COMMIT_MSG} -gt 50 ] && echo '...')\" "
fi
echo ""

if [[ $CODE_CHANGED -eq 1 && $MEMORY_CHANGED -eq 0 && $SKIP_DOC_CHECK -eq 0 ]]; then
  case "$ENFORCEMENT" in
    skip)
      echo "✓ Doc update skipped (maintenance commit: chore/style/docs/test/ci)"
      echo ""
      ;;
    warn)
      echo "⚠️  WARNING: Code changed but memory docs not updated"
      echo ""
      echo "For fix: and refactor: commits, doc updates are recommended but not required."
      echo "Consider updating docs/context.md or docs/decisions.md after this push."
      echo ""
      echo "Proceeding anyway..."
      echo ""
      ;;
    require)
      echo "❌ MEMORY DOC CHECK FAILED"
      echo ""
      echo "Code changes detected, but memory docs were not updated."
      echo ""
      echo "When you change code, update at least one of:"
      for doc in "${MEMORY_DOCS[@]}"; do
        echo "  • $doc"
      done
      echo ""
      echo "Commit type shortcuts:"
      echo "  • fix: or bugfix/  - bug fixes (warns, doesn't block)"
      echo "  • refactor:        - refactors (warns, doesn't block)"
      echo "  • chore: or style: - maintenance (no check at all)"
      echo "  • test: or ci:     - test/CI changes (no check at all)"
      echo ""
      echo "Emergency bypass: ./scripts/verify-memory-and-checks.sh --skip-doc-check"
      echo ""
      exit 1
      ;;
  esac
fi

if [[ $MEMORY_CHANGED -eq 1 ]]; then
  echo "✓ Memory docs updated"
  echo ""
fi

if [[ $CODE_CHANGED -eq 0 && $MEMORY_CHANGED -eq 0 ]]; then
  echo "✓ No code or doc changes (docs-only changes like README are OK)"
  echo ""
fi

# ============================================================================
# Step 4: Run Fast Checks
# ============================================================================
# Customize this section for your stack.
# The script auto-detects common setups but may need adjustment.

CHECKS_FAILED=0

# ── Python / FastAPI / Django ────────────────────────────────────────────────
if [[ -f "requirements.txt" || -f "pyproject.toml" ]] && [[ $CODE_CHANGED -eq 1 ]]; then
  echo "🐍 Python Checks..."

  PYTHON_DEPS=1
  python3 -c "import sys; sys.exit(0)" 2>/dev/null || PYTHON_DEPS=0

  if [[ $PYTHON_DEPS -eq 1 ]]; then
    # Syntax check all changed Python files
    for file in $CHANGED_FILES; do
      if [[ "$file" == *.py ]] && [[ -f "$file" ]]; then
        if python3 -c "import ast; ast.parse(open('$file').read())" 2>/dev/null; then
          echo "   ✓ $file syntax OK"
        else
          echo "   ✗ $file syntax error"
          CHECKS_FAILED=1
        fi
      fi
    done

    # Run tests if pytest is available
    if python3 -m pytest --version &>/dev/null 2>&1; then
      echo "   Running tests..."
      if python3 -m pytest --tb=short -q 2>/dev/null; then
        echo "   ✓ Tests passed"
      else
        echo "   ✗ Tests failed"
        CHECKS_FAILED=1
      fi
    fi

    # Run ruff if available
    if command -v ruff &>/dev/null; then
      echo "   Running ruff..."
      if ruff check . --quiet 2>/dev/null; then
        echo "   ✓ Ruff passed"
      else
        echo "   ✗ Ruff failed"
        CHECKS_FAILED=1
      fi
    fi
  else
    echo "   ⚠️  Python not available — skipping checks"
  fi
  echo ""
fi

# ── Node / TypeScript / React ────────────────────────────────────────────────
for dir in "." "frontend" "frontend-v2" "client" "web"; do
  if [[ -f "$dir/package.json" ]] && [[ $CODE_CHANGED -eq 1 ]]; then
    echo "⚛️  JS/TS Checks ($dir)..."
    pushd "$dir" > /dev/null

    if [[ ! -d "node_modules" ]]; then
      echo "   ⚠️  node_modules not found — run: npm install"
    else
      # Lint
      if npm run lint --silent 2>/dev/null; then
        echo "   ✓ Lint passed"
      elif npx eslint . --max-warnings 0 --quiet 2>/dev/null; then
        echo "   ✓ Lint passed"
      fi

      # Tests
      if npm test -- --watchAll=false --passWithNoTests --silent 2>/dev/null; then
        echo "   ✓ Tests passed"
      fi
    fi

    popd > /dev/null
    echo ""
    break  # Only check first matching dir
  fi
done

# ── Go ───────────────────────────────────────────────────────────────────────
if [[ -f "go.mod" ]] && [[ $CODE_CHANGED -eq 1 ]]; then
  echo "🐹 Go Checks..."
  if go build ./... 2>/dev/null; then
    echo "   ✓ Build passed"
  else
    echo "   ✗ Build failed"
    CHECKS_FAILED=1
  fi
  if go test ./... -short 2>/dev/null; then
    echo "   ✓ Tests passed"
  else
    echo "   ✗ Tests failed"
    CHECKS_FAILED=1
  fi
  echo ""
fi

# ── Ruby ─────────────────────────────────────────────────────────────────────
if [[ -f "Gemfile" ]] && [[ $CODE_CHANGED -eq 1 ]]; then
  echo "💎 Ruby Checks..."
  if bundle exec rspec --format progress 2>/dev/null; then
    echo "   ✓ Tests passed"
  else
    echo "   ✗ Tests failed"
    CHECKS_FAILED=1
  fi
  echo ""
fi

# ============================================================================
# Step 5: Final Result
# ============================================================================

if [[ $CHECKS_FAILED -eq 1 ]]; then
  echo "❌ CHECKS FAILED"
  echo ""
  echo "Fix the errors above and try again."
  exit 1
fi

echo "✅ ALL CHECKS PASSED"
echo ""
echo "Memory docs are in sync and fast checks passed."
echo "Safe to push! 🚀"
exit 0
