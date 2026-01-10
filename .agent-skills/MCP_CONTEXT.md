# Agent Skills System for MCP (Model Context Protocol)

이 프로젝트는 Agent Skills 시스템을 사용합니다.
MCP 서버(gemini-cli, codex-cli 등)를 통해 작업할 때 이 문서를 참조하세요.

## 스킬 시스템 개요

각 스킬은 독립된 폴더에 다음 구조로 구성됩니다:
- **SKILL.md**: 스킬의 목적, 트리거 조건, 절차, 출력 포맷, 제약사항
- **지원 파일**: 템플릿, 예시, 참조 문서, 스크립트

## 스킬 로드 방법

### 방법 1: 직접 파일 읽기
```bash
# 특정 스킬 로드
cat .agent-skills/backend/api-design/SKILL.md

# 프롬프트와 함께 사용
gemini chat "$(cat .agent-skills/backend/api-design/SKILL.md)

사용자 관리 REST API를 설계해줘"
```

### 방법 2: Helper 스크립트 사용
```bash
# mcp-skill-loader.sh 사용
source .agent-skills/mcp-skill-loader.sh
load_skill backend/api-design

# 또는 직접 프롬프트에 포함
gemini chat "$(load_skill backend/api-design) 이제 설계해줘"
```

## 사용 가능한 스킬 카테고리

- **infrastructure/**: 인프라 설정 및 배포
- **backend/**: 백엔드 개발 및 API 설계
- **frontend/**: 프론트엔드 개발 및 UI/UX
- **documentation/**: 기술 문서 작성
- **code-quality/**: 코드 리뷰 및 품질 검사
- **search-analysis/**: 코드베이스 검색 및 분석
- **project-management/**: 프로젝트 관리 워크플로우
- **utilities/**: 유틸리티 및 헬퍼 도구

## 주요 스킬 목록

### Backend
- `backend/api-design`: REST/GraphQL API 설계

### Code Quality
- `code-quality/code-review`: 코드 리뷰 및 품질 검사

### Documentation
- `documentation/technical-writing`: 기술 문서 작성

### Search & Analysis
- `search-analysis/codebase-search`: 코드베이스 검색 및 분석

### Utilities
- `utilities/git-workflow`: Git 워크플로우 관리

## MCP 사용 패턴

### Gemini CLI 사용
```bash
# 1. 스킬 컨텍스트와 함께 질문
gemini chat "$(cat .agent-skills/MCP_CONTEXT.md)
$(cat .agent-skills/backend/api-design/SKILL.md)

이제 사용자 관리 API를 설계해줘"

# 2. 파일 첨부 방식
gemini chat --attach .agent-skills/backend/api-design/SKILL.md \
  "이 가이드라인을 따라 API를 설계해줘"
```

### Codex CLI 사용
```bash
# 스킬 컨텍스트 로드
codex-cli shell "$(cat .agent-skills/code-quality/code-review/SKILL.md)

이 코드를 리뷰해줘: $(cat src/app.ts)"
```

### Claude Code + MCP
```
"gemini-cli를 사용해서 .agent-skills/backend/api-design/SKILL.md의
가이드라인을 따라 사용자 관리 API를 설계해줘"
```

## 메타 규칙

- 스킬 지시사항을 일반 지식보다 우선시
- 여러 스킬이 적용 가능하면 가장 관련성 높은 것 선택
- 스킬 절차에서 요청되지 않은 정보는 추가하지 않음
- 보안 및 제약 규칙을 엄격히 준수

## 환경 설정

### Shell RC 파일에 추가 (~/.bashrc 또는 ~/.zshrc)
```bash
# Agent Skills 경로 설정
export AGENT_SKILLS_PATH="/path/to/.agent-skills"

# Helper 함수 로드
source "$AGENT_SKILLS_PATH/mcp-skill-loader.sh"
```

## 참고 문서

- MCP 설정 가이드: `.agent-skills/prompt/CLAUDE_MCP_GEMINI_CODEX_SETUP.md`
- Claude Skills 가이드: `.agent-skills/prompt/CLAUDE_SETUP_GUIDE.md`
- Gemini 설정: `.agent-skills/prompt/GEMINI_SETUP_PROMPT.md`
