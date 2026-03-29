#!/usr/bin/env bash
set -euo pipefail

TODO_FILE="docs/todos.md"
PLAN_DIR="docs/plan"

usage() {
  echo "Usage:"
  echo "  todo.sh add <slug> <title> [--priority P1] [--effort M] [--owner backend]"
  echo "  todo.sh done <T-XX>"
  echo "  todo.sh list [open|blocked|done|all]"
  echo "  todo.sh next                          # show highest priority open task"
  exit 1
}

next_id() {
  local max=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^###\ T-([0-9]+): ]]; then
      local num="${BASH_REMATCH[1]}"
      num=$((10#$num))  # force base-10
      if (( num > max )); then max=$num; fi
    fi
  done < "$TODO_FILE"
  printf "%02d" $((max + 1))
}

cmd_add() {
  local slug="" title="" priority="P1" effort="M" owner="unassigned"

  slug="$1"; shift
  title="$1"; shift

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --priority) priority="$2"; shift 2 ;;
      --effort) effort="$2"; shift 2 ;;
      --owner) owner="$2"; shift 2 ;;
      *) echo "Unknown flag: $1"; exit 1 ;;
    esac
  done

  local id
  id=$(next_id)
  local entry_id="T-${id}"
  local spec_file="${PLAN_DIR}/${entry_id}-${slug}.md"

  # Add to TODO.md under Active section
  local entry
  entry=$(cat <<EOF

### ${entry_id}: ${title} \`${slug}\`
${priority} | ${effort} | Status: open | Owner: ${owner}
Spec: ${spec_file}
- [ ] implementation
- [ ] tests
- [ ] docs
Files: \`TBD\`
EOF
)

  # Insert after "## Active" line
  if grep -q "^## Active" "$TODO_FILE"; then
    sed -i "/^## Active/a\\
$(echo "$entry" | sed 's/$/\\/' | sed '$ s/\\$//')" "$TODO_FILE"
  else
    echo "$entry" >> "$TODO_FILE"
  fi

  # Create spec from template
  mkdir -p "$PLAN_DIR"
  if [ -f "${PLAN_DIR}/TEMPLATE.md" ]; then
    sed "s/T-XX/${entry_id}/g; s/Title/${title}/g" "${PLAN_DIR}/TEMPLATE.md" > "$spec_file"
  else
    echo "# ${entry_id}: ${title}" > "$spec_file"
  fi

  echo "Created ${entry_id}: ${title}"
  echo "  TODO.md entry added"
  echo "  Spec file: ${spec_file}"
  echo ""
  echo "Next: edit ${spec_file} to fill in the full spec"
}

cmd_done() {
  local target="$1"
  if ! grep -q "^### ${target}:" "$TODO_FILE"; then
    echo "Not found: ${target}"
    exit 1
  fi

  python3 - "$TODO_FILE" "$target" <<'PYEOF'
import sys, re

todo_file = sys.argv[1]
target = sys.argv[2]

with open(todo_file) as f:
    content = f.read()

# Match entry block: from "### T-XX:" header to next ## or ### heading, or EOF
target_escaped = re.escape(target)
m = re.search(r'\n*(### ' + target_escaped + r':.*?)(?=\n## |\n### |\Z)', content, re.DOTALL)
if not m:
    print(f"Could not extract block for {target}", file=sys.stderr)
    sys.exit(1)

raw_match = m.group(0)   # includes leading newlines
block = m.group(1).strip()

# Update status on the metadata line (line starting with P0-P3)
block = re.sub(r'(?m)^(P[0-3] \|.*?)Status: [a-z-]+', r'\1Status: done', block)

# Remove block from its current position
content = content.replace(raw_match, '\n', 1)

# Insert under ## Done, after section header and any HTML comment block
done_match = re.search(r'(## Done\n(?:<!--.*?-->\n)?)\n*', content, re.DOTALL)
if done_match:
    insert_pos = done_match.end()
    content = content[:insert_pos] + block + '\n\n' + content[insert_pos:]
else:
    content = content.rstrip() + '\n\n## Done\n\n' + block + '\n'

# Collapse 3+ consecutive newlines to 2
content = re.sub(r'\n{3,}', '\n\n', content)

with open(todo_file, 'w') as f:
    f.write(content)

print(f"Marked {target} as done and moved to ## Done")
PYEOF
}

cmd_list() {
  local filter="${1:-open}"
  if [ "$filter" = "all" ]; then
    grep -E "^### T-" "$TODO_FILE" || echo "No tasks found"
  else
    # Find entries whose metadata line contains the status
    grep -B1 "Status: ${filter}" "$TODO_FILE" | grep "^### T-" || echo "No ${filter} tasks"
  fi
}

cmd_next() {
  # Find highest priority open task (P0 > P1 > P2 > P3)
  for p in P0 P1 P2 P3; do
    local match
    match=$(grep -B1 "${p}.*Status: open" "$TODO_FILE" | grep "^### T-" | head -1) || true
    if [ -n "$match" ]; then
      echo "$match"
      return
    fi
  done
  echo "No open tasks"
}

[[ $# -lt 1 ]] && usage

case "$1" in
  add)   shift; [[ $# -lt 2 ]] && usage; cmd_add "$@" ;;
  done)  shift; [[ $# -lt 1 ]] && usage; cmd_done "$@" ;;
  list)  shift; cmd_list "${1:-open}" ;;
  next)  cmd_next ;;
  *)     usage ;;
esac
