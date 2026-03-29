#!/usr/bin/env bash
set -euo pipefail

TODO_FILE="${1:-docs/todos.md}"

if [ ! -f "$TODO_FILE" ]; then
  echo "No $TODO_FILE found — skipping"
  exit 0
fi

errors=0
warnings=0
line_num=0
in_entry=false
entry_has_deliverables=false
entry_has_files=false
entry_id=""
current_section=""

while IFS= read -r line || [[ -n "$line" ]]; do
  line_num=$((line_num + 1))

  # Track sections
  if [[ "$line" =~ ^##\  ]]; then
    # If we were in an entry, validate it had required parts
    if $in_entry; then
      if ! $entry_has_deliverables; then
        echo "ERROR line $line_num: entry $entry_id has no deliverables checklist"
        errors=$((errors + 1))
      fi
      if ! $entry_has_files; then
        echo "WARN  line $line_num: entry $entry_id has no Files: line"
        warnings=$((warnings + 1))
      fi
    fi
    in_entry=false
    current_section="$line"
    continue
  fi

  # Skip blanks, HTML comments, top-level heading
  [[ -z "$line" ]] && continue
  [[ "$line" =~ ^# ]] && continue
  [[ "$line" =~ ^\<\!-- ]] && continue
  [[ "$line" =~ --\>$ ]] && continue

  # Entry header: ### T-XX: Title `slug`
  if [[ "$line" =~ ^###\  ]]; then
    # Validate previous entry if any
    if $in_entry; then
      if ! $entry_has_deliverables; then
        echo "ERROR line $line_num: entry $entry_id has no deliverables checklist"
        errors=$((errors + 1))
      fi
      if ! $entry_has_files; then
        echo "WARN  line $line_num: entry $entry_id has no Files: line"
        warnings=$((warnings + 1))
      fi
    fi

    in_entry=true
    entry_has_deliverables=false
    entry_has_files=false

    # Must match ### T-XX: ... `slug`
    if [[ ! "$line" =~ ^###\ T-[0-9]+:\ .+\ \`.+\`$ ]]; then
      echo "ERROR line $line_num: header must match '### T-XX: Title \`slug\`' — got '$line'"
      errors=$((errors + 1))
      entry_id="(malformed)"
    else
      entry_id=$(echo "$line" | grep -oP 'T-\d+')
    fi
    continue
  fi

  # Metadata line (immediately after header)
  if $in_entry && [[ "$line" =~ ^P[0-3]\ \| ]]; then
    # Validate priority
    if [[ ! "$line" =~ ^P[0-3] ]]; then
      echo "ERROR line $line_num: invalid priority in '$line'"
      errors=$((errors + 1))
    fi
    # Validate effort
    if [[ ! "$line" =~ (XS|S|M|L|XL) ]]; then
      echo "ERROR line $line_num: invalid effort (need XS/S/M/L/XL) in '$line'"
      errors=$((errors + 1))
    fi
    # Validate status
    if [[ ! "$line" =~ Status:\ (open|in-progress|blocked|done) ]]; then
      echo "ERROR line $line_num: invalid status (need open/in-progress/blocked/done) in '$line'"
      errors=$((errors + 1))
    fi
    # Check for Owner
    if [[ ! "$line" =~ Owner: ]]; then
      echo "WARN  line $line_num: missing Owner in '$line'"
      warnings=$((warnings + 1))
    fi
    continue
  fi

  # Spec link
  [[ "$line" =~ ^Spec: ]] && continue

  # Deliverables
  if [[ "$line" =~ ^-\ \[(x|\ )\]\  ]]; then
    entry_has_deliverables=true
    continue
  fi

  # Files line
  if [[ "$line" =~ ^Files: ]]; then
    entry_has_files=true
    continue
  fi

done < "$TODO_FILE"

# Validate last entry
if $in_entry; then
  if ! $entry_has_deliverables; then
    echo "ERROR: entry $entry_id has no deliverables checklist"
    errors=$((errors + 1))
  fi
  if ! $entry_has_files; then
    echo "WARN: entry $entry_id has no Files: line"
    warnings=$((warnings + 1))
  fi
fi

echo ""
echo "Results: $errors error(s), $warnings warning(s)"
if [ "$errors" -gt 0 ]; then
  exit 1
fi
echo "$TODO_FILE format OK"
