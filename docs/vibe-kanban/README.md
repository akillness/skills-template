# Vibe Kanban

A visual Kanban board for managing AI coding agents. Tasks move through stages — To Do → In Progress → Review → Done — with AI agents automatically assigned to and executing tasks.

---

## Overview

Vibe Kanban provides a browser-based board that coordinates one or more AI agents (Claude, Codex, Gemini) across a set of task cards. Each card represents a discrete unit of work. When an agent is assigned to a card, it picks up the task, executes it in an isolated environment, and advances the card through the pipeline on completion.

Key capabilities:

- Visual progress tracking across a sprint or feature set
- Parallel agent execution on independent tasks
- Git worktree isolation per task card
- Automatic PR creation on task completion
- planno (plannotator) integration for epic-level plan review before card creation (optional, independent)

---

## Installation

No global install is required. Run directly with `npx`:

```bash
# Run directly (no install needed)
npx vibe-kanban

# Or use the wrapper script
bash scripts/vibe-kanban-start.sh

# With custom port
bash scripts/vibe-kanban-start.sh --port 3001
```

After starting, the board is available at `http://localhost:3000` (or your configured port).

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `VIBE_KANBAN_PORT` | Server port | `3000` |
| `VIBE_KANBAN_REMOTE` | Allow remote connections | `false` |
| `ANTHROPIC_API_KEY` | For Claude-powered tasks | — |
| `OPENAI_API_KEY` | For GPT-powered tasks | — |

Set variables in your shell or in a `.env` file at the project root before starting the server.

---

## Workflow — Task → Parallel Agents → PR

### 1. Start the Server

```bash
npx vibe-kanban
# → http://localhost:3000
```

### 2. (Optional) Review Epic Plan with planno

Before creating cards, review the feature breakdown visually:

```text
planno로 이 기능의 구현 계획을 검토해줘
```

planno (plannotator) is an independent skill — usable without Vibe Kanban.

### 3. Create Task Cards

- Add cards to the **To Do** column
- Set title, description, priority (High / Medium / Low)
- Select agent: Claude / Codex / Gemini

### 4. In Progress → Agent Auto-Start

Drag a card to **In Progress**:
- `vk/<hash>-<slug>` branch auto-created
- git worktree auto-created (fully isolated per agent)
- Agent CLI launched with log streaming

### 5. Review Column

- Inspect the branch diff in the web UI
- View agent logs and "thinking process"
- **Retry** with same agent or reassign to a different agent

### 6. PR Creation & Done

- Approve → GitHub PR auto-created
- PR merge → card moves to **Done**
- Worktree auto-cleaned up

---

## Use Cases

### 1. Parallel Epic Decomposition

```
"Payment Flow v2" epic
  ├── Card 1: Frontend UI    → Claude
  ├── Card 2: Backend API    → Codex
  └── Card 3: Integration Tests → Claude
→ 3 cards simultaneously In Progress → parallel implementation
```

### 2. Role-Based Agent Assignment

```
Claude  → Design/domain-heavy features
Codex   → Types/tests/refactoring
Gemini  → Docs/Storybook writing
```

### 3. GitHub PR Team Collaboration

```
VIBE_KANBAN_REMOTE=true
→ Team views board status
→ Review/approve only in GitHub PR
→ Parallel agents + traditional PR process combined
```

### 4. Implementation Comparison

```
Same task, two cards:
  Card A → Claude (UI structure focus)
  Card B → Codex (performance focus)
→ Compare PRs → pick best-of-both
```

---

## Conductor Pattern (CLI Mode)

Vibe Kanban uses the Conductor Pattern internally — each card moved to **In Progress** creates a git worktree and launches an agent in that isolated directory. The same mechanism is available as a pure CLI pipeline without the Kanban UI.

### When to use CLI vs UI

| Scenario | Mode |
|----------|------|
| Team shared board, visual progress tracking | UI mode (`npx vibe-kanban`) |
| CI/CD pipelines, scripted automation | CLI mode (`scripts/pipeline.sh`) |
| Quick local experiments, no UI needed | CLI mode (`scripts/conductor.sh`) |
| Browser-based diff and log review | UI mode |

### Running conductor.sh directly

`scripts/conductor.sh` reads a task list and creates one git worktree per task, then launches agents in parallel:

```bash
# Run conductor for a feature branch
bash scripts/conductor.sh <feature-name>
```

Each task gets its own worktree under `.vk/trees/`, the same structure Vibe Kanban UI creates when you drag a card to In Progress.

### Running the full pipeline

`scripts/pipeline.sh` chains multiple stages together: pre-checks, parallel agent execution via conductor, and automatic PR creation:

```bash
# Full pipeline: check → parallel agents → PR
bash scripts/pipeline.sh <feature-name> --stages check,conductor,pr

# Skip checks, run conductor and PR only
bash scripts/pipeline.sh <feature-name> --stages conductor,pr
```

### Underlying mechanism

Whether you use the Kanban UI or the CLI scripts, the git worktree mechanism is identical:

```
git worktree add .vk/trees/<task-slug> -b vk/<hash>-<task-slug> main
<agent-cli> -p "<task-description>" --cwd .vk/trees/<task-slug>
```

Worktrees are isolated — multiple agents run concurrently without conflicting file edits. After the PR is merged, the worktree is cleaned up automatically.

---

### 2. Plan Review with planno (Optional, Independent)

Before creating individual task cards, you can optionally review the epic breakdown using planno (plannotator) — a separate, independent skill:

```text
planno로 이 기능의 구현 계획을 검토해줘
```

planno breaks the feature spec into an ordered set of sub-tasks. Review and adjust the plan, then approve it. Approved specs become the source of truth for card creation. planno operates independently — you can use Vibe Kanban without it.

### 3. Create Tasks

Add task cards to the **To Do** column. Each card should represent a single, atomic unit of work derived from the approved planno spec (or your own task breakdown if not using planno).

### 4. Assign Agents

Click a task card and select an AI agent from the assignment panel:

- **Claude** — via `ANTHROPIC_API_KEY`
- **Codex** — via `OPENAI_API_KEY`
- **Gemini** — via Google credentials

### 5. Auto-execution

The assigned agent picks up the task and the card moves to **In Progress** automatically. The agent works inside an isolated git worktree (see below) and reports progress back to the board.

### 6. Review

When the agent completes work, a PR is created and the card moves to **Review**. Open the PR link from the card detail view to inspect the diff.

### 7. Merge

Approve and merge the PR. The card advances to **Done**.

---

## planno (plannotator) Integration — Optional, Independent

planno is an independent skill for epic-level plan review. It is not required by Vibe Kanban — each tool operates on its own. Use planno when you want visual annotation and approval of the implementation plan before breaking it into cards.

Typical flow (when using planno alongside Vibe Kanban):

1. Describe the feature or epic in natural language.
2. Ask planno to decompose it: `planno로 이 기능의 구현 계획을 검토해줘`
3. Review the generated breakdown — adjust ordering, scope, or dependencies.
4. Approve the plan.
5. Create one card per approved sub-task in Vibe Kanban.

Skipping planno is perfectly fine for small, self-contained tasks. For larger features with many moving parts, planno helps prevent scope creep before card creation.

---

## Git Worktree Integration

Each task card can optionally operate in an isolated git worktree:

- **Card created** — a worktree is auto-generated from the current branch at `worktrees/<card-id>/`.
- **Agent works in isolation** — changes do not affect the main working tree or other cards.
- **PR created on completion** — the agent commits work, pushes to a feature branch, and opens a PR.
- **Worktree cleaned up** — after the PR is merged, the worktree is removed automatically.

This isolation means multiple agents can work on different cards simultaneously without conflicting file edits.

---

## Use Cases

- **Parallel feature development** — assign different agents to independent feature cards and let them run concurrently.
- **Sprint tracking** — visualize all in-flight AI tasks across a team in one board.
- **Implementation comparison** — create two cards for the same problem, assign different agents, and compare the resulting PRs.
- **Team coordination** — multiple developers each manage their own agent assignments from a shared board view when `VIBE_KANBAN_REMOTE=true`.

---

## Tips

- Keep card scope narrow. One card = one commit-worthy change. Broad cards lead to large, hard-to-review PRs.
- Use planno (independent skill) for any feature touching more than two files.
- Set `VIBE_KANBAN_REMOTE=true` only on trusted networks — it exposes the board and agent controls to all connections on the port.
- If an agent stalls on a card, reassign to a different agent or break the card into smaller pieces.

---

## Quick Reference

```
=== Start Server ===
npx vibe-kanban                    Instant launch
bash scripts/vibe-kanban-start.sh  Wrapper script
http://localhost:3000              Board UI

=== Environment Variables ===
VIBE_KANBAN_PORT=3001              Change port
VIBE_KANBAN_REMOTE=true            Allow remote access
ANTHROPIC_API_KEY=...              Claude auth
OPENAI_API_KEY=...                 Codex/GPT auth

=== Card Flow ===
To Do → In Progress → Review → Done
In Progress: worktree created + agent started
Review: diff/logs visible + Retry available
Done: PR merged

=== Worktree Cleanup ===
git worktree prune                 Remove orphans
git worktree list                  List all worktrees
```

---

## References

- [GitHub: BloopAI/vibe-kanban](https://github.com/BloopAI/vibe-kanban)
- [Official site: vibekanban.com](https://vibekanban.online)
- [Demo: Run Multiple Claude Code Agents Without Git Conflicts](https://www.youtube.com/watch?v=W45XJWZiwPM)
