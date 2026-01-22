---
name: agent-workflow
description: Design principles for multi-agent workflows with validation gates using the Ralph Wiggum technique. Use when orchestrating multiple AI agents (Opus/Sonnet/Gemini/Codex) for complex autonomous development tasks with skill stacking, extended thinking, and iterative improvement loops.
tags: [agent-workflow, multi-agent, ralph-wiggum, orchestration, autonomous, extended-thinking, opus, sonnet, validation-gates, skill-stack]
platforms: [Claude, ChatGPT, Gemini, Opencode, Codex]
allowed-tools:
  - Task
  - Bash
  - Read
  - Write
  - Grep
  - Glob
  - mcp__gemini-cli__ask-gemini
  - mcp__codex-cli__shell
---

# Agent Workflow Design Principles

Ralph Wiggum 기법 기반의 멀티 에이전트 워크플로우 설계 원칙입니다. 여러 AI 에이전트(Opus/Sonnet/Gemini/Codex)를 조율하여 복잡한 자율 개발 작업을 수행하는 방법론을 다룹니다.

## When to use this skill

- **대규모 코드베이스 분석**: 500+ 파일의 소스 코드 분석 필요 시
- **복잡한 구현 작업**: 아키텍처 결정, 디버깅, 리팩토링이 필요한 작업
- **자율 개발 루프**: 사람의 개입 없이 장시간 실행되는 개발 작업
- **멀티 모델 협업**: Opus, Sonnet, Gemini, Codex를 함께 활용할 때
- **Implementation Plan 기반 개발**: 우선순위 기반 점진적 구현

---

## 1. Ralph Wiggum Technique 개요

### 핵심 철학

> "Ralph is a Bash loop." - Geoffrey Huntley

심슨 가족의 캐릭터 Ralph Wiggum처럼 **단순하지만 끈질긴** 접근법입니다. AI 에이전트에게 동일한 작업을 완료될 때까지 반복적으로 수행시킵니다.

### 기본 원리

```bash
# Ralph Wiggum의 핵심 - 5줄 Bash 스크립트
while true; do
  claude --prompt "작업을 계속하세요. 완료되면 COMPLETE 출력"
  if grep -q "COMPLETE" output.log; then break; fi
done
```

**핵심 통찰**:
- 진행 상태는 LLM 컨텍스트 윈도우가 아닌 **파일과 Git 히스토리**에 저장
- 컨텍스트가 가득 차면 새로운 에이전트가 이어받아 작업 계속
- 파일시스템이 상태(State), Git이 메모리(Memory)

### Contextual Pressure Cooker

모델의 전체 출력(실패, 스택 트레이스, 할루시네이션 포함)을 다음 반복의 입력으로 피드백하여 "문맥적 압력솥" 효과를 만듭니다.

```
[반복 1] 작업 시도 → 실패 → 오류 출력
    ↓
[반복 2] 이전 오류 + 작업 시도 → 부분 성공
    ↓
[반복 3] 이전 결과 + 작업 시도 → 완료
```

---

## 2. Ultrathink: Opus Subagent 활용

### Ultrathink란?

**Ultrathink**는 Opus 모델의 extended thinking 능력을 활용하여 복잡한 추론, 분석, 의사결정을 수행하는 서브에이전트입니다.

### 역할 분담

| 에이전트 | 모델 | 역할 | 병렬 수 |
|---------|------|------|---------|
| **Ultrathink** | Opus | 분석, 종합, 우선순위 결정, 아키텍처 | 1 |
| **Worker** | Sonnet | 코드 검색, 파일 읽기, 구현 | 최대 500 |
| **Executor** | Codex | 빌드, 테스트, 배포 실행 | 1 |
| **Analyst** | Gemini | 대용량 코드 분석 (1M+ 토큰) | 1 |

### Ultrathink 워크플로우

```
1. [Sonnet x 500] src/* 소스 코드 분석
   ↓
2. [Sonnet x 500] specs/* 스펙 문서와 비교
   ↓
3. [Opus] 분석 결과 종합 및 우선순위 결정 (Ultrathink)
   ↓
4. [Opus] @IMPLEMENTATION_PLAN.md 생성/업데이트
   ↓
5. [Sonnet] 우선순위 순서대로 구현
   ↓
6. [Codex] 빌드 및 테스트 실행
   ↓
7. 반복 (완료까지)
```

---

## 3. IMPLEMENTATION_PLAN.md 기반 개발

### 파일 구조

```markdown
# Implementation Plan

## Priority 1: Critical
- [ ] Fix authentication token refresh bug
- [ ] Add rate limiting to API endpoints

## Priority 2: High
- [ ] Implement user profile caching
- [ ] Add pagination to list endpoints

## Priority 3: Medium
- [ ] Refactor database connection pooling
- [ ] Add comprehensive error logging

## Completed
- [x] Set up project structure
- [x] Configure CI/CD pipeline
```

### 자동 업데이트 규칙

1. **작업 완료 시**: `[ ]` → `[x]`로 변경 후 Completed로 이동
2. **새 작업 발견 시**: 적절한 우선순위에 추가
3. **블로커 발견 시**: Priority 1으로 승격
4. **의존성 발견 시**: 관련 작업 순서 조정

---

## 4. Multi-Agent Ralph Loop 아키텍처

### 14 에이전트 시스템 (9 Core + 5 Auxiliary)

**Core Agents**:
1. **Orchestrator**: 전체 워크플로우 조율
2. **Planner**: Implementation Plan 관리
3. **Coder**: 코드 작성 및 수정
4. **Reviewer**: 코드 리뷰 및 품질 검증
5. **Tester**: 테스트 작성 및 실행
6. **Debugger**: 버그 분석 및 수정
7. **Documenter**: 문서 작성 및 업데이트
8. **Refactorer**: 코드 리팩토링
9. **Deployer**: 배포 및 인프라 관리

**Auxiliary Agents**:
1. **Security Auditor**: 보안 취약점 검사
2. **Performance Analyzer**: 성능 분석
3. **Dependency Manager**: 의존성 관리
4. **Config Manager**: 설정 관리
5. **Adversarial Validator**: 적대적 검증

### Context Preservation

**Ledger 시스템**:
```
.ralph/
├── ledger.json          # 전체 상태 기록
├── handoffs/            # 에이전트 간 인수인계
│   ├── coder-to-reviewer.md
│   └── reviewer-to-tester.md
└── checkpoints/         # Git 체크포인트
    ├── checkpoint-001.json
    └── checkpoint-002.json
```

**Handoff 예시**:
```markdown
# Handoff: Coder → Reviewer

## Completed Work
- Implemented user authentication module
- Added JWT token validation

## Files Changed
- src/auth/login.ts (new)
- src/auth/token.ts (new)
- src/middleware/auth.ts (modified)

## Notes for Reviewer
- Check token expiration logic
- Verify password hashing strength

## Next Steps
- Code review required before merge
```

---

## 5. 토큰 관리 및 Escape Hatches

### 토큰 절감 전략 (85-90% 감소)

1. **점진적 컨텍스트 로딩**: 필요한 파일만 로드
2. **Ledger 기반 상태 관리**: 전체 히스토리 대신 요약
3. **Handoff 문서화**: 에이전트 간 최소 정보만 전달
4. **Git Checkpoint**: 상태 복구용 스냅샷

### Escape Hatches (비용 제어)

```bash
# 반드시 max-iterations 설정
ralph-loop --max-iterations 50 --task "Implement feature X"

# 비용 한도 설정
ralph-loop --max-cost $10 --task "Refactor module Y"

# 시간 제한
ralph-loop --timeout 2h --task "Debug issue Z"
```

**자동 중단 조건**:
- 동일 오류 3회 연속 발생
- 토큰 예산 80% 소진
- 무한 루프 패턴 감지
- 사용자 정의 중단 신호

---

## 6. 실전 워크플로우 예시

### 예시 1: 대규모 리팩토링

```bash
# 1. 분석 단계 (Sonnet x 500 병렬)
claude task "src/* 전체 파일의 코드 스멜 분석"

# 2. 계획 단계 (Opus Ultrathink)
claude task --model opus "분석 결과를 종합하고 IMPLEMENTATION_PLAN.md 작성. Ultrathink."

# 3. 실행 단계 (Ralph Loop)
ralph-loop --max-iterations 100 \
  --plan IMPLEMENTATION_PLAN.md \
  --task "계획에 따라 리팩토링 수행"
```

### 예시 2: 버그 수정

```bash
# 1. 버그 재현 (Codex)
codex-cli shell "npm test -- --grep 'failing test'"

# 2. 원인 분석 (Opus Ultrathink)
claude task --model opus "테스트 실패 원인 분석. 관련 코드 검토. Ultrathink."

# 3. 수정 및 검증 (Ralph Loop)
ralph-loop --max-iterations 20 \
  --completion-promise "All tests passing" \
  --task "버그 수정 및 테스트 통과"
```

### 예시 3: 새 기능 구현

```markdown
# IMPLEMENTATION_PLAN.md

## Feature: User Dashboard

### Priority 1
- [ ] Design database schema for user metrics
- [ ] Create API endpoints for dashboard data

### Priority 2
- [ ] Implement React dashboard component
- [ ] Add real-time data updates via WebSocket

### Priority 3
- [ ] Write integration tests
- [ ] Add documentation
```

```bash
# 전체 자동화
ralph-loop --plan IMPLEMENTATION_PLAN.md \
  --max-iterations 200 \
  --checkpoint-interval 10 \
  --task "User Dashboard 기능 구현"
```

---

## 6.5 Skill Stack Orchestration (Validation Gates)

### Full-Stack Delivery Workflow

복잡한 프로젝트에서 여러 스킬을 시퀀싱하여 엔드투엔드 딜리버리:

```markdown
## Skill Stack Sequence

### Step 1: Define Outcome
- Target deliverable: [launch, campaign, product]
- Time constraints: [deadline]
- Quality constraints: [standards]

### Step 2: Sequence Skills
1) Marketing strategy → messaging, positioning
2) Frontend design → UI/UX, design tokens
3) Image generation → visual assets
4) Video production → promo content
5) Code simplification → refactoring, cleanup
6) Presentation deck → final pitch
```

### Validation Gates

각 단계 사이에 검증 게이트를 배치:

```yaml
validation_gates:
  gate_a:
    name: "Messaging & Positioning Review"
    after_skill: "marketing-strategy"
    checklist:
      - Brand voice consistency
      - Target audience alignment
      - Value proposition clarity
    owner: "Analyst"

  gate_b:
    name: "Design System Consistency"
    after_skill: "frontend-design"
    checklist:
      - Token usage validation
      - Accessibility compliance
      - Responsive behavior
    owner: "Analyst"

  gate_c:
    name: "Asset QA"
    after_skill: "image-generation, video-production"
    checklist:
      - Brand alignment
      - Resolution/format correctness
      - File naming convention
    owner: "Executor"

  gate_d:
    name: "Code Quality"
    after_skill: "code-refactoring"
    checklist:
      - Tests passing
      - Lint clean
      - Behavior preserved
    owner: "Executor"

  gate_e:
    name: "Deck Narrative & Polish"
    after_skill: "presentation-builder"
    checklist:
      - Story arc coherent
      - Visual consistency
      - Speaker notes complete
    owner: "Orchestrator"
```

### Multi-Agent Role Assignment

```markdown
## Role Assignment

| Agent | Role | Responsibilities |
|-------|------|------------------|
| Claude (Opus) | Orchestrator | Plan, synthesize, approve gates |
| Claude (Sonnet) | Worker | Execute skills, generate content |
| Gemini | Analyst | Deep analysis, QA reviews |
| Codex | Executor | Commands, builds, validation |
```

### Example: B2B SaaS Launch

```bash
# Full skill stack for 2-week launch

# Week 1
## Day 1-2: Strategy
claude task "Run marketing-automation skill for positioning"
# → Gate A: Messaging review

## Day 3-4: Design
claude task "Run frontend-design skill for landing page"
# → Gate B: Design consistency check

## Day 5: Assets
claude task "Run image-generation skill for hero/social"
# → Gate C: Asset QA

# Week 2
## Day 1-2: Development
claude task "Run code-refactoring skill for codebase cleanup"
# → Gate D: Code quality check

## Day 3: Video
claude task "Run video-production skill for promo video"
# → Gate C: Asset QA

## Day 4-5: Presentation
claude task "Run presentation-builder skill for investor deck"
# → Gate E: Deck review

# Final: Launch readiness
claude task --model opus "Synthesize all outputs, final launch checklist"
```

### Metrics Tracking

```markdown
## Delivery Metrics

| Metric | Target | Actual |
|--------|--------|--------|
| Gate pass rate | 100% | - |
| Skill completion | 6/6 | - |
| Rework cycles | < 2 | - |
| Total duration | 10 days | - |
```

---

## 7. Best Practices

### DO (권장)

1. **항상 max-iterations 설정**: 무한 루프 방지
2. **IMPLEMENTATION_PLAN.md 사용**: 진행 상황 추적
3. **Git 체크포인트 활용**: 롤백 가능하도록
4. **Handoff 문서화**: 에이전트 간 컨텍스트 전달
5. **적절한 모델 선택**:
   - Opus: 복잡한 추론, 아키텍처 결정
   - Sonnet: 병렬 작업, 코드 작성
   - Codex: 명령 실행
   - Gemini: 대용량 분석

### DON'T (금지)

1. **무한 루프 방치**: 비용 폭발 위험
2. **단일 에이전트 과부하**: 역할 분담 필요
3. **상태 미저장**: 파일시스템/Git 활용 필수
4. **Handoff 생략**: 컨텍스트 손실 발생
5. **Escape Hatch 미설정**: 항상 중단 조건 필요

---

## 8. Constraints

### 필수 규칙 (MUST)

1. **비용 제어**: 항상 max-iterations 또는 max-cost 설정
2. **상태 저장**: 모든 진행 상황을 파일시스템에 기록
3. **역할 분리**: 에이전트별 명확한 책임 정의
4. **검증 단계**: 각 단계 완료 후 검증 수행

### 금지 사항 (MUST NOT)

1. **무제한 루프**: 항상 종료 조건 필요
2. **단일 에이전트 독점**: 복잡한 작업은 분산
3. **수동 개입 의존**: 자율 실행 가능하도록 설계
4. **컨텍스트 낭비**: 필요한 정보만 전달

---

## References

- [How Ralph Wiggum went from 'The Simpsons' to the biggest name in AI right now | VentureBeat](https://venturebeat.com/technology/how-ralph-wiggum-went-from-the-simpsons-to-the-biggest-name-in-ai-right-now)
- [The Ralph Wiggum Approach: Running AI Coding Agents for Hours | DEV Community](https://dev.to/sivarampg/the-ralph-wiggum-approach-running-ai-coding-agents-for-hours-not-minutes-57c1)
- [A Brief History of Ralph | HumanLayer Blog](https://www.humanlayer.dev/blog/brief-history-of-ralph)
- [GitHub - ghuntley/how-to-ralph-wiggum](https://github.com/ghuntley/how-to-ralph-wiggum)
- [GitHub - mikeyobrien/ralph-orchestrator](https://github.com/mikeyobrien/ralph-orchestrator)
- [GitHub - alfredolopez80/multi-agent-ralph-loop](https://github.com/alfredolopez80/multi-agent-ralph-loop)
- [Ralph Orchestrator Guide](https://mikeyobrien.github.io/ralph-orchestrator/)

---

## Metadata

### 버전
- **현재 버전**: 1.0.0
- **최종 업데이트**: 2026-01-10
- **호환 플랫폼**: Claude, ChatGPT, Gemini, Opencode

### 관련 스킬
- [mcp-codex-integration](../../utilities/mcp-codex-integration/SKILL.md)
- [subagent-creation](../subagent-creation/SKILL.md)
- [task-planning](../task-planning/SKILL.md)

### 태그
`#ultrathink` `#multi-agent` `#ralph-wiggum` `#orchestration` `#autonomous` `#extended-thinking` `#opus` `#sonnet`
