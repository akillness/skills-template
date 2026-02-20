# Agent Skills

> Modular skill system for AI agents
> **66 Skills** | **TOON format default**

---

## Quick install

```bash
# Install all skills in this repo format
npx skills add https://github.com/supercent-io/skills-template

# Install one skill only
npx skills add https://github.com/supercent-io/skills-template --skill conductor-pattern
npx skills add https://github.com/supercent-io/skills-template --skill oh-my-codex
```

---

## Core usage for this repository

### 1) Installation check

```bash
python3 .agent-skills/skill_loader.py list
python3 .agent-skills/skill_query_handler.py query "REST API"
```

### 2) Parallel workflow (Conductor Pattern)

```bash
bash scripts/pipeline-check.sh --agents=claude,codex
bash scripts/conductor.sh <feature-name> <base-branch> <agent-list>
bash scripts/conductor-pr.sh <feature-name> <base-branch>
bash scripts/conductor-cleanup.sh <feature-name>
```

### 3) Full pipeline

```bash
bash scripts/pipeline.sh <feature-name> --stages check,conductor,pr
bash scripts/pipeline.sh <feature-name> --stages check,plan,conductor,pr --no-attach
bash scripts/pipeline.sh <feature-name> --dry-run
```

### 4) Copilot and Kanban integration

```bash
bash scripts/copilot-setup-workflow.sh
bash scripts/copilot-assign-issue.sh <issue-number>
bash scripts/vibe-kanban-start.sh --port 3001
```

---

## Repository focus

This repository is the local mirror of the `supercent-io/skills-template` skill collection with:

- `66` skills in `.agent-skills/`
- Flat skill layout (no category folders under `.agent-skills/`)
- Default TOON format for compact prompt output
- Helper docs and scripts for orchestration, planning, and PR workflow

---

## Orchestration keywords in this repo

| Keyword | Skill | Use case |
|---|---|---|
| `omc` | `omc` | oh-my-claudecode (Claude Code) |
| `ohmg` | `ohmg` | Gemini/Antigravity multi-agent orchestration |
| `omx` | `oh-my-codex` | Codex CLI multi-agent orchestration |
| `bmad` | `bmad-orchestrator` | Cross-platform BMAD phase workflow |
| `ralph` | `ralph` | Completion-loop for long tasks |
| `planno` | `plannotator` | Plan/diff review and approval workflow |
| `kanbanview` | `vibe-kanban` | Visual Kanban + conductor hooks |
| `copilotview` | `copilot-coding-agent` | GitHub Copilot issue-to-Draft-PR flow |

---

## Skills (66 total)

### Orchestration & Workflow
`agent-browser`, `agent-configuration`, `agent-evaluation`, `agentic-development-principles`, `agentic-principles`, `agentic-workflow`, `bmad`, `bmad-orchestrator`, `changelog-maintenance`, `conductor-pattern`, `copilot-coding-agent`, `environment-setup`, `file-organization`, `github-skill`, `git-submodule`, `git-workflow`, `opencontext`, `oh-my-codex`, `ohmg`, `omc`, `plannotator`, `prompt-repetition`, `ralph`, `skill-standardization`, `vibe-kanban`, `workflow-automation`
`agent-browser`, `agent-configuration`, `agent-evaluation`, `agentic-development-principles`, `agentic-principles`, `agentic-workflow`, `bmad`, `bmad-orchestrator`, `changelog-maintenance`, `conductor-pattern`, `copilot-coding-agent`, `environment-setup`, `file-organization`, `git-submodule`, `git-workflow`, `opencontext`, `oh-my-codex`, `ohmg`, `omc`, `plannotator`, `prompt-repetition`, `ralph`, `skill-standardization`, `vibe-kanban`, `workflow-automation`

### API / Backend
`api-design`, `api-documentation`, `authentication-setup`, `backend-testing`, `database-schema-design`

### Frontend
`design-system`, `react-best-practices`, `responsive-design`, `state-management`, `ui-component-patterns`, `web-accessibility`, `web-design-guidelines`

### Code Quality
`code-refactoring`, `code-review`, `debugging`, `performance-optimization`, `testing-strategies`

### Search & Analysis
`codebase-search`, `data-analysis`, `log-analysis`, `pattern-detection`

### Documentation
`presentation-builder`, `technical-writing`, `user-guide-writing`

### Project management / operations
`sprint-retrospective`, `standup-meeting`, `task-estimation`, `task-planning`

### Infrastructure
`deployment-automation`, `firebase-ai-logic`, `genkit`, `looker-studio-bigquery`, `monitoring-observability`, `security-best-practices`, `system-environment-setup`, `vercel-deploy`

### Creative
`image-generation`, `pollinations-ai`, `video-production`, `marketing-automation`

> Full list and descriptions are available in `https://github.com/akillness/skills-template` and the individual skill READMEs under `.agent-skills/`.

---

## TOON format

All skills are authored in TOON format as default to reduce prompt cost:

```text
N:skill-name
D:Description
G:keyword1 keyword2
U[5]:Use cases
S[4]{n,action,details}:Steps
R[5]:Rules
E[2]{desc,in,out}:Examples
```

| File | Avg tokens | Reduction |
|---|---|---|
| `SKILL.md` | ~2,100 | - |
| `SKILL.toon` | ~111 | ~95% |

---

## Architecture

```text
.
├── .agent-skills/
│   ├── README.md
│   ├── skill_loader.py
│   ├── skill-query-handler.py
│   ├── skills.json
│   ├── skills.toon
│   └── [66 skill folders]
├── docs/
│   ├── installation.md
│   ├── usage-guide.md
│   └── script-reference.md
├── scripts/
├── .agent-skills (templates / docs / manifest)
└── README.md (this file)
```

---

## Related docs

- [Installation guide](docs/installation.md)
- [Usage guide](docs/usage-guide.md)
- [Script reference](docs/script-reference.md)
- [Conductor Pattern docs](docs/conductor-pattern/README.md)
- [Ralph loop docs](docs/ralph/README.md)
- [Vibe Kanban docs](docs/vibe-kanban/README.md)
- [Copilot coding agent docs](docs/copilot-coding-agent/README.md)

---

**Version**: Local repository sync | **Updated**: 2026-02-20 | **Format**: TOON default
