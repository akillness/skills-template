# Agent Skill 추가 프롬프트 (TOON 포맷)

AI 에이전트에게 새로운 Agent Skill을 생성하도록 요청하는 구조화된 프롬프트입니다.

---

## 📋 TOON 프롬프트: 새 Agent Skill 생성

### T - Task (작업)
`.agent-skills/` 디렉토리에 새로운 Agent Skill을 생성합니다. Agent Skills 오픈 표준을 준수하며, Claude, ChatGPT, Gemini 모두에서 사용 가능한 Skill을 만듭니다.

### O - Objective (목표)
1. 지정된 카테고리에 새 Skill 폴더 생성
2. Agent Skills 표준을 따르는 `SKILL.md` 파일 작성
3. 필요시 지원 파일 추가 (scripts, templates, references)
4. 실용적이고 재사용 가능한 Skill 제공

### O - Output (출력)
다음 구조의 Skill을 생성합니다:

```
.agent-skills/{category}/{skill-name}/
├── SKILL.md                # 필수: 메타데이터 + 지침
├── REFERENCE.md            # 선택: 상세 레퍼런스
├── EXAMPLES.md             # 선택: 추가 예제
├── scripts/                # 선택: 실행 스크립트
│   └── helper.py
├── templates/              # 선택: 템플릿 파일
│   └── config.yaml
└── assets/                 # 선택: 이미지, 다이어그램
```

**SKILL.md 구조**:
```markdown
---
name: skill-name
description: 구체적인 설명 (무엇을, 언제, 어떤 기술)
allowed-tools: [도구1, 도구2]  # 선택사항
---

# Skill Name

## When to use this skill
- 사용 시나리오 1
- 사용 시나리오 2

## Instructions
단계별 명확한 지침

## Examples
실용적인 코드 예제

## Best practices
모범 사례

## References
외부 참고 자료
```

### N - Notes (주의사항)

#### 필수 규칙
1. **name 필드**: 
   - 소문자만 사용
   - 하이픈으로 단어 구분
   - 최대 64자
   - ✅ 예: `api-design`, `code-review`
   - ❌ 피할 것: `API_Design`, `my skill`, `skill1`

2. **description 필드**:
   - 최대 1024자
   - 구체적으로 작성 (AI가 자동으로 발견할 수 있도록)
   - 무엇을 하는지, 언제 사용하는지, 어떤 기술을 다루는지 명시
   - ✅ 예: "Design RESTful and GraphQL APIs following best practices. Use when creating new APIs, refactoring endpoints, or documenting API specifications. Handles OpenAPI, REST, GraphQL, versioning."
   - ❌ 피할 것: "For API design"

3. **카테고리 선택**:
   - `infrastructure/`: 시스템, 배포, 모니터링
   - `backend/`: API, 데이터베이스, 인증
   - `frontend/`: UI, 상태 관리, 디자인
   - `documentation/`: 문서 작성
   - `code-quality/`: 코드 리뷰, 리팩토링
   - `search-analysis/`: 검색, 분석
   - `project-management/`: 프로젝트 관리
   - `utilities/`: 유틸리티

4. **지침 작성**:
   - 단계별로 명확하게
   - 실행 가능한 구체적 내용
   - 코드 예제 포함
   - 에러 처리 방법 제시

5. **예제 작성**:
   - 완전하고 실행 가능한 코드
   - 다양한 사용 시나리오
   - 기대되는 출력 포함

#### 참고 파일
- 템플릿: `.agent-skills/templates/basic-skill-template/SKILL.md`
- 고급 템플릿: `.agent-skills/templates/advanced-skill-template/SKILL.md`
- 기존 예제: `.agent-skills/backend/api-design/SKILL.md`
- 가이드: `/Skills/claude_skill_template_guide.md`

---

## 🎯 프롬프트 사용 예제

### 예제 1: 기본 Skill 생성

```
@add_new_skill_prompt.md 를 참조하여 다음 Skill을 생성해줘:

**Task**: 새 Agent Skill 생성
**Category**: backend
**Skill Name**: database-schema-design
**Purpose**: 데이터베이스 스키마 설계 및 최적화

**Objective**:
- 정규화/비정규화 가이드
- 인덱스 설계 전략
- 관계 정의 (1:1, 1:N, N:M)
- 마이그레이션 베스트 프랙티스
- PostgreSQL, MySQL, MongoDB 지원

**Output Requirements**:
- 단계별 스키마 설계 프로세스
- ERD 다이어그램 예제 (Mermaid)
- SQL 예제 코드
- 성능 최적화 팁

**Notes**:
- allowed-tools: Read, Write 사용
- 복잡한 예제 포함
```

### 예제 2: 고급 Skill (다중 파일)

```
@add_new_skill_prompt.md 를 참조하여 다음 고급 Skill을 생성해줘:

**Task**: 다중 파일 Agent Skill 생성
**Category**: infrastructure
**Skill Name**: kubernetes-deployment
**Purpose**: Kubernetes 클러스터 배포 및 관리

**Objective**:
- Kubernetes 리소스 정의
- Helm 차트 작성
- CI/CD 파이프라인 통합
- 모니터링 및 로깅 설정
- 롤링 업데이트 및 롤백

**Output Requirements**:
1. SKILL.md: 메인 지침
2. REFERENCE.md: K8s 리소스 상세 설명
3. scripts/deploy.sh: 배포 스크립트
4. scripts/rollback.sh: 롤백 스크립트
5. templates/deployment.yaml: Deployment 템플릿
6. templates/service.yaml: Service 템플릿
7. templates/ingress.yaml: Ingress 템플릿

**Notes**:
- 실제 실행 가능한 스크립트
- kubectl 명령어 포함
- 보안 베스트 프랙티스
- 에러 처리 및 검증
```

### 예제 3: 도구 제한 Skill

```
@add_new_skill_prompt.md 를 참조하여 다음 읽기 전용 Skill을 생성해줘:

**Task**: 읽기 전용 Agent Skill 생성
**Category**: search-analysis
**Skill Name**: log-analysis
**Purpose**: 애플리케이션 로그 분석 및 패턴 감지

**Objective**:
- 로그 파일 파싱
- 에러 패턴 감지
- 성능 이슈 발견
- 보안 이상 징후 분석
- 통계 및 요약 생성

**Output Requirements**:
- 읽기 전용 작업만 수행 (allowed-tools: Read, Grep, Glob)
- 정규표현식 패턴 제공
- 다양한 로그 포맷 지원 (Apache, Nginx, application logs)
- 분석 체크리스트

**Notes**:
- 파일 수정 금지
- 보안을 위한 도구 제한
- grep 패턴 예제 풍부하게
```

### 예제 4: Frontend Skill

```
@add_new_skill_prompt.md 를 참조하여 다음 Skill을 생성해줘:

**Task**: Frontend Agent Skill 생성
**Category**: frontend
**Skill Name**: react-component-patterns
**Purpose**: React 컴포넌트 디자인 패턴 및 베스트 프랙티스

**Objective**:
- 함수형 컴포넌트 vs 클래스 컴포넌트
- Hooks 사용 패턴
- 상태 관리 전략
- 성능 최적화 (memoization, lazy loading)
- 접근성 (a11y) 구현
- 테스트 전략

**Output Requirements**:
- React 18+ 기준
- TypeScript 예제
- 실용적인 컴포넌트 예제 (Button, Form, Modal 등)
- 안티패턴 예시
- 성능 측정 방법

**Notes**:
- 최신 React 패턴 반영
- hooks 중심 설명
- 실제 프로덕션 코드 수준
```

---

## 📝 빠른 시작 템플릿

### 최소 프롬프트 (간단한 Skill)

```
@add_new_skill_prompt.md

새 Skill 생성:
- Category: [카테고리]
- Name: [skill-name]
- Purpose: [목적]
- Key features: [주요 기능 3-5개]
```

### 표준 프롬프트 (일반 Skill)

```
@add_new_skill_prompt.md

**Task**: 새 Agent Skill 생성
**Category**: [카테고리]
**Skill Name**: [skill-name]
**Purpose**: [상세 목적]

**Features**:
- 기능 1
- 기능 2
- 기능 3

**Include**:
- 단계별 지침
- 코드 예제
- Best practices
```

### 완전 프롬프트 (복잡한 Skill)

```
@add_new_skill_prompt.md
@.agent-skills/templates/advanced-skill-template/SKILL.md

**Task**: 고급 Agent Skill 생성
**Category**: [카테고리]
**Skill Name**: [skill-name]
**Purpose**: [상세 목적]

**Objective**:
- 목표 1
- 목표 2
- 목표 3

**Output Requirements**:
1. SKILL.md
2. REFERENCE.md
3. scripts/ 폴더
4. templates/ 폴더

**Technical Requirements**:
- 지원 언어/프레임워크
- 필수 도구
- 의존성

**Examples**:
- 기본 사용 예제
- 고급 사용 예제
- 실전 시나리오

**Notes**:
- 특별 고려사항
- 보안 요구사항
- 성능 고려사항
```

---

## ✅ 생성 후 검증

Skill 생성 후 다음을 확인하세요:

```bash
# 1. YAML 유효성 검사
python3 -c "
import yaml
content = open('.agent-skills/[category]/[skill-name]/SKILL.md').read()
frontmatter = content.split('---')[1]
yaml.safe_load(frontmatter)
print('✅ YAML is valid!')
"

# 2. Skill 로드 테스트
python .agent-skills/skill_loader.py show [skill-name]

# 3. Skill 목록 확인
python .agent-skills/skill_loader.py list | grep [skill-name]

# 4. 프롬프트 생성 테스트
python .agent-skills/skill_loader.py prompt --skills [skill-name]
```

---

## 🔄 반복 개선 프롬프트

Skill을 개선하려면:

```
기존 Skill을 개선해줘:

**Target**: .agent-skills/[category]/[skill-name]/SKILL.md

**Improvements Needed**:
1. [개선사항 1]
2. [개선사항 2]
3. [개선사항 3]

**Add**:
- 추가할 내용

**Remove**:
- 제거할 내용

**Refactor**:
- 리팩토링할 부분
```

---

## 📚 참고 자료

- **템플릿**: `.agent-skills/templates/`
- **기존 예제**: `.agent-skills/backend/api-design/SKILL.md`
- **작성 가이드**: `/Skills/claude_skill_template_guide.md`
- **아키텍처**: `/Skills/universal_agent_skills_architecture.md`
- **기여 가이드**: `.agent-skills/CONTRIBUTING.md`
- **Agent Skills 표준**: https://agentskills.io/specification

---

## 💡 프롬프트 팁

1. **구체적으로**: 모호한 요청보다 상세한 요구사항 제공
2. **예제 포함**: 원하는 출력 형식을 예제로 제시
3. **컨텍스트 제공**: 관련 파일을 @ 멘션으로 참조
4. **반복 개선**: 첫 결과를 보고 피드백하여 개선
5. **기존 참조**: 비슷한 기존 Skill을 참조로 제공

---

**버전**: 1.0.0  
**최종 업데이트**: 2024-12-31  
**포맷**: TOON (Task-Objective-Output-Notes)

