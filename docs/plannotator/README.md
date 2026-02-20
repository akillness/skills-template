# plannotator — Interactive Plan & Diff Review

> Keyword: `planno` | [GitHub](https://github.com/backnotprop/plannotator) | [plannotator.ai](https://plannotator.ai)
>
> Annotate and review AI coding agent plans visually, share with your team, send feedback with one click.

## What is plannotator?

plannotator opens a **visual browser UI** when your AI coding agent finishes planning. You can annotate the plan, then either approve it (agent proceeds) or request changes (annotations sent back as structured feedback).

**Part of AI Review Tools family** (independent tools, each with its own keyword):
| Tool | Keyword | Purpose |
|------|---------|---------|
| **plannotator** | `planno` | Visual plan/diff review |
| **vibe-kanban** | `kanbanview` | Kanban board for AI agents |
| **copilot-coding-agent** | `copilotview` | GitHub Copilot issue→PR |
| **conductor-pattern** | `conductor` | Parallel git worktree agents |

---

## Installation

### Scripts (Recommended — Automated)

All installation steps have corresponding scripts in `scripts/`. Run them directly or let the agent call them.

| Script | Purpose |
|--------|---------|
| `scripts/install.sh` | Install plannotator CLI |
| `scripts/setup-hook.sh` | Configure Claude Code `ExitPlanMode` hook |
| `scripts/check-status.sh` | Verify full installation |
| `scripts/configure-remote.sh` | SSH / devcontainer / WSL setup |
| `scripts/review.sh` | Launch diff review UI |

### 1. Install the CLI

```bash
# macOS / Linux / WSL (via script)
bash scripts/install.sh

# Or install CLI + get plugin commands
bash scripts/install.sh --with-plugin

# Direct install
curl -fsSL https://plannotator.ai/install.sh | bash
```

### 2. Connect to Claude Code

**Option A — Plugin (recommended, no manual hook needed):**
```bash
/plugin marketplace add backnotprop/plannotator
/plugin install plannotator@plannotator
# IMPORTANT: Restart Claude Code after plugin install
```

**Option B — Manual hook:**
```bash
bash scripts/setup-hook.sh
# Restart Claude Code after running
```

### 3. Connect to OpenCode

Add to `opencode.json`:
```json
{
  "plugin": ["@plannotator/opencode@latest"]
}
```

Run install script, then restart OpenCode.

### 4. Verify installation

```bash
bash scripts/check-status.sh
```

Checks CLI version, hook configuration, env vars, and git repo state.

### Recommended Setup Flow

```
1. bash scripts/install.sh --with-plugin
   └─ Installs CLI + shows plugin install commands

2. bash scripts/setup-hook.sh          ← skip if using plugin
   └─ Configures automatic plan review trigger

3. bash scripts/check-status.sh
   └─ Confirm everything is ready
```

---

## Feature 1: Plan Review (Before Coding)

When your agent finishes planning, Plannotator **automatically opens a browser UI**:

### How it works
```
[Agent produces plan]
        ↓
[Plannotator UI opens in browser]
        ↓
[You annotate the plan]
        ↓
    ┌───┴───┐
    │       │
 Approve  Request Changes
    │       │
    ↓       ↓
[Agent   [Annotations sent
 codes]   back → Agent replans]
```

### Annotation types
| Type | Use |
|------|-----|
| `delete` | Remove risky or unnecessary step |
| `insert` | Add missing step |
| `replace` | Revise incorrect approach |
| `comment` | Clarify constraints or acceptance criteria |

### Claude Code usage
1. Enter plan mode: `Shift+Tab×2`
2. Agent generates the plan
3. Plannotator UI opens automatically via hook
4. Annotate → Approve or Request Changes

---

## Feature 2: Code Review with /plannotator-review

```bash
/plannotator-review
```

Review git diffs with **inline annotations** (New: Jan 2026):
- Select specific line numbers to annotate
- Switch between unified and split diff views
- Attach and annotate images (pen, arrow, circle tools)
- Send feedback directly to the agent

---

## Feature 3: Auto-save & Sharing

- **Obsidian integration**: Approved plans auto-save to your Obsidian vault
- **Bear Notes integration**: Approved plans auto-save to Bear Notes
- **Share links**: Share plan review sessions with teammates for collaboration

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PLANNOTATOR_REMOTE` | No auto browser open (for SSH/devcontainer) | false |
| `PLANNOTATOR_PORT` | Fixed port for the local server | auto |
| `PLANNOTATOR_BROWSER` | Custom browser executable path | system default |
| `PLANNOTATOR_SHARE_URL` | Custom share portal URL | plannotator.ai |

```bash
export PLANNOTATOR_REMOTE=1
export PLANNOTATOR_PORT=9999
```

---

## Keyword Activation

```text
planno로 이번 구현 계획을 검토하고 수정 코멘트를 만들어줘.
```

---

## Best Practices

1. **Review plans before coding** — catch wrong approaches before they become wrong code
2. **One annotation per concern** — multiple issues in one annotation confuse agents
3. **Include acceptance criteria** — "Request Changes" should specify testable conditions
4. **Use image annotations** for UI/UX feedback where text descriptions fall short
5. **Specific line annotations** for diff review — don't annotate whole files when one line is the issue

---

## References

- [GitHub: backnotprop/plannotator](https://github.com/backnotprop/plannotator)
- [plannotator.ai](https://plannotator.ai)
- [Installation details](https://github.com/backnotprop/plannotator/blob/main/apps/hook/README.md)
- [Latest release: v0.8.2](https://github.com/backnotprop/plannotator/releases/tag/v0.8.2)
