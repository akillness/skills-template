# Harness Engineering — CLI Activation Guide

> Three specialized orchestration skills, each engineered as a harness for a specific CLI and model ecosystem.

← [Back to README](../../README.md)

---

## Harness Overview

| Keyword | Skill | Best With | Harness For |
|---------|-------|-----------|-------------|
| `ohmg` | oh-my-ag | Gemini-CLI | Google models (Gemini, Gemma) — multi-domain agent coordination via Serena Memory |
| `omx` | oh-my-codex | Codex CLI | OpenAI models — 30 agents, 40+ workflow skills, tmux team mode, MCP servers |
| `bmad` | bmad-orchestrator | **All CLIs** | Universal — BMAD phase routing (Analysis → Planning → Solutioning → Implementation) |
| `omc` | oh-my-claudecode | Claude Code | Claude models — 32 agents, Teams/Autopilot/Ralph/Ultrawork modes |

---

## Activation Pattern

All harness skills require **explicit activation** before first use. End your request with **"기억해"** (remember) to persist the configuration:

```text
<harness> 스킬을 설정하고 사용해줘. 기억해.
```

> Without "기억해", the agent will use the skill for the current session only and may not retain configuration across sessions.

---

## Per-CLI Usage Examples

### Claude Code — `omc` / `bmad` harness

```text
# Activate omc (oh-my-claudecode)
omc 스킬을 설정하고 사용해줘. 기억해.

# Activate bmad
bmad 스킬을 설정하고 사용해줘. 기억해.
bmad로 이 프로젝트 API 설계해줘.
/workflow-init
```

### Codex CLI — `omx` harness (OpenAI models)

```text
# Activate omx
omx 스킬을 설정하고 사용해줘. 기억해.

# Start autopilot
$autopilot 전체 인증 모듈 구현해줘

# Start team mode
$team 백엔드 API 개발 시작해줘
```

### Gemini-CLI — `ohmg` harness (Google models)

```text
# Activate ohmg
ohmg 스킬을 설정하고 사용해줘. 기억해.

# Coordinate agents
/coordinate PM Agent에게 요구사항 분석 요청해줘
```

### OpenCode / oh-my-opencode — all keywords available

```text
# Supports all harnesses in one session
ralph로 이 작업 완료될 때까지 반복해줘
ohmg 스킬로 멀티 에이전트 워크플로우 시작해줘. 기억해.
```

---

## Install by CLI

```bash
# Claude Code — install omc plugin
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode

# Codex CLI — install omx skill
npx skills add https://github.com/supercent-io/skills-template --skill oh-my-codex

# Gemini-CLI — install ohmg skill
npx skills add https://github.com/supercent-io/skills-template --skill ohmg

# All CLIs — install bmad skill
npx skills add https://github.com/supercent-io/skills-template --skill bmad-orchestrator
```

---

## Troubleshooting

**Skill not activating?**
- Make sure you said "기억해" at the end of your activation request
- Re-run the activation command in a new session

**Wrong harness for your CLI?**
- Claude Code → use `omc` or `bmad`
- Codex CLI → use `omx` or `bmad`
- Gemini-CLI → use `ohmg` or `bmad`
- Any CLI → `bmad` always works universally
