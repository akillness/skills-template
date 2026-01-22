# Agent Skills Repository

범용 AI 에이전트를 위한 Agent Skills 모음입니다. Claude, Gemini, Codex 등 모든 AI 플랫폼에서 사용 가능한 오픈 표준을 따릅니다.

---

## For AI Agents (LLM Setup)

> **AI 에이전트용 설정** - 아래 명령어 중 하나를 실행하세요.

### 방법 1: Interactive Setup

```bash
.agent-skills/setup.sh 실행하고 skill 설정해줘
```

### 방법 2: Non-Interactive Setup (권장)

```bash
cd .agent-skills && echo -e "1\n1\n" | bash setup.sh
```

### 방법 3: Direct Setup (스크립트 없이)

```bash
python3 .agent-skills/scripts/generate_compact_skills.py && \
mkdir -p ~/.claude/skills && \
cp -r .agent-skills/backend .agent-skills/frontend .agent-skills/code-quality \
      .agent-skills/infrastructure .agent-skills/documentation \
      .agent-skills/project-management .agent-skills/search-analysis \
      .agent-skills/utilities ~/.claude/skills/
```

| Agent Type | Setup Method |
|------------|--------------|
| **Claude Code** | `setup.sh` → 옵션 1 (Auto-configure) |
| **Gemini-CLI** | MCP 서버로 자동 통합 |
| **Codex-CLI** | MCP 서버로 자동 통합 |
| **ChatGPT** | `setup.sh` → 옵션 2 (Manual) → ChatGPT Knowledge Zip |

---

## 개요

Agent Skills는 AI 에이전트의 기능을 확장하는 모듈식 기능입니다. 각 Skill은 특정 작업을 수행하는 방법에 대한 지침, 스크립트, 참고 자료를 포함합니다.

**특징**:
- 📦 **모듈화**: 각 Skill은 독립적으로 작동
- 🔄 **재사용 가능**: 다양한 프로젝트에서 사용
- 🌐 **플랫폼 독립적**: Claude, Gemini, Codex 모두 지원
- 📝 **자체 문서화**: SKILL.md만 읽어도 이해 가능
- 🔍 **점진적 공개**: 필요할 때만 컨텍스트 로드
- 🤖 **멀티 에이전트 지원**: Claude + Gemini + Codex 오케스트레이션

## 폴더 구조

```
.agent-skills/
├── README.md                          # 이 파일
├── setup.sh                           # 설정 스크립트 (v3.4)
├── skill_loader.py                    # Python 스킬 로더
├── skill-query-handler.py             # MCP 쿼리 핸들러
├── scripts/                           # 유틸리티 스크립트
│   ├── generate_compact_skills.py     # 토큰 최적화
│   └── add_new_skill.sh               # 스킬 추가
├── backend/                           # 백엔드 스킬 (6)
│   ├── api-design/
│   ├── database-schema-design/
│   ├── authentication-setup/
│   ├── backend-testing/
│   ├── kling-ai/
│   └── cs-tool-dashboard/
├── frontend/                          # 프론트엔드 스킬 (5)
│   ├── ui-component-patterns/
│   ├── state-management/
│   ├── responsive-design/
│   ├── web-accessibility/
│   └── design-system/                 # NEW: 디자인 토큰, 레이아웃, 접근성
├── code-quality/                      # 코드 품질 스킬 (6)
│   ├── code-review/
│   ├── code-refactoring/
│   ├── testing-strategies/
│   ├── performance-optimization/
│   ├── debugging/
│   └── agent-evaluation/
├── infrastructure/                    # 인프라 스킬 (7)
│   ├── system-environment-setup/
│   ├── deployment-automation/
│   ├── monitoring-observability/
│   ├── security-best-practices/
│   ├── firebase-ai-logic/
│   ├── agent-configuration/
│   └── looker-studio-bigquery/
├── documentation/                     # 문서 스킬 (5)
│   ├── technical-writing/
│   ├── api-documentation/
│   ├── user-guide-writing/
│   ├── changelog-maintenance/
│   └── presentation-builder/          # NEW: PPTX 프레젠테이션 빌더
├── project-management/                # 프로젝트 관리 스킬 (7)
│   ├── task-planning/
│   ├── task-estimation/
│   ├── sprint-retrospective/
│   ├── standup-meeting/
│   ├── agent-workflow/
│   ├── subagent-creation/
│   └── agentic-principles/
├── search-analysis/                   # 검색/분석 스킬 (4)
│   ├── codebase-search/
│   ├── log-analysis/
│   ├── data-analysis/
│   └── pattern-detection/
├── creative-media/                    # NEW: 크리에이티브 미디어 스킬 (2)
│   ├── image-generation/              # MCP 기반 이미지 생성
│   └── video-production/              # Remotion 비디오 제작
├── marketing/                         # NEW: 마케팅 스킬 (1)
│   └── marketing-automation/          # 23개 마케팅 서브스킬
├── utilities/                         # 유틸리티 스킬 (14)
│   ├── git-workflow/
│   ├── git-submodule/
│   ├── environment-setup/
│   ├── file-organization/
│   ├── workflow-automation/
│   ├── skill-standardization/
│   ├── mcp-codex-integration/
│   ├── opencode-authentication/
│   ├── npm-git-install/
│   ├── agentic-development-principles/
│   ├── agentic-workflow/
│   ├── opencontext/
│   ├── project-init-memory/
│   └── prompt-repetition/
└── templates/                         # 스킬 템플릿 (3)
    ├── basic-skill-template/
    ├── advanced-skill-template/
    └── toon-skill-template/
```

## 사용 가능한 Skills (57개)

### Backend (6)
| Skill | Description |
|-------|-------------|
| `api-design` | REST/GraphQL API 설계 |
| `database-schema-design` | DB 스키마 설계 |
| `authentication-setup` | 인증/인가 구현 |
| `backend-testing` | 백엔드 테스트 전략 |
| `kling-ai` | Kling AI 비디오 생성 |
| `cs-tool-dashboard` | CS Tool 대시보드 |

### Frontend (5)
| Skill | Description |
|-------|-------------|
| `ui-component-patterns` | UI 컴포넌트 패턴 |
| `state-management` | 상태 관리 |
| `responsive-design` | 반응형 디자인 |
| `web-accessibility` | 웹 접근성 |
| `design-system` | **NEW** 디자인 토큰, 레이아웃, 접근성 |

### Code Quality (6)
| Skill | Description |
|-------|-------------|
| `code-review` | 코드 리뷰 |
| `code-refactoring` | 리팩토링 전략 |
| `testing-strategies` | 테스트 전략 |
| `performance-optimization` | 성능 최적화 |
| `debugging` | 디버깅 기법 |
| `agent-evaluation` | AI 에이전트 평가 |

### Infrastructure (7)
| Skill | Description |
|-------|-------------|
| `system-environment-setup` | 시스템 환경 설정 |
| `deployment-automation` | 배포 자동화 |
| `monitoring-observability` | 모니터링 설정 |
| `security-best-practices` | 보안 구성 |
| `firebase-ai-logic` | Firebase AI Logic |
| `agent-configuration` | AI 에이전트 설정 정책 |
| `looker-studio-bigquery` | Looker Studio + BigQuery |

### Documentation (5)
| Skill | Description |
|-------|-------------|
| `technical-writing` | 기술 문서 작성 |
| `api-documentation` | API 문서화 |
| `user-guide-writing` | 사용자 가이드 |
| `changelog-maintenance` | 변경 이력 관리 |
| `presentation-builder` | **NEW** PPTX 프레젠테이션 빌더 |

### Project Management (7)
| Skill | Description |
|-------|-------------|
| `task-planning` | 작업 계획 |
| `task-estimation` | 개발 시간 추정 |
| `sprint-retrospective` | 회고 진행 |
| `standup-meeting` | 스탠드업 준비 |
| `agent-workflow` | 멀티 에이전트 워크플로우 |
| `subagent-creation` | 서브에이전트 생성 |
| `agentic-principles` | AI 에이전트 협업 원칙 |

### Search & Analysis (4)
| Skill | Description |
|-------|-------------|
| `codebase-search` | 코드베이스 검색 |
| `log-analysis` | 로그 분석 |
| `data-analysis` | 데이터 분석 |
| `pattern-detection` | 패턴 감지 |

### Utilities (14)
| Skill | Description |
|-------|-------------|
| `git-workflow` | Git 워크플로우 |
| `git-submodule` | Git 서브모듈 관리 |
| `environment-setup` | 환경 설정 |
| `file-organization` | 파일 정리 |
| `workflow-automation` | 자동화 스크립트 |
| `skill-standardization` | 스킬 표준화 |
| `mcp-codex-integration` | MCP Codex 통합 |
| `opencode-authentication` | Opencode OAuth 인증 |
| `npm-git-install` | GitHub에서 npm 설치 |
| `agentic-development-principles` | 에이전틱 개발 원칙 |
| `agentic-workflow` | AI 에이전트 워크플로우 |
| `opencontext` | OpenContext 메모리 관리 |
| `project-init-memory` | 프로젝트 초기화 메모리 |
| `prompt-repetition` | 프롬프트 반복 감지 |

### Creative Media (2) - NEW
| Skill | Description |
|-------|-------------|
| `image-generation` | **NEW** MCP 기반 이미지 생성 (Gemini) |
| `video-production` | **NEW** Remotion 프로그래머블 비디오 |

### Marketing (1) - NEW
| Skill | Description |
|-------|-------------|
| `marketing-automation` | **NEW** 23개 마케팅 서브스킬 (CRO, SEO, 카피라이팅, 분석, 그로스) |

## Token Optimization

스킬 로딩 시 토큰 사용량을 최적화하는 3가지 모드:

| Mode | File | Avg Tokens | Reduction |
|:-----|:-----|:-----------|:----------|
| **full** | SKILL.md | ~2,118 | - |
| **compact** | SKILL.compact.md | ~243 | 88.5% |
| **toon** | SKILL.toon | ~111 | 94.7% |

```bash
# 토큰 최적화 실행
python3 scripts/generate_compact_skills.py

# 통계 확인
python3 skill-query-handler.py stats
```

## MCP Integration

### Workflow Types (Auto-Detected)

| Type | 조건 | 설명 |
|------|------|------|
| `standalone` | Claude CLI 없음 | 기본 스킬만 사용 |
| `claude-only` | Claude만 있음 | 내장 Bash 사용 |
| `claude-gemini` | +Gemini | 대용량 분석/리서치 |
| `claude-codex` | +Codex | 실행/배포 자동화 |
| `full-multiagent` | 모두 있음 | 풀 오케스트레이션 |

### Agent Roles

| Agent | Role | Best For |
|-------|------|----------|
| **Claude Code** | Orchestrator | 계획 수립, 코드 생성, 스킬 해석 |
| **Gemini-CLI** | Analyst | 대용량 분석 (1M+ 토큰), 리서치 |
| **Codex-CLI** | Executor | 명령 실행, 빌드, 배포 |

## CLI Tools

### skill-query-handler.py

```bash
# 스킬 목록
python3 skill-query-handler.py list

# 쿼리 매칭
python3 skill-query-handler.py match "REST API"

# 프롬프트 생성 (toon 모드 기본)
python3 skill-query-handler.py query "API 설계해줘"

# 모드 지정
python3 skill-query-handler.py query "API 설계해줘" --mode full
```

### skill_loader.py

```bash
# 스킬 목록
python3 skill_loader.py list

# 스킬 검색
python3 skill_loader.py search "api"

# 스킬 상세
python3 skill_loader.py show api-design
```

## 새 Skill 추가

```bash
# 자동 스킬 추가
./scripts/add_new_skill.sh <category> <skill-name>

# 예시
./scripts/add_new_skill.sh backend graphql-api --description "Design GraphQL APIs"
```

## 참고 자료

| Resource | Link |
|:---------|:-----|
| Agent Skills 공식 | [agentskills.io](https://agentskills.io/) |
| 사양 문서 | [Specification](https://agentskills.io/specification) |
| Claude Code Skills | [Documentation](https://docs.anthropic.com/en/docs/claude-code) |

---

**Version**: 3.5.0 | **Updated**: 2026-01-21 | **Skills**: 57
