#!/usr/bin/env bash
# Installs git hooks for this repo. Run once after cloning.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

if [ ! -d "$HOOKS_DIR" ]; then
  echo "No .git/hooks directory found — are you in a git repo?"
  exit 1
fi

# ── pre-commit: lint docs/todos.md when staged ────────────────────────────────
cat > "$HOOKS_DIR/pre-commit" <<'HOOK'
#!/usr/bin/env bash

if git diff --cached --name-only | grep -q "^docs/todos.md$"; then
  echo "Linting docs/todos.md..."
  ./scripts/lint-todo.sh
  if [ $? -ne 0 ]; then
    echo "docs/todos.md lint failed. Fix errors before committing."
    exit 1
  fi
fi
HOOK

chmod +x "$HOOKS_DIR/pre-commit"
echo "✓ pre-commit hook installed"

echo ""
echo "All hooks installed in $HOOKS_DIR"
