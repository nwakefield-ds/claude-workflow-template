#!/usr/bin/env bash
# Self-test for the template's enforcement layer.
#
# The linter and hooks are what make CLAUDE.md's "hook-enforced" and
# "script-enforced" claims true. This script feeds them known-bad inputs and
# fails unless they reject them — enforcement that is never exercised decays
# silently (all three mechanisms were fail-open for months before this existed).
#
# Run directly, via /health-check, or in CI. Expects the template's stock
# .claude/settings.json hooks to be present.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

PASS=0; FAIL=0
ok()  { echo "  ✓ $1"; PASS=$((PASS+1)); }
bad() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null || { echo "python3 required"; exit 1; }

echo "🔬 Enforcement self-test"
echo ""

# ── 1. TODO linter must reject known-bad input and accept the real file ──────
echo "1. TODO linter"
if PROJECT_SIZE=normal bash scripts/lint-todo.sh scripts/fixtures/malformed-todos.md >/dev/null 2>&1; then
  bad "lint-todo.sh passed the malformed fixture (linter is a no-op)"
else
  ok "lint-todo.sh rejects the malformed fixture"
fi
if [[ -f docs/todos.md ]]; then
  if PROJECT_SIZE=normal bash scripts/lint-todo.sh docs/todos.md >/dev/null 2>&1; then
    ok "lint-todo.sh accepts the real docs/todos.md"
  else
    bad "lint-todo.sh rejects the real docs/todos.md (fix its format or the linter)"
  fi
fi
echo ""

# ── 2. PreToolUse hooks must block .env edits under the CURRENT contract ─────
# Current contract: hook JSON on stdin with tool input nested under
# "tool_input"; exit code 2 blocks the tool call.
run_pretool_hooks() {
  # $1 = payload JSON, $2 = tool name (only hooks whose matcher covers it run)
  local payload="$1" tool="$2" blocked=0 b64 cmd rc
  while IFS= read -r b64; do
    cmd=$(echo "$b64" | base64 --decode)
    echo "$payload" | bash -c "$cmd" >/dev/null 2>&1
    rc=$?
    [[ $rc -eq 2 ]] && blocked=1
  done < <(python3 - "$tool" <<'INNER'
import json, base64, re, sys
tool = sys.argv[1]
s = json.load(open('.claude/settings.json'))
for m in s.get('hooks', {}).get('PreToolUse', []):
    matcher = m.get('matcher', '')
    if matcher and not re.fullmatch(matcher, tool):
        continue
    for h in m.get('hooks', []):
        if h.get('type') == 'command':
            print(base64.b64encode(h['command'].encode()).decode())
INNER
)
  echo "$blocked"
}

echo "2. .env edit blocking"
payload() { echo '{"tool_name":"Edit","tool_input":{"file_path":"'"$REPO_ROOT"'/'"$1"'","old_string":"a","new_string":"b"}}'; }

if [[ "$(run_pretool_hooks "$(payload .env)" Edit)" == "1" ]]; then
  ok "a PreToolUse hook blocks .env edits (exit 2)"
else
  bad ".env edit was NOT blocked by any PreToolUse hook"
fi
if [[ "$(run_pretool_hooks "$(payload .env.local)" Edit)" == "1" ]]; then
  ok ".env.local edits are blocked"
else
  bad ".env.local edit was NOT blocked"
fi
if [[ "$(run_pretool_hooks "$(payload .env.example)" Edit)" == "0" ]]; then
  ok ".env.example edits pass through"
else
  bad ".env.example edit was wrongly blocked"
fi
if [[ "$(run_pretool_hooks "$(payload cypress.env.json)" Edit)" == "0" ]]; then
  ok "non-dotenv files containing '.env' (cypress.env.json) pass through"
else
  bad "cypress.env.json was wrongly blocked (substring over-match)"
fi
echo ""

# ── 3. No legacy hook-contract remnants ──────────────────────────────────────
echo "3. Hook contract"
if grep -q 'CLAUDE_TOOL_INPUT' .claude/settings.json; then
  bad 'settings.json references the legacy $CLAUDE_TOOL_INPUT env var (current contract is stdin JSON)'
else
  ok 'no legacy $CLAUDE_TOOL_INPUT references'
fi
echo ""

echo "Results: $PASS passed, $FAIL failed"
if [[ $FAIL -gt 0 ]]; then
  echo "❌ ENFORCEMENT SELF-TEST FAILED — guards are not actually enforcing"
  exit 1
fi
echo "✅ Enforcement layer verified"
