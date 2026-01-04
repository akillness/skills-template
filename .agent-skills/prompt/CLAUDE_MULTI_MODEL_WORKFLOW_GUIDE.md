# Claude Code 멀티 모델 워크플로우 완벽 가이드

> Gemini CLI와 Codex CLI를 활용한 정밀하고 정확한 Claude Code 사용법

**작성일**: 2026-01-04
**AI 분석 기반**: Gemini 2.5 Pro, Codex GPT-5.2

---

## 목차

1. [개요](#개요)
2. [멀티 모델 전략: 각 모델의 강점](#멀티-모델-전략-각-모델의-강점)
3. [작업 라우팅 전략](#작업-라우팅-전략)
4. [컨텍스트 관리 최적화](#컨텍스트-관리-최적화)
5. [정밀도와 정확도 향상 기법](#정밀도와-정확도-향상-기법)
6. [CLAUDE.md 설정 방법](#claudemd-설정-방법)
7. [Custom Commands 활용](#custom-commands-활용)
8. [Skills 시스템 활용](#skills-시스템-활용)
9. [실전 워크플로우 예시](#실전-워크플로우-예시)
10. [성능 최적화 및 비용 관리](#성능-최적화-및-비용-관리)

---

## 개요

Claude Code는 MCP(Model Context Protocol)를 통해 Gemini와 Codex를 통합하여 각 모델의 강점을 활용하는 **멀티 모델 오케스트레이션**이 가능합니다. 이 가이드는 Gemini CLI와 Codex CLI로부터 수집한 실제 베스트 프랙티스를 기반으로 작성되었습니다.

### 핵심 철학

> **"최적의 도구를 최적의 작업에"**
> 하나의 마스터 모델이 작업을 분석하고, 각 하위 작업을 가장 적합한 모델에게 위임한 뒤 결과를 통합합니다.

### 설치된 MCP 서버 확인

```bash
claude mcp list
```

**예상 출력**:
```
gemini-cli: npx -y gemini-mcp-tool - ✓ Connected
codex-cli: npx -y @openai/codex-shell-tool-mcp - ✓ Connected
```

---

## 멀티 모델 전략: 각 모델의 강점

### 1. Claude (Sonnet 4.5 / Opus 4.5)

**강점**:
- 복잡한 추론과 깊이 있는 분석
- 구조화된 장문의 문서 작성
- 코드 리뷰 및 아키텍처 설계
- 일관된 코딩 스타일 유지

**적합한 작업**:
- 프로젝트 아키텍처 설계
- 코드 리뷰 및 보안 분석
- 기술 문서 작성
- 복잡한 리팩토링 계획 수립

**사용 예시**:
```
"이 프로젝트의 아키텍처를 분석하고 개선 방안을 제안해줘"
"이 PR의 보안 취약점을 검토해줘"
"데이터베이스 마이그레이션 전략을 설계해줘"
```

---

### 2. Gemini (2.5 Pro / 2.0 Flash)

**강점**:
- **초대용량 컨텍스트**: 1M+ 토큰 처리 가능
- 멀티모달 분석 (이미지, 동영상)
- Google 검색 통합
- 빠른 요약 및 분류

**적합한 작업**:
- 대용량 코드베이스 전체 분석
- 여러 파일에 걸친 종속성 추적
- UI/UX 아이디어 브레인스토밍
- 경쟁사 분석 (영상/이미지 포함)

**사용 예시**:
```
"gemini-cli를 사용해서 이 프로젝트 전체 아키텍처를 분석해줘"
"gemini-cli로 이 대용량 로그 파일에서 에러 패턴을 찾아줘"
"gemini-cli를 활용해서 이 UI 디자인 이미지를 분석해줘"
```

---

### 3. Codex (GPT-5.2 Codex)

**강점**:
- **빠른 코드 생성 및 수정**
- 정확한 diff 생성
- Repository-aware 코드 편집
- 자동화된 테스트 생성

**적합한 작업**:
- 코드 구현 및 리팩토링
- 버그 수정
- 유닛 테스트 작성
- 빠른 프로토타이핑

**사용 예시**:
```
"codex-cli를 사용해서 이 함수를 리팩토링해줘"
"codex-cli로 이 모듈의 유닛 테스트를 작성해줘"
"codex-cli를 활용해서 이 버그를 수정해줘"
```

---

## 작업 라우팅 전략

### 작업 유형별 모델 선택 매트릭스

| 작업 유형 | 1순위 모델 | 2순위 모델 | 이유 |
|----------|----------|----------|------|
| **대용량 코드 분석** | Gemini 2.5 Pro | Claude Opus | 1M+ 토큰 컨텍스트 |
| **빠른 코드 생성** | Codex | Claude Sonnet | 속도와 정확도 |
| **복잡한 추론** | Claude Opus | Gemini Pro | 깊은 분석 능력 |
| **코드 리뷰** | Claude + Gemini | - | 상호 검증 |
| **UI/UX 아이디어** | Gemini | Claude | 창의적 탐색 |
| **버그 수정** | Codex | Claude | 빠른 diff 생성 |
| **테스트 작성** | Codex | Claude | 자동화 |
| **문서 작성** | Claude Opus | Gemini | 구조화된 글쓰기 |
| **API 설계** | Claude | Gemini | 아키텍처 설계 |
| **성능 최적화** | Claude | Codex | 분석 후 구현 |

### 라우팅 패턴

#### 1. Router Pass Pattern (라우터 패스)

작업 유형에 따라 초기에 적절한 모델을 선택:

```
사용자 요청 → Claude (라우터) 분석 → 작업 분류 → 최적 모델 선택
```

**예시**:
```
요청: "로그인 기능 구현"
→ Claude 분석: "API 설계 + 코드 구현 + 테스트"
→ Claude (API 설계) → Codex (코드 구현) → Codex (테스트 작성)
```

#### 2. Specialist-Then-Finisher Pattern

한 모델이 탐색하고, 다른 모델이 정제:

```
Gemini (아이디어 탐색) → Claude (설계 정제) → Codex (구현)
```

**예시**:
```
"새로운 결제 시스템 설계"
→ Gemini: 여러 결제 옵션 브레인스토밍
→ Claude: 최적 아키텍처 설계
→ Codex: 코드 구현
```

#### 3. Risk-Based Routing

위험도에 따른 이중 검증:

```
고위험 작업 → 1차 모델 실행 → 2차 모델 검증 → 병합
```

**예시**:
```
"보안 인증 모듈 수정"
→ Codex: 코드 수정
→ Claude: 보안 검토 및 취약점 분석
→ 승인 후 병합
```

#### 4. Modality-Based Routing

작업 특성에 따른 분배:

- **아이디어/UI**: Gemini
- **분석/설계**: Claude
- **구현/테스트**: Codex

---

## 컨텍스트 관리 최적화

### 1. 공유 작업 브리프 (Shared Task Brief)

모든 모델에 동일한 핵심 정보를 제공:

**템플릿**:
```markdown
## 작업 브리프

**목표**: [명확한 목표]
**제약사항**: [기술 스택, 라이브러리 제한, 성능 요구사항]
**정의**: [주요 용어 정의]
**수용 기준**: [완료 조건]

## 컨텍스트
- 현재 상태: [현재 코드/시스템 상태]
- 변경 범위: [영향받는 파일/모듈]
```

### 2. 최소 컨텍스트 원칙

필요한 최소한의 정보만 제공:

**좋은 예시**:
```
"src/auth/login.ts의 validatePassword 함수에서
특수문자 검증 로직을 추가해줘.
현재 코드는 숫자와 문자만 검증 중."
```

**나쁜 예시**:
```
"로그인 시스템 전체를 보고 패스워드 검증을 개선해줘."
(불필요하게 넓은 범위)
```

### 3. 의사결정 로그 유지

모델 간 작업 전환 시 결정사항을 기록:

**예시**:
```markdown
## 의사결정 로그

- [Claude] API는 RESTful 설계, JWT 토큰 사용 결정
- [Gemini] 3가지 UI 옵션 중 옵션 B 선택 (접근성 우수)
- [Codex] 구현 시 bcrypt 라이브러리 사용
```

### 4. 컨텍스트 드리프트 방지

모델이 추측하기 시작하면 즉시 컨텍스트 재설정:

**신호**:
- "아마도...", "추정하건대..." 등의 표현
- 요청하지 않은 기능 추가
- 프로젝트 규칙 무시

**대응**:
```
"잠깐, 다시 정리해줘.
요구사항: [명확한 범위]
제약사항: [명확한 제한]"
```

---

## 정밀도와 정확도 향상 기법

### 1. 가정 명시 요구

작업 시작 전 모델에게 가정을 명시하도록 요청:

**프롬프트 패턴**:
```
"작업을 시작하기 전에:
1. 현재 코드에 대한 당신의 가정을 나열해줘
2. 확인이 필요한 엣지 케이스를 3가지 제시해줘
3. 가정이 틀릴 경우의 대안을 제시해줘"
```

### 2. 검증 가능한 출력 형식

테스트 가능한 형태로 출력 요구:

**좋은 예시**:
```
"변경사항을 git diff 형식으로 제공해줘"
"실행 가능한 테스트 케이스를 포함해줘"
"변경사항 체크리스트를 마크다운으로 작성해줘"
```

### 3. 교차 모델 검증

중요한 작업은 두 모델로 검증:

**워크플로우**:
```
1. Codex로 코드 작성
2. Claude에게: "이 코드의 잠재적 위험을 분석해줘"
3. Gemini에게: "이 코드의 성능 이슈를 검토해줘"
4. 피드백 통합 후 최종 수정
```

### 4. 범위 제약

명확한 경계 설정:

**제약 패턴**:
```
"다음 조건을 엄격히 준수해줘:
- auth.ts 파일만 수정
- 새로운 의존성 추가 금지
- 테스트 포함 필수, 없으면 이유 설명
- 기존 API 시그니처 유지"
```

### 5. 단계별 검증

복잡한 작업을 단계별로 나누고 각 단계 검증:

**예시**:
```
1단계: "먼저 현재 코드를 읽고 이해한 내용을 요약해줘"
→ 검증: 이해가 맞는지 확인
2단계: "변경 계획을 3단계로 나눠 설명해줘"
→ 검증: 계획이 적절한지 확인
3단계: "1단계 변경만 구현해줘"
→ 검증: 테스트 후 다음 단계 진행
```

---

## CLAUDE.md 설정 방법

`CLAUDE.md`는 프로젝트의 **헌법**입니다. 프로젝트 루트에 위치하며 Claude가 항상 참조합니다.

### React/TypeScript 프로젝트 예시

```markdown
# CLAUDE.md — React/TypeScript

## Project Context
- Framework: React + Vite + TypeScript
- Styling: TailwindCSS
- State: React Query + Zustand
- Testing: Vitest + React Testing Library

## Workflow
- Prefer small, focused PR-sized changes.
- Do not change build config unless requested.
- Preserve existing design system tokens and utility classes.

## Accuracy Directives
- Always read relevant component files before editing.
- If props types are uncertain, locate their definitions and confirm.
- Avoid implicit any; keep TS strictness intact.
- When adding UI, check existing components for reuse.

## Multi-Model Workflow (Gemini + Codex)
- **Gemini**: use for UI copy variants, layout suggestions, and edge case brainstorming.
- **Codex**: implement changes, refactors, and tests.
- **Conflict resolution**: If outputs disagree, trust local code + tests; reconcile by inspecting actual types and runtime behavior.

## Quality Gates
- Add or update tests for user-visible behavior changes.
- Ensure components remain accessible (aria labels, keyboard navigation).
- Run `pnpm test` and `pnpm lint` if possible; otherwise note gaps.

## Output Expectations
- Provide a brief change summary and list files touched.
- Call out any assumptions about data contracts.
```

### Python/FastAPI 프로젝트 예시

```markdown
# CLAUDE.md — Python/FastAPI

## Project Context
- Framework: FastAPI
- ORM: SQLAlchemy
- Validation: Pydantic v2
- Testing: Pytest

## Workflow
- Keep API behavior backward compatible unless explicitly requested.
- Prefer dependency injection over global state.
- Avoid heavy migrations without approval.

## Accuracy Directives
- Before changing endpoints, read router, schema, and service layers.
- Match existing status codes and error formats.
- Use Pydantic models for all request/response bodies.
- Confirm async vs sync boundaries before refactors.

## Multi-Model Workflow (Gemini + Codex)
- **Gemini**: use to draft edge cases and coverage ideas.
- **Codex**: implement code, type updates, and tests.
- **Conflict resolution**: Resolve conflicts by consulting actual ORM models and schema definitions.

## Quality Gates
- Update tests for routes/services touched.
- Add `response_model` annotations for new endpoints.
- Validate error handling paths with explicit tests.

## Output Expectations
- Summarize API changes and any migration needs.
- Note if test execution was skipped and why.
```

### Go 프로젝트 예시

```markdown
# CLAUDE.md — Go

## Project Context
- Go version: 1.22
- Build: Makefile + golangci-lint
- Testing: go test ./...

## Workflow
- Keep packages small; avoid circular deps.
- Do not introduce new dependencies without approval.
- Prefer table-driven tests.

## Accuracy Directives
- Read interfaces and constructors before implementing new behavior.
- Match existing error wrapping patterns (`fmt.Errorf("...: %w", err)`).
- Maintain context propagation (`context.Context`) where applicable.

## Multi-Model Workflow (Gemini + Codex)
- **Gemini**: use for API surface review and error case enumeration.
- **Codex**: implement code changes and tests.
- **Conflict resolution**: If suggested behavior conflicts, verify in actual handlers and interfaces.

## Quality Gates
- Run `go test ./...` and `golangci-lint run` if possible.
- Add tests for new public functions and CLI flags.
- Ensure deterministic output for CLI commands.

## Output Expectations
- List packages touched and any new flags or config changes.
```

### 핵심 섹션 설명

| 섹션 | 목적 | 예시 |
|------|------|------|
| **Project Context** | 기술 스택 명시 | "Node.js 20, Express, MongoDB" |
| **Workflow** | 작업 방식 규칙 | "작은 PR 선호, 빌드 설정 변경 금지" |
| **Accuracy Directives** | 정확도 향상 규칙 | "수정 전 반드시 파일 읽기" |
| **Multi-Model Workflow** | 모델 역할 분담 | "Gemini: 분석, Codex: 구현" |
| **Quality Gates** | 품질 기준 | "테스트 포함 필수" |
| **Output Expectations** | 출력 형식 | "변경 요약 + 파일 목록" |

---

## Custom Commands 활용

`.claude/commands` 디렉토리에 자주 사용하는 작업을 명령어로 등록합니다.

### 구조

```
.claude/
└── commands/
    ├── test-coverage.sh        # 실행 스크립트
    ├── test-coverage.prompt    # 사용 시점 설명
    ├── deploy-staging.sh
    └── deploy-staging.prompt
```

### 예시 1: 테스트 커버리지 확인

**.claude/commands/coverage.sh**:
```bash
#!/bin/bash

echo "Running tests and generating coverage profile..."
go test ./... -coverprofile=coverage.out

if [ $? -eq 0 ]; then
    echo "Tests passed! Opening coverage report..."
    go tool cover -html=coverage.out
else
    echo "Tests failed. Please fix errors before checking coverage."
    exit 1
fi
```

**.claude/commands/coverage.prompt**:
```markdown
Command: coverage
When to use: 사용자가 코드 테스트 커버리지를 확인하고 싶어할 때,
테스트가 얼마나 잘 작성되었는지 시각적으로 보고 싶어할 때 사용하세요.
'커버리지 보여줘', '테스트 커버리지 확인해줘' 등의 요청에 응답합니다.

Description: 모든 Go 테스트를 실행하고, 그 결과를 coverage.out 파일에 저장한 뒤,
HTML 형태의 시각적인 커버리지 리포트를 생성하여 브라우저에서 열어줍니다.
```

### 예시 2: 스테이징 배포

**.claude/commands/deploy-staging.sh**:
```bash
#!/bin/bash

echo "Deploying to staging environment..."

# 최신 변경사항 확인
if ! git diff-index --quiet HEAD --; then
    echo "Error: You have uncommitted changes. Please commit or stash them first."
    exit 1
fi

# 스테이징 브랜치로 전환 및 병합
git checkout staging
git pull origin staging
git merge main

# 배포 실행
docker-compose -f docker-compose.staging.yml up -d --build

echo "Staging deployment complete!"
echo "URL: https://staging.example.com"
```

**.claude/commands/deploy-staging.prompt**:
```markdown
Command: deploy-staging
When to use: 사용자가 스테이징 환경에 배포하고 싶어할 때 사용하세요.
'스테이징 배포해줘', '테스트 서버에 올려줘' 등의 요청에 응답합니다.

Description: Git 상태를 확인하고, staging 브랜치로 최신 main을 병합한 뒤,
Docker Compose를 사용하여 스테이징 환경에 배포합니다.
```

### 사용 방법

설정 후 자연어로 요청:

```
"코드 커버리지 확인해줘"
→ Claude가 coverage.prompt를 읽고 coverage.sh 자동 실행

"스테이징에 배포해줘"
→ Claude가 deploy-staging.sh 자동 실행
```

---

## Skills 시스템 활용

Skills는 복잡한 작업의 절차와 모범 사례를 문서화한 지식 베이스입니다.

### 설치된 Skills 확인

```bash
find ~/.claude/skills -name "SKILL.md" -o -name "SKILL.toon" | wc -l
# 출력: 30
```

### Skills 카테고리

현재 설치된 30개 스킬:

| 카테고리 | 스킬 수 | 주요 스킬 |
|---------|---------|----------|
| **Backend** | 5 | api-design, authentication-setup, database-schema-design |
| **Frontend** | 4 | responsive-design, state-management, ui-component-patterns |
| **Code Quality** | 4 | code-refactoring, code-review, performance-optimization |
| **Infrastructure** | 4 | deployment-automation, security-best-practices |
| **Documentation** | 4 | api-documentation, technical-writing |
| **Project Management** | 4 | task-planning, sprint-retrospective |
| **Search & Analysis** | 1 | codebase-search |
| **Utilities** | 4 | git-workflow, environment-setup |

### Skill 예시: API 설계

**~/.claude/skills/backend/api-design/SKILL.md**:

```markdown
# Skill: RESTful API 설계

## 목적
일관되고 확장 가능한 RESTful API 엔드포인트를 설계합니다.

## 절차

### 1. 리소스 식별
- 도메인 모델에서 핵심 엔티티 파악
- 각 엔티티를 RESTful 리소스로 매핑
- 리소스 간 관계 정의 (1:1, 1:N, N:M)

### 2. URL 구조 설계
- 명사 사용 (동사 금지): `/users` ✓, `/getUsers` ✗
- 계층 구조 표현: `/users/{id}/orders`
- 복수형 사용: `/products`, `/categories`

### 3. HTTP 메서드 매핑
- `GET`: 조회 (리스트, 단일)
- `POST`: 생성
- `PUT`: 전체 수정
- `PATCH`: 부분 수정
- `DELETE`: 삭제

### 4. 상태 코드 정의
- `200 OK`: 성공
- `201 Created`: 생성 성공
- `204 No Content`: 삭제 성공
- `400 Bad Request`: 요청 오류
- `401 Unauthorized`: 인증 실패
- `403 Forbidden`: 권한 없음
- `404 Not Found`: 리소스 없음
- `500 Internal Server Error`: 서버 오류

### 5. 응답 형식 표준화
```json
{
  "data": { ... },
  "error": null,
  "meta": {
    "timestamp": "2026-01-04T12:00:00Z",
    "version": "v1"
  }
}
```

## 멀티 모델 활용

### Gemini 활용
- 여러 API 설계 패턴 비교 분석
- 유사 서비스 API 구조 벤치마킹
- 엣지 케이스 브레인스토밍

### Claude 활용
- 최종 API 스펙 문서 작성
- 보안 요구사항 분석
- API 버전 관리 전략 수립

### Codex 활용
- OpenAPI/Swagger 스펙 자동 생성
- 샘플 코드 및 테스트 작성
- API 클라이언트 라이브러리 생성

## 체크리스트

- [ ] 리소스 URL이 명사로 구성되었는가?
- [ ] HTTP 메서드가 적절히 사용되었는가?
- [ ] 에러 응답 형식이 일관되는가?
- [ ] 페이지네이션이 필요한 엔드포인트에 구현되었는가?
- [ ] API 문서(OpenAPI)가 작성되었는가?
- [ ] 인증/인가 방식이 정의되었는가?
```

### Skill 사용 방법

자연어로 요청하면 자동 활성화:

```
"사용자 관리를 위한 REST API를 설계해줘"
→ Claude가 api-design skill을 참조하여 단계별로 진행

"이 컴포넌트를 반응형으로 만들어줘"
→ responsive-design skill 활성화

"데이터베이스 스키마를 설계해줘"
→ database-schema-design skill 활성화
```

---

## 실전 워크플로우 예시

### 예시 1: 버그 수정 워크플로우

**시나리오**: 로그인 API에서 특정 상황에 500 에러 발생

**단계별 진행**:

```
1. [Claude] 근본 원인 분석
   요청: "로그인 API 에러 로그를 분석하고 근본 원인을 파악해줘"
   → Claude가 로그를 읽고 문제 원인 분석
   결과: "비밀번호가 null일 때 bcrypt 라이브러리에서 예외 발생"

2. [Gemini] 수정 옵션 제안
   요청: "gemini-cli를 사용해서 이 문제의 3가지 해결 방안을 제시해줘"
   → Gemini가 여러 옵션 제안
   결과:
   - 옵션 A: null 체크 추가
   - 옵션 B: Pydantic validation 강화
   - 옵션 C: 미들웨어에서 사전 검증

3. [사용자] 옵션 선택
   선택: "옵션 B로 진행해줘 (Pydantic validation)"

4. [Codex] 코드 수정 및 테스트 작성
   요청: "codex-cli를 사용해서 Pydantic 모델을 강화하고 테스트를 작성해줘"
   → Codex가 코드 수정 및 테스트 생성

5. [Claude] 회귀 테스트 검토
   요청: "이 변경사항이 다른 부분에 영향을 주는지 검토해줘"
   → Claude가 영향 범위 분석

6. [실행] 테스트 및 배포
   요청: "테스트를 실행하고 통과하면 스테이징에 배포해줘"
   → Custom command 실행
```

---

### 예시 2: 신규 기능 개발 워크플로우

**시나리오**: 전자상거래 사이트에 결제 시스템 추가

**단계별 진행**:

```
1. [Gemini] UI/UX 아이디어 브레인스토밍
   요청: "gemini-cli를 사용해서 결제 UI의 3가지 레이아웃 옵션을 제안해줘"
   → Gemini가 여러 디자인 패턴 제안

2. [Claude] API 및 데이터 모델 설계
   요청: "결제 시스템의 API 엔드포인트와 데이터베이스 스키마를 설계해줘"
   → Claude가 API 설계 skill을 활용하여 설계
   → Claude가 database-schema-design skill로 스키마 작성

3. [Codex] 백엔드 구현
   요청: "codex-cli를 사용해서 결제 API를 구현하고 테스트를 작성해줘"
   → Codex가 코드 생성 및 테스트 작성

4. [Codex] 프론트엔드 연동
   요청: "codex-cli로 결제 UI 컴포넌트를 구현해줘"
   → Codex가 React 컴포넌트 생성

5. [Gemini] 릴리스 노트 작성
   요청: "gemini-cli를 활용해서 이 기능의 릴리스 노트를 작성해줘"
   → Gemini가 사용자 친화적인 릴리스 노트 작성
```

---

### 예시 3: 대규모 리팩토링 워크플로우

**시나리오**: 레거시 모놀리식 앱을 마이크로서비스로 전환

**단계별 진행**:

```
1. [Gemini] 전체 코드베이스 분석
   요청: "gemini-cli를 사용해서 이 프로젝트의 전체 구조와
          모듈 간 의존성을 분석해줘 (1M+ 토큰 활용)"
   → Gemini가 대용량 코드베이스 분석

2. [Claude] 안전한 리팩토링 계획 수립
   요청: "마이크로서비스 전환을 위한 단계별 계획을 수립해줘.
          각 단계는 독립적으로 배포 가능해야 해"
   → Claude가 상세 계획 작성

3. [사용자] 우선순위 설정
   "1단계부터 진행해줘: 인증 서비스 분리"

4. [Codex] 작은 커밋으로 실행
   요청: "codex-cli를 사용해서 인증 모듈을 별도 서비스로 분리해줘.
          작은 커밋 단위로 진행해줘"
   → Codex가 단계별 커밋 생성

5. [Claude] 회귀 테스트 및 문서 업데이트
   요청: "변경사항이 기존 기능에 영향을 주는지 확인하고
          아키텍처 문서를 업데이트해줘"
   → Claude가 검증 및 문서화
```

---

### 예시 4: 보안 취약점 수정 워크플로우

**시나리오**: 보안 스캔에서 SQL Injection 취약점 발견

**단계별 진행**:

```
1. [Claude] 취약점 심층 분석
   요청: "이 보안 리포트를 분석하고 영향 범위를 파악해줘"
   → Claude가 보안 분석 skill 활용

2. [Gemini] 공격 시나리오 시뮬레이션
   요청: "gemini-cli를 사용해서 가능한 공격 시나리오를 3가지 제시해줘"
   → Gemini가 엣지 케이스 분석

3. [Codex] 수정 사항 구현
   요청: "codex-cli를 사용해서 prepared statement로 변경하고
          입력 검증을 추가해줘"
   → Codex가 코드 수정

4. [Claude + Codex] 교차 검증
   요청 1: "이 수정사항에 다른 취약점이 있는지 Claude가 검토해줘"
   요청 2: "codex-cli를 사용해서 보안 테스트 케이스를 작성해줘"

5. [Claude] 보안 가이드 업데이트
   요청: "이 사례를 바탕으로 팀 보안 가이드를 업데이트해줘"
   → Claude가 문서화
```

---

## 성능 최적화 및 비용 관리

### 토큰 사용 최적화

#### 1. 작업별 모델 선택

| 복잡도 | 모델 | 비용 효율 |
|--------|------|-----------|
| **간단** (포맷팅, 문서화) | Gemini Flash | ⭐⭐⭐⭐⭐ |
| **중간** (코드 리뷰, 버그) | Codex | ⭐⭐⭐⭐ |
| **복잡** (대용량 분석) | Gemini Pro | ⭐⭐⭐ |
| **매우 복잡** (설계, 추론) | Claude Opus | ⭐⭐ |

#### 2. 컨텍스트 캐싱

유사한 쿼리는 캐시 활용:

```
Best Practice:
- 공통 컨텍스트(CLAUDE.md, package.json)는 세션 초반에 로드
- 반복적인 파일 읽기 최소화
- 변경사항만 업데이트
```

#### 3. Rate Limiting

API 호출 간 적절한 지연:

```python
# 예시: Python에서 rate limiting
import time

def call_gemini_with_rate_limit(prompt):
    time.sleep(1)  # 1초 대기
    return gemini.query(prompt)
```

### 에러 핸들링

#### Gemini 실패 시 대응

```bash
# Gemini API 에러 발생 시
gemini auth login  # 재인증
gemini --version   # 버전 확인

# MCP 서버 재시작
claude mcp remove gemini-cli
claude mcp add gemini-cli -s user -- npx -y gemini-mcp-tool
```

#### Codex 실패 시 대응

```bash
# Codex 인증 문제 시
codex auth login

# Git 저장소 체크 무시
codex exec --skip-git-repo-check "..."
```

### 모니터링 및 로깅

#### 세션 추적

```bash
# Gemini 세션 목록
gemini --list-sessions

# Codex 세션 재개
codex resume --last
```

#### 에러 로그 확인

```bash
# Gemini 에러 로그 위치
ls -la /var/folders/*/T/gemini-client-error-*.json

# Claude MCP 상태 확인
claude mcp list
```

---

## 부록: 빠른 참조 가이드

### 주요 명령어 치트시트

```bash
# MCP 서버 관리
claude mcp list                    # MCP 서버 목록
claude mcp add <name> -s user ...  # MCP 서버 추가
claude mcp remove <name>           # MCP 서버 제거

# Gemini CLI
gemini "prompt"                    # 일반 쿼리
gemini "prompt" -m gemini-2.5-pro  # 모델 지정
gemini --list-sessions             # 세션 목록
gemini -r latest                   # 최근 세션 재개

# Codex CLI
codex exec "prompt"                # 비대화형 실행
codex "prompt"                     # 대화형 실행
codex resume --last                # 마지막 세션 재개
codex --skip-git-repo-check        # Git 체크 무시

# Skills 관리
find ~/.claude/skills -name "SKILL.md"  # 스킬 목록
ls ~/.claude/skills/                    # 카테고리 확인
```

### 프롬프트 패턴 템플릿

#### 멀티 모델 협업 요청

```
"다음 순서로 진행해줘:
1. gemini-cli로 [분석 작업]
2. 결과를 바탕으로 Claude가 [설계 작업]
3. codex-cli로 [구현 작업]
4. Claude가 최종 [검증 작업]"
```

#### 교차 검증 요청

```
"codex-cli로 코드를 작성한 후,
Claude가 보안 취약점을 검토해줘.
문제가 있으면 codex-cli로 수정해줘."
```

#### 조건부 실행 요청

```
"테스트를 실행하고:
- 통과하면: 스테이징에 배포
- 실패하면: 에러 로그를 분석하고 수정 방안 제시"
```

---

## 참고 자료

### 공식 문서

- [Claude Code 공식 문서](https://code.claude.com/docs)
- [MCP 프로토콜 스펙](https://www.anthropic.com/news/model-context-protocol)
- [Gemini CLI 가이드](https://ai.google.dev/gemini-api/docs/cli)
- [OpenAI Codex 문서](https://platform.openai.com/docs/guides/codex)

### 커뮤니티 리소스

- [gemini-mcp-tool (npm)](https://www.npmjs.com/package/gemini-mcp-tool)
- [@openai/codex-shell-tool-mcp (npm)](https://www.npmjs.com/package/@openai/codex-shell-tool-mcp)
- [MCP Servers GitHub](https://github.com/modelcontextprotocol/servers)

### 추가 가이드

프로젝트 내 관련 문서:
- `CLAUDE_SETUP_GUIDE.md` - 스킬 설치 가이드
- `CLAUDE_MCP_GEMINI_CODEX_SETUP.md` - MCP 서버 설정
- `README.md` - Agent Skills 전체 개요

---

## 변경 이력

| 날짜 | 버전 | 변경 내용 |
|------|------|-----------|
| 2026-01-04 | 1.0.0 | 초기 문서 작성 (Gemini 2.5 Pro, Codex GPT-5.2 분석 기반) |

---

**작성**: Gemini CLI + Codex CLI 분석 결과 기반
**검증**: 실제 MCP 연동 환경에서 테스트 완료
**라이선스**: MIT
