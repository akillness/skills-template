# omc — oh-my-claudecode Guide

> **oh-my-claudecode**는 Claude Code 전용 Teams-first 멀티 에이전트 오케스트레이션 레이어입니다.
> `omc` 키워드로 활성화하며, 32개 전문 에이전트와 스마트 모델 라우팅을 제공합니다.

← [Back to README](../../README.md)

---

## Installation (3 Steps)

**Step 1: Install plugin**
```bash
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
```

**Step 2: Run setup**
```bash
/omc:omc-setup
```

**Step 3: Build something**
```text
autopilot: build a REST API for managing tasks
```

> **npm alternative**: `npm install -g oh-my-claude-sisyphus`

---

## Orchestration Modes

| Mode | What it is | Use For |
|------|-----------|---------|
| **Team** (recommended) | Staged pipeline: `team-plan → team-prd → team-exec → team-verify → team-fix` | Coordinated agents on shared task list |
| **Autopilot** | Autonomous single lead agent | End-to-end feature work |
| **Ultrawork** | Maximum parallelism (non-team) | Burst parallel fixes/refactors |
| **Ralph** | Persistent mode with verify/fix loops | Tasks that must complete fully |
| **Pipeline** | Sequential staged processing | Multi-step transformations |
| **Swarm/Ultrapilot** | Legacy facades → route to Team | Existing workflows |

---

## Team Mode (Canonical)

```bash
/omc:team 3:executor "fix all TypeScript errors"
```

Runs as a staged pipeline:
```
team-plan → team-prd → team-exec → team-verify → team-fix (loop)
```

### Enable Claude Code Native Teams

Add to `~/.claude/settings.json`:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

---

## Magic Keywords

| Keyword | Effect | Example |
|---------|--------|---------|
| `team` | Canonical Team orchestration | `/omc:team 3:executor "fix all TypeScript errors"` |
| `autopilot` | Full autonomous execution | `autopilot: build a todo app` |
| `ralph` | Persistence mode | `ralph: refactor auth module` |
| `ulw` | Maximum parallelism | `ulw fix all errors` |
| `plan` | Planning interview | `plan the API architecture` |
| `ralplan` | Iterative planning consensus | `ralplan this feature` |
| `swarm` | Legacy (routes to Team) | `swarm 5 agents: fix lint errors` |
| `ultrapilot` | Legacy (routes to Team) | `ultrapilot: build a fullstack app` |

> **Note**: `ralph` includes ultrawork — activating ralph mode automatically includes ultrawork's parallel execution.

---

## Why omc?

- **Zero configuration** — Works out of the box with intelligent defaults
- **Team-first orchestration** — Team is the canonical multi-agent surface
- **Natural language interface** — No commands to memorize
- **Automatic parallelization** — Complex tasks distributed across 32 specialized agents
- **Persistent execution** — Won't stop until the job is verified complete
- **Cost optimization** — Smart model routing saves 30–50% on tokens
- **Real-time visibility** — HUD statusline shows what's happening under the hood

---

## Requirements

- Claude Code CLI
- Claude Max/Pro subscription **or** Anthropic API key

---

## Optional: Multi-AI Orchestration

OMC can optionally delegate to external AI providers for cross-validation:

| Provider | Install | What it enables |
|----------|---------|----------------|
| Gemini CLI | `npm install -g @google/gemini-cli` | Design review, UI consistency (1M token context) |
| Codex CLI | `npm install -g @openai/codex` | Architecture validation, code review cross-check |

---

## Utilities

### Rate Limit Wait
Auto-resume Claude Code sessions when rate limits reset:
```bash
omc wait          # Check status, get guidance
omc wait --start  # Enable auto-resume daemon
omc wait --stop   # Disable daemon
```

### Notifications (Telegram/Discord)
```bash
omc config-stop-callback telegram --enable --token <bot_token> --chat <chat_id>
omc config-stop-callback discord --enable --webhook <url>
```

---

---

## Quick Reference

| Action | Command |
|--------|---------|
| Install | `/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode` |
| Setup | `/omc:omc-setup` |
| Team mode | `/omc:team N:executor "task"` |
| Autopilot | `autopilot: <task>` |
| Ralph loop | `ralph: <task>` |
| Ultrawork | `ulw <task>` |
| Update | `/plugin marketplace update omc && /omc:omc-setup` |
| Debug | `/omc:omc-doctor` |

→ [Full documentation](https://yeachan-heo.github.io/oh-my-claudecode-website) · [GitHub](https://github.com/Yeachan-Heo/oh-my-claudecode)
