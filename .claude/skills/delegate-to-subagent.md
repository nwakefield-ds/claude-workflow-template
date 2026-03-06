# Delegation Strategy Skill

**Agent-callable skill for determining when and how to delegate work to subagents.**

---

## Available Subagents

### doc-scribe (Haiku - cost-effective)
- **Purpose:** Updates memory docs based on code changes
- **Tools:** Read, Edit(docs/*), Glob(docs/*)
- **Denied:** Edit(backend/*), Edit(frontend*/*), Write
- **When to use:** After code changes that affect docs/context.md, docs/decisions.md, docs/dev.md, or docs/todos.md

### test-runner (Haiku - deterministic)
- **Purpose:** Runs lint/test/build and summarizes results
- **Tools:** Bash (test commands only), Read
- **Denied:** Edit, Write, git operations
- **When to use:** Before committing, after significant changes, to verify CI will pass

### code-reviewer (Sonnet - needs reasoning)
- **Purpose:** Reviews diffs for bugs, security issues, consistency
- **Tools:** Read, Bash (git diff only)
- **Denied:** Edit, Write, modification operations
- **When to use:** Large diffs (>200 lines), security-sensitive changes, before PR creation

---

## When to Delegate

### ✅ DO delegate when:
- Running verbose tests (keeps output isolated from main context)
- Updating multiple memory docs (keeps diff noise isolated)
- Doing multi-file codebase searches requiring multiple rounds (use Explore agent)
- Testing competing theories for complex bugs (parallel subagents)
- Reviewing large diffs (code-reviewer can focus on security/bugs without bloating main context)

### ❌ DON'T delegate when:
- Reading 1-3 specific files (use Read tool directly - faster)
- Simple edits (use Edit tool directly - no context overhead)
- Quick searches (use Grep/Glob directly - spawning subagent is slower)
- You need the context yourself (delegation loses context, main agent doesn't see subagent's findings unless returned)

---

## Delegation Patterns

### Simple Delegation
```
Use Task tool with subagent_type='doc-scribe'
Prompt: "Update docs/context.md to reflect the new API endpoint count (89 → 92).
Updated files: backend/routers/new_feature.py"
```

### Competing-Hypothesis Debugging

For complex bugs where root cause is unclear:

1. **Spawn 2-3 subagents in parallel**, each testing a different theory:
   - Theory 1: Caching issue
   - Theory 2: Race condition
   - Theory 3: Data validation

2. **Each subagent runs experiments** in isolation without bloating main context:
   ```
   Task tool with subagent_type='general-purpose'
   Prompt: "Test the hypothesis that this bug is a caching issue.

   Experiments to run:
   1. Disable cache in config and retest
   2. Clear all cache files and retest
   3. Check TTL values in cache manager
   4. Look for cache key collisions

   Report findings with evidence (log excerpts, test results)."
   ```

3. **Main orchestrator synthesizes** results and implements fix based on confirmed theory

4. **Use Agent Teams** for truly parallel investigation (requires experimental flag)

---

## Model Routing (Cost Optimization)

- **Main orchestrator (you):** Sonnet (complex decision-making, architectural reasoning)
- **doc-scribe:** Haiku ($0.15/MTok vs $0.25/MTok - 40% savings for simple doc updates)
- **test-runner:** Haiku (deterministic task, just runs commands)
- **code-reviewer:** Sonnet (needs reasoning for bug detection, security analysis)
- **Explore agent:** Automatically routed (uses Haiku for simple searches, Sonnet for complex analysis)

**Cost impact:** 60% savings on subagent API costs when using Haiku for docs/tests.

---

## Example Workflows

### After Feature Implementation
```
1. Main agent: Write code, update tests
2. Delegate to test-runner: "Run full test suite and report failures"
3. Delegate to doc-scribe: "Update docs/context.md with new endpoint count and key file changes"
4. Main agent: Review results, commit
```

### Complex Bug Investigation
```
1. Main agent: Identify symptoms, formulate 3 theories
2. Spawn 3 subagents in parallel (competing-hypothesis pattern)
3. Each subagent: Run experiments, report findings
4. Main agent: Synthesize results, implement fix based on confirmed theory
5. Delegate to test-runner: "Verify fix with regression tests"
```

### Large PR Review
```
1. Delegate to code-reviewer: "Review this 500-line diff for:
   - Security vulnerabilities (SQL injection, XSS, path traversal)
   - Logic bugs (off-by-one, null checks, race conditions)
   - Consistency with existing patterns"
2. Main agent: Address findings, commit fixes
```

---

## Tips

- **Provide clear, detailed prompts** so subagents can work autonomously
- **Specify expected output format** (e.g., "Report as bullet list", "Return JSON")
- **Trust subagent outputs** - they're using the same model family, just scoped differently
- **Don't duplicate work** - if you delegate research to a subagent, don't also run the same searches yourself
- **Use background mode for long tasks** - `run_in_background: true` lets you continue working while subagent runs
