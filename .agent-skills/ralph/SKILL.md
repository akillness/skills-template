---
name: ralph
keyword: ralph
description: Self-referential completion loop for AI CLI tools. Re-runs the agent on the same task across turns with fresh context each iteration, until the completion promise is detected or max iterations is reached.
allowed-tools: [Read, Write, Bash, Grep, Glob]
tags: [ralph, ralph-loop, loop, completion, gemini-cli, opencode, self-referential]
platforms: [Gemini-CLI, OpenCode, oh-my-opencode, Claude Code]
version: 2.0.0
source: gemini-cli-extensions/ralph
---

# ralph - Self-Referential Completion Loop

## When to use this skill

- Long-running implementation tasks that tend to stop early
- Tasks that need autonomous multi-turn iteration without manual intervention
- Workflows where the agent must self-correct and refine output across turns
- Sessions where exact completion signaling is required before stopping

---

## Core Concept

The loop happens **across agent turns**, controlled by an `AfterAgent` hook.

1. **You run ONCE**: `/ralph "Your task description" --completion-promise "DONE"`
2. **Agent works**: Performs actions (modifies files, runs tests, writes code)
3. **Hook intercepts**: When the agent finishes its turn, the `AfterAgent` hook intercepts the exit
4. **Loop continuation**: Hook evaluates state (max iterations, promise) and starts a new turn with the **original prompt**, clearing the previous turn's context
5. **Repeat**: Continues autonomously until completion or user interruption

### Why this works

- **Stable Context & No Compaction**: Prompt never changes between iterations; previous conversational context is cleared. The agent relies on current file state, not stale chat history.
- **Persistent State**: The agent's work persists in files and git history across iterations.
- **Autonomous Improvement**: Each iteration sees the current codebase state and improves on past work.
- **Ghost Protection**: If you interrupt the loop and start a new task, the hook detects the prompt mismatch and silently cleans up.

---

## 1. Core Command Pattern

```text
/ralph "<task description>" [--completion-promise=TEXT] [--max-iterations=N]
```

Defaults:
- Completion promise: `DONE`
- Max iterations: `5`

---

## 2. How the Loop Behaves

1. Starts with your task prompt.
2. On each turn end, the `AfterAgent` hook checks whether the assistant output contains:

```xml
<promise>DONE</promise>
```

3. If not found, hook starts a new agent turn with the same original prompt (context cleared).
4. Stops only when:
   - Completion promise is detected in output, or
   - Max iterations is reached, or
   - You run `/ralph:cancel`

---

## 3. Practical Usage

### Standard run

```text
/ralph "Build a Python CLI task manager with full test coverage"
```

### With completion promise

```text
/ralph "Build a REST API for todos. When all CRUD endpoints work and tests pass with >80% coverage, output TASK_COMPLETE" --completion-promise="TASK_COMPLETE"
```

### Bounded iteration run

```text
/ralph "Attempt to refactor the authentication module" --max-iterations=20
```

### TDD workflow with self-correction

```text
/ralph "Implement feature X by following TDD:
1. Write failing tests for the feature.
2. Implement the code to make the tests pass.
3. Run the test suite.
4. If any tests fail, analyze the errors and debug.
5. Refactor for clarity and efficiency.
6. Repeat until all tests are green.
7. When complete, output <promise>TESTS_PASSED</promise>" --completion-promise="TESTS_PASSED"
```

### Cancel active loop

```text
/ralph:cancel
```

### View help

```text
/ralph:help
```

---

## 4. Prompt Writing Best Practices

### 1. Clear Completion Criteria

Provide a verifiable definition of "done." The `--completion-promise` is crucial.

**Good:**
```text
/ralph "Build a REST API for todos. When all CRUD endpoints are working and all tests pass with >80% coverage, you're complete." --completion-promise="TASK_COMPLETE"
```

### 2. Use Safety Hatches

Always use `--max-iterations` as a safety net to prevent infinite loops.

```text
/ralph "Attempt to refactor the authentication module" --max-iterations=20
```

### 3. Encourage Self-Correction

Structure the prompt to guide the agent through work → verify → debug cycles.

---

## 5. Launch Safely

Always run in sandbox mode for safety. Enabling YOLO mode (`-y`) prevents constant tool execution prompts during the loop:

```bash
gemini -s -y
```

---

## 6. Installation (Gemini CLI)

```bash
gemini extensions install https://github.com/gemini-cli-extensions/ralph --auto-update
```

Required in `~/.gemini/settings.json`:

```json
{
  "hooksConfig": { "enabled": true },
  "context": {
    "includeDirectories": ["~/.gemini/extensions/ralph"]
  }
}
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Start loop | `/ralph "task"` |
| Custom promise | `/ralph "task" --completion-promise=TEXT` |
| Iteration cap | `/ralph "task" --max-iterations=N` |
| Cancel | `/ralph:cancel` |
| Help | `/ralph:help` |
