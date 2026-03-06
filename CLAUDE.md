# Claude Code Project Rules

**This project uses external memory docs as source of truth. Always read docs first.**

---

## 📚 Memory System (Source of Truth)

**Read these before making changes:**
1. `docs/context.md` - What, tech stack, key numbers, files
2. `docs/decisions.md` - Why (architectural decisions)
3. `docs/dev.md` - How (setup, commands, troubleshooting)
4. `docs/todos.md` - What's next (prioritized roadmap)
5. `.claude/rules/` - Stack-specific patterns

**After changes:** Update at least one memory doc.

---

## 🎯 Core Workflow

### Before coding:
```bash
cat docs/context.md     # Project overview
cat docs/todos.md       # Current priorities
```

### After coding:
```bash
# 1. Update docs (at least one)
# vim docs/context.md  # or decisions.md, dev.md, todos.md

# 2. Verify
./scripts/verify-memory-and-checks.sh

# 3. Use /finish command
/finish  # Ensures docs updated, runs checks, provides commit message
```

### Context management:
- **Compact manually:** Use `/compact` at ~65% context usage (~130K tokens)
- **Partial compact:** Esc+Esc → select message → "Summarize from here"
- **Reset context:** Use `/clear` between unrelated tasks
- **Check usage:** Use `/context` command

**What to preserve during compaction:**
- Full list of modified files with line counts (`git diff --stat`)
- All test commands and verification steps
- Architectural decisions not yet in docs/decisions.md
- Task IDs (T-XX) for traceability
- Error messages and debugging context

---

## 🤖 Delegation & Subagents

**Use subagents for specialized work:**
- `doc-scribe` (Haiku) - Updates memory docs only
- `test-runner` (Haiku) - Runs tests read-only
- `code-reviewer` (Sonnet) - Reviews diffs for bugs/security

**When to delegate:**
- ✅ Running verbose tests (keeps output isolated)
- ✅ Updating multiple memory docs
- ✅ Multi-file codebase searches (use Explore agent)
- ✅ Reviewing large diffs

**When NOT to delegate:**
- ❌ Reading 1-3 specific files (use Read directly)
- ❌ Simple edits (use Edit directly)
- ❌ Quick searches (Grep/Glob faster than spawning subagent)

**Skills available:**
- `/finish` - Full workflow (docs + tests + commit)
- See `.claude/skills/` for reusable workflows (delegate-to-subagent, add-api-endpoint, update-memory-docs, debug-test-failure)

---

## 🚫 Anti-Patterns (Don't Do This)

❌ Making changes without reading docs first
❌ Large, unfocused commits (>300 lines changed)
❌ Changing code without updating docs
❌ Skipping verification script
❌ Making architectural decisions without documenting in decisions.md

**See `.claude/rules/common-pitfalls.md` for detailed anti-patterns and fixes.**

---

## 📝 Code Quality

**Style:** Follow language conventions (PEP 8 for Python, ESLint for JS/TS)
**Security:** Never commit secrets, validate inputs, use parameterized queries
**Performance:** Cache expensive calls, use indexes, paginate results
**Testing:** Write tests for new features, run verification before pushing

**See `.claude/rules/` for stack-specific patterns.**

---

## 💾 Session Continuity

**HANDOFF.md** - Auto-updated before compaction (PreCompact hook), auto-loaded after (SessionStart hook)
**WORKING_SET.md** - Manual updates for multi-day investigations (theories, experiments, findings)

**Starting new session:**
```bash
/context-refresh  # Re-ground in repo memory
```

**When to restart CLI:**
- ❗ Session >50 turns or >100K tokens
- ❗ Completed major task (after commit + push)
- ❗ Switching to different task area
- ❗ Context feels stale or confused

---

## 📊 Context Budget Awareness

**Total available:** 200K tokens
**Consumed at session start:** ~9K tokens (CLAUDE.md + memory docs + rules)
**Working budget:** ~191K tokens

Monitor usage with `/context` command. Compact at ~130K tokens (65%).

---

**Remember: Docs are not optional. They ARE the project memory.**
