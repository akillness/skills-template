# Conductor Pattern

## Overview

The Conductor Pattern uses `git worktree` to run multiple AI agents (Claude/Codex/Gemini) in parallel on the same feature spec, each in an isolated branch. Results are compared via PRs.

Each agent works independently in its own worktree, producing a branch that can be opened as a pull request. You review the PRs side by side and merge the best implementation — or cherry-pick across them.

---

## Prerequisites

- git (with worktree support)
- tmux
- gh CLI (for PR creation)
- At least one of: `claude`, `codex`, `gemini` CLI

---

## Quick Start

```bash
# 1. Pre-flight check
bash scripts/pipeline-check.sh --agents=claude,codex

# 2. Run directly
bash scripts/conductor.sh my-feature main claude,codex

# 4. Create PRs after agents finish
bash scripts/conductor-pr.sh my-feature main

# 5. Clean up
bash scripts/conductor-cleanup.sh my-feature
```

---

## Unified Pipeline

Run all stages in sequence with a single command:

```bash
# Full pipeline (check -> conductor -> PR)
bash scripts/pipeline.sh my-feature --stages check,conductor,pr

# With plan review
bash scripts/pipeline.sh my-feature --stages check,plan,conductor,pr

# Dry run (preview only)
bash scripts/pipeline.sh my-feature --dry-run

# Resume after failure
bash scripts/pipeline.sh --resume
```

### Pipeline Flags

| Flag | Description |
|------|-------------|
| `--base <branch>` | Base branch (default: main) |
| `--agents <list>` | Comma-separated agents (default: claude,codex) |
| `--stages <list>` | Stages to run: check,plan,conductor,pr,copilot |
| `--no-attach` | Don't attach to tmux (CI/non-interactive) |
| `--dry-run` | Print stages without executing |
| `--resume` | Resume from last failed stage |

훅 스킵은 `--skip-hooks` 플래그가 아닌 환경 변수로 제어합니다.

---

## Hooks System

Hooks in `scripts/hooks/` run automatically at each stage. Executable scripts are optional; set `CONDUCTOR_SKIP_HOOKS=1` to disable all hooks, or `CONDUCTOR_HOOKS_DIR` to use another directory.

| Event | File | Abort on Fail |
|-------|------|---------------|
| `pre-conductor` | `hooks/pre-conductor.sh` | Yes |
| `post-conductor` | `hooks/post-conductor.sh` | No (warning) |
| `pre-pr` | `hooks/pre-pr.sh` | Yes |
| `post-pr` | `hooks/post-pr.sh` | No |

Skip all hooks:

```bash
CONDUCTOR_SKIP_HOOKS=1 bash scripts/pipeline.sh ...
```

Custom hooks directory:

```bash
CONDUCTOR_HOOKS_DIR=/path/to/hooks bash scripts/pipeline.sh ...
```

---

## planno (plannotator) Integration — Optional

planno (plannotator) is a separate, independent skill for reviewing implementation plans visually before agents start coding. It can be used alongside Conductor, but each operates independently.

```bash
# Optional: planno은 독립 툴이며, 스크립트 호출은 필요하지 않습니다.
# 1) planno로 계획 리뷰: planno로 구현 계획 검토해줘
# 2) 이후 conductor를 별도로 실행:
bash scripts/conductor.sh my-feature main claude,codex
```

Install plannotator (only needed for the plan review step):

```bash
curl -fsSL https://plannotator.ai/install.sh | bash
```

---

## Feature Name Rules

Feature names are automatically normalized before use in branch and worktree names:

- Lowercase only
- Alphanumeric and hyphens only
- Example: `"My Feature 2.0"` → `"my-feature-2-0"`

---

## Worktree Structure

Each agent gets its own isolated workspace under `trees/`:

```
trees/
├── feat-my-feature-claude/    # Claude's isolated workspace
├── feat-my-feature-codex/     # Codex's isolated workspace
└── feat-my-feature-gemini/    # Gemini's isolated workspace
```

Each directory is a full git worktree on its own branch. Agents cannot interfere with each other's work.

---

## Pipeline State

State is saved to `.conductor-pipeline-state.json` after each stage completes. On failure, resume without re-running successful stages:

```bash
# Resume from the last failed stage
bash scripts/pipeline.sh --resume

# Or restart from a specific stage
bash scripts/pipeline.sh my-feature --stages pr
```

---

## Use Cases

### 1. Same Spec, Multiple Implementations Compared

```
UI redesign → Claude / Codex / Gemini generate 3 versions simultaneously
→ Compare design / code quality / performance → pick the best
```

### 2. Risk Hedging

```
High-risk refactor:
  Agent A fails → Agent B succeeds (probability-based coverage)
  Pick the safer implementation from both results
```

### 3. Role-Based Parallel Work

```
Claude  → Domain logic / design  (feat/<name>-claude)
Codex   → Boilerplate / tests / types  (feat/<name>-codex)
Gemini  → Docs / Storybook  (feat/<name>-gemini)
```

### 4. Merge / PR Strategy

```bash
feat/<name>-claude  ─┐
feat/<name>-codex   ─┼─ compare review → best-of-both → main
feat/<name>-gemini  ─┘
```

Review options:
1. Pick a single PR → merge
2. cherry-pick the best parts from each
3. Manually combine into `feat/<name>-best` branch → merge

---

## Quick Reference

```
=== Commands ===
pipeline.sh <feat> --stages check,conductor,pr   Full pipeline
conductor.sh <feat> main claude,codex            Parallel agents
conductor-pr.sh <feat> main                      Create PRs
conductor-cleanup.sh <feat>                      Clean up worktrees

=== Worktree Management ===
git worktree list                                List all
git worktree remove trees/feat-<name>-<agent>   Remove one
git worktree prune                               Clean orphans

=== Hooks ===
CONDUCTOR_SKIP_HOOKS=1   Skip all hooks
--dry-run                Preview without executing
--resume                 Resume from last failed stage
```

---

## References

- [Claude Code Docs: Run parallel sessions with Git worktrees](https://code.claude.com/docs/en/common-workflows)
- [Parallel AI Coding with Git Worktrees](https://docs.agentinterviews.com/blog/parallel-ai-coding-with-gitworktrees/)
