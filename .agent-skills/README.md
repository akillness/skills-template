# Agent Skills Repository

Modular skill collection for AI agents. Works with Claude, Gemini, ChatGPT, and all AI platforms.

---

## Installation

### Using NPX (Recommended)

```bash
# Install all skills
npx skills add https://github.com/supercent-io/skills-template

# Install specific skills
npx skills add https://github.com/supercent-io/skills-template --skill api-design
npx skills add https://github.com/supercent-io/skills-template --skill code-review
npx skills add https://github.com/supercent-io/skills-template --skill ohmg
npx skills add https://github.com/supercent-io/skills-template --skill oh-my-codex
npx skills add https://github.com/supercent-io/skills-template --skill plannotator
```

### oh-my-ag MCP Setup

- Skill folder: `ohmg/`

### 🌟 Explore More Skills

**Want additional skills?** Check out **[Awesome Claude Skills](https://github.com/ComposioHQ/awesome-claude-skills)** - 100+ community skills for automation, development, and productivity!

```bash
# Install from Awesome Claude Skills
npx skills add https://github.com/ComposioHQ/awesome-claude-skills --skill github-automation
npx skills add https://github.com/ComposioHQ/awesome-claude-skills --skill slack-automation
```

### AI Agent Prompt

```
Copy the .agent-skills folder from the https://github.com/supercent-io/skills-template
repository to the current project.
```

---

## Folder Structure (Flat - Categories Removed)

```
.agent-skills/
├── README.md                      # This file
├── skill_loader.py                # Skill loader
├── skill-query-handler.py         # Natural language query handler
├── skills.json                    # Skill manifest (auto-generated)
├── skills.toon                    # TOON summary (auto-generated)
│
├── agent-configuration/           # All 67 skill folders at root level
├── api-design/
├── authentication-setup/
├── ... (all skills at same level)
│
└── templates/                     # Skill templates
    ├── toon-skill-template/       # TOON format (default)
    ├── basic-skill-template/
    └── advanced-skill-template/
```

> **v4.3.0 Changes**: Category folders removed, all skills flattened to root level

---

## Skills List (67 Total)

### Agent Development (7)
| Skill | Description |
|-------|-------------|
| `agent-configuration` | AI agent configuration & security policies |
| `agent-evaluation` | AI agent evaluation systems |
| `agentic-development-principles` | Universal agentic development principles |
| `agentic-principles` | Core AI agent collaboration principles |
| `agentic-workflow` | Practical AI agent workflows & productivity |
| `bmad-orchestrator` | BMAD workflow orchestration (Analysis → Planning → Solutioning → Implementation) |
| `prompt-repetition` | Prompt repetition for LLM accuracy |

### Backend (5)
| Skill | Description |
|-------|-------------|
| `api-design` | REST/GraphQL API design |
| `api-documentation` | API documentation generation |
| `authentication-setup` | Authentication & authorization setup |
| `backend-testing` | Backend testing strategies |
| `database-schema-design` | Database schema design |

### Frontend (7)
| Skill | Description |
|-------|-------------|
| `design-system` | Design system implementation |
| `react-best-practices` | React & Next.js best practices |
| `responsive-design` | Responsive web design |
| `state-management` | State management patterns |
| `ui-component-patterns` | UI component patterns |
| `web-accessibility` | Web accessibility (a11y) |
| `web-design-guidelines` | Web design guidelines |

### Code Quality (5)
| Skill | Description |
|-------|-------------|
| `code-refactoring` | Code refactoring strategies |
| `code-review` | Code review practices |
| `debugging` | Systematic debugging |
| `performance-optimization` | Performance optimization |
| `testing-strategies` | Testing strategies |

### Infrastructure (8)
| Skill | Description |
|-------|-------------|
| `deployment-automation` | CI/CD & deployment automation |
| `firebase-ai-logic` | Firebase AI Logic integration |
| `genkit` | Firebase Genkit AI workflows (flows, agents, RAG, streaming) |
| `looker-studio-bigquery` | Looker Studio + BigQuery |
| `monitoring-observability` | Monitoring & observability |
| `security-best-practices` | Security best practices |
| `system-environment-setup` | Environment configuration |
| `vercel-deploy` | Vercel deployment |

### Documentation (4)
| Skill | Description |
|-------|-------------|
| `changelog-maintenance` | Changelog management |
| `presentation-builder` | Presentation builder |
| `technical-writing` | Technical documentation |
| `user-guide-writing` | User guides & tutorials |

### Project Management (4)
| Skill | Description |
|-------|-------------|
| `sprint-retrospective` | Sprint retrospective facilitation |
| `standup-meeting` | Daily standup management |
| `task-estimation` | Task estimation techniques |
| `task-planning` | Task planning & organization |

### Search & Analysis (4)
| Skill | Description |
|-------|-------------|
| `codebase-search` | Codebase search & navigation |
| `data-analysis` | Data analysis & insights |
| `log-analysis` | Log analysis & debugging |
| `pattern-detection` | Pattern detection |

### Creative Media (3)
| Skill | Description |
|-------|-------------|
| `image-generation` | AI image generation (Gemini via MCP) |
| `pollinations-ai` | Free image generation via Pollinations.ai (no signup) |
| `video-production` | Video production workflows |

### Marketing (1)
| Skill | Description |
|-------|-------------|
| `marketing-automation` | Marketing automation |

### Utilities (19)
| Skill | Description |
|-------|-------------|
| `agent-browser` | Fast headless browser CLI for AI agents |
| `conductor-pattern` | Run AI agents in parallel git worktrees, compare PRs |
| `copilot-coding-agent` | GitHub Copilot Coding Agent — Issue → Draft PR automation |
| `environment-setup` | Environment setup |
| `file-organization` | File & folder organization |
| `git-submodule` | Git submodule management |
| `git-workflow` | Git workflow management |
| `mcp-codex` | MCP Codex integration |
| `npm-git-install` | Install npm from GitHub |
| `ohmg` | Multi-agent orchestration for Antigravity workflows |
| `oh-my-codex` | Multi-agent orchestration for OpenAI Codex CLI |
| `omc` | oh-my-claudecode — Teams-first multi-agent orchestration |
| `opencontext` | AI agent persistent memory |
| `planno` | Visual plan and diff review with Plannotator — annotate, approve, or request changes |
| `ralph` | Self-referential completion loop for multi-turn agents |
| `skill-standardization` | SKILL.md standardization |
| `vercel-deploy` | Vercel deployment |
| `vibe-kanban` | Kanban board for AI coding agents with git worktree automation |
| `workflow-automation` | Workflow automation |

---

## TOON Format (Default)

All skills use **TOON format** by default (95% token reduction).

| Mode | File | Avg Tokens | Reduction |
|:-----|:-----|:-----------|:----------|
| **full** | SKILL.md | ~2,118 | - |
| **toon** | SKILL.toon | ~111 | **94.7%** |

```bash
# Skill query (toon mode default)
python3 skill-query-handler.py query "API design"

# Specify full mode
python3 skill-query-handler.py query "API design" --mode full
```

---

## CLI Tools

### skill-query-handler.py

```bash
# List skills
python3 skill-query-handler.py list

# Match query
python3 skill-query-handler.py match "REST API"

# Generate prompt
python3 skill-query-handler.py query "API design"

# View statistics
python3 skill-query-handler.py stats
```

### skill_loader.py

```bash
# List skills
python3 skill_loader.py list

# Search skills
python3 skill_loader.py search "api"

# Show skill details
python3 skill_loader.py show api-design
```

---

## Adding New Skills

### 1. Copy Template

```bash
cp -r templates/toon-skill-template [skill-name]
```

### 2. Edit SKILL.toon

```
N:my-new-skill
D:Skill description in 2-3 sentences
G:keyword1 keyword2

U[3]:
  Use case 1
  Use case 2
  Use case 3

S[4]{n,action,details}:
  1,Analyze,Understand user request
  2,Plan,Create approach
  3,Execute,Implement step by step
  4,Verify,Confirm results

R[2]:
  Best practice 1
  Best practice 2
```

### 3. Update Manifest

```bash
python3 scripts/generate_compact_skills.py
```

---

## Explore More Skills

Looking for more AI agent skills?

**[Awesome Claude Skills](https://github.com/ComposioHQ/awesome-claude-skills)** offers 100+ community-created skills for exploration and installation.

```bash
# Search skills
npx skills search "code review"

# Install skills
npx skills add <skill-name>

# Browse: https://github.com/ComposioHQ/awesome-claude-skills
```

---

**Version**: 4.4.0 | **Updated**: 2026-02-20 | **Format**: TOON (Default) | **Structure**: Flat
