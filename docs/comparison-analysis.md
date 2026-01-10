# Agent Skills 프로젝트 비교 분석

## 개요

이 문서는 공식 Agent Skills 프로젝트(`agentskills/agentskills`)와 현재 프로젝트(`skills-template/.agent-skills`) 간의 차이점을 분석합니다.

## 프로젝트 목적 비교

| 항목 | 공식 프로젝트 | 현재 프로젝트 |
|------|--------------|--------------|
| **목적** | 스펙 정의 및 참조 구현 제공 | 실제 사용 가능한 Skills 모음 |
| **대상** | 에이전트 개발자, 스펙 구현자 | Skills 사용자, 개발자 |
| **초점** | 표준 정의 및 라이브러리 | 실전 Skills 및 유틸리티 |

## 구조 비교

### 공식 프로젝트 구조
```
agentskills/
├── docs/              # 스펙 문서 (MDX)
├── skills-ref/        # Python 참조 라이브러리
└── .claude/          # Claude 설정
```

### 현재 프로젝트 구조
```
.agent-skills/
├── README.md         # 사용 가이드
├── QUICKSTART.md     # 빠른 시작
├── CONTRIBUTING.md   # 기여 가이드
├── setup.sh          # 자동 설정 스크립트
├── skill_loader.py   # Python 유틸리티
├── templates/        # Skills 템플릿
├── backend/          # 실제 Skills (5개 구현)
├── documentation/    # 실제 Skills
├── code-quality/     # 실제 Skills
├── search-analysis/  # 실제 Skills
└── utilities/        # 실제 Skills
```

## 주요 차이점

### 1. 프로젝트 성격

#### 공식 프로젝트
- **스펙 정의자**: Agent Skills 표준의 공식 명세
- **참조 구현 제공**: Python 라이브러리로 구현 예시
- **문서 중심**: 스펙, 통합 가이드, 개념 설명

#### 현재 프로젝트
- **실전 Skills 제공**: 실제 사용 가능한 5개 Skills 구현
- **사용자 중심**: 빠른 시작, 사용 가이드, 템플릿 제공
- **멀티 플랫폼 지원**: Claude, ChatGPT, Gemini 통합 가이드

### 2. Python 라이브러리 비교

#### 공식: skills-ref

**특징**:
- 엄격한 검증 (`strictyaml` 사용)
- 표준 준수에 집중
- CLI 도구 제공 (`skills-ref` 명령어)
- 프로덕션 사용 목적 아님 (데모/참고용)

**기능**:
```python
from skills_ref import validate, read_properties, to_prompt

# 검증
problems = validate(Path("my-skill"))

# 속성 읽기
props = read_properties(Path("my-skill"))

# 프롬프트 생성
prompt = to_prompt([Path("skill-a"), Path("skill-b")])
```

**CLI**:
```bash
skills-ref validate <path>
skills-ref read-properties <path>
skills-ref to-prompt <path>...
```

#### 현재: skill_loader.py

**특징**:
- 실용적인 유틸리티
- 다양한 출력 형식 지원 (Markdown, XML, JSON)
- 플랫폼별 통합 지원
- 실전 사용 목적

**기능**:
```python
from skill_loader import SkillLoader

loader = SkillLoader('.agent-skills')
skill = loader.get_skill('api-design')
skills = loader.search_skills('api')
prompt = loader.format_for_prompt(['api-design'], 'xml')
```

**CLI**:
```bash
python skill_loader.py list
python skill_loader.py search "keyword"
python skill_loader.py show skill-name
python skill_loader.py prompt --skills api-design --format xml
```

**차이점 요약**:

| 기능 | 공식 (skills-ref) | 현재 (skill_loader.py) |
|------|------------------|----------------------|
| 검증 | ✅ 엄격한 검증 | ⚠️ 기본 검증만 |
| 출력 형식 | XML만 | Markdown, XML, JSON |
| 검색 기능 | ❌ 없음 | ✅ 키워드 검색 |
| 플랫폼 지원 | Claude 중심 | Claude, ChatGPT, Gemini |
| 사용 목적 | 참조/데모 | 실전 사용 |

### 3. Skills 구현 비교

#### 공식 프로젝트
- **Skills 없음**: 스펙과 라이브러리만 제공
- 예제는 별도 저장소 (`anthropics/skills`)에 존재

#### 현재 프로젝트
- **5개 Skills 구현 완료**:
  1. `api-design`: REST/GraphQL API 설계
  2. `technical-writing`: 기술 문서 작성
  3. `code-review`: 코드 리뷰
  4. `codebase-search`: 코드베이스 검색
  5. `git-workflow`: Git 워크플로우

### 4. 문서 비교

#### 공식 프로젝트
- **스펙 문서**: 완전한 포맷 명세
- **통합 가이드**: 에이전트 개발자를 위한 가이드
- **개념 설명**: Skills의 작동 방식 설명

#### 현재 프로젝트
- **사용자 가이드**: Skills 사용 방법
- **빠른 시작**: 5분 안에 시작하기
- **기여 가이드**: 새 Skills 추가 방법
- **멀티 에이전트 가이드**: 협업 워크플로우

### 5. 설정 및 자동화

#### 공식 프로젝트
- `.claude/settings.json`: Claude 설정만
- 수동 설정 필요

#### 현재 프로젝트
- **setup.sh**: 대화형 자동 설정 스크립트
  - Claude 자동 설정
  - ChatGPT zip 파일 생성
  - Gemini 통합 설정
  - 모든 플랫폼 일괄 설정
- **멀티 플랫폼 지원**: 통합 가이드 제공

### 6. 템플릿 제공

#### 공식 프로젝트
- 템플릿 없음 (스펙 문서에 예시만)

#### 현재 프로젝트
- **3개 템플릿 제공**:
  1. `basic-skill-template`: 기본 템플릿
  2. `advanced-skill-template`: 고급 템플릿
  3. `multiplatform-skill-template`: 멀티 플랫폼 템플릿

### 7. SKILL.md 형식 준수

#### 공식 스펙 요구사항
```yaml
---
name: skill-name          # 필수: 1-64자, 소문자/숫자/하이픈만
description: ...          # 필수: 1-1024자
license: ...              # 선택
compatibility: ...        # 선택
metadata:                 # 선택
  key: value
allowed-tools: ...        # 선택 (실험적)
---
```

#### 현재 프로젝트 준수도

**✅ 준수하는 항목**:
- `name` 필드: 모든 Skills에 존재, 규칙 준수
- `description` 필드: 모든 Skills에 존재
- YAML frontmatter 형식: 올바르게 사용
- 디렉토리 구조: 표준 구조 준수

**⚠️ 개선 가능한 항목**:
- `license` 필드: 일부 Skills에 없음
- `compatibility` 필드: 없음
- `metadata` 필드: 없음
- 엄격한 검증: `skill_loader.py`는 기본 검증만 수행

**예시 비교**:

**공식 스펙 예시**:
```yaml
---
name: pdf-processing
description: Extract text and tables from PDF files, fill forms, merge documents.
license: Apache-2.0
compatibility: Requires pypdf and pdfplumber packages
metadata:
  author: example-org
  version: "1.0"
allowed-tools: Bash(python:*) Read
---
```

**현재 프로젝트 예시**:
```yaml
---
name: api-design
description: Design RESTful and GraphQL APIs following best practices. Use when creating new APIs, refactoring existing endpoints, or documenting API specifications. Handles OpenAPI, REST, GraphQL, versioning.
---
```

### 8. Progressive Disclosure 구현

#### 공식 프로젝트
- 스펙에 명시되어 있으나 구현 없음
- 에이전트 개발자가 직접 구현해야 함

#### 현재 프로젝트
- `skill_loader.py`에서 부분적 구현:
  - 메타데이터만 로드 (`get_skill()`)
  - 전체 내용 로드 (`get_skill_content()`)
- 완전한 Progressive Disclosure는 에이전트 레벨에서 구현 필요

### 9. 멀티 에이전트 지원

#### 공식 프로젝트
- 멀티 에이전트 개념 없음
- 단일 에이전트 사용 가정

#### 현재 프로젝트
- **멀티 에이전트 워크플로우 강조**:
  - 여러 에이전트 협업 권장
  - 각 에이전트가 전문 Skill 활용
  - README에 상세 가이드 포함

### 10. 플랫폼 지원

#### 공식 프로젝트
- Claude 중심 (Anthropic 프로젝트)
- 다른 플랫폼 통합 가이드 없음

#### 현재 프로젝트
- **3개 플랫폼 지원**:
  - Claude: 자동 발견 및 설정
  - ChatGPT: Custom GPT 통합 가이드
  - Gemini: Python API 통합 가이드
- 각 플랫폼별 상세 가이드 제공

## 개선 제안

### 현재 프로젝트에 추가하면 좋을 것들

#### 1. 엄격한 검증 도구
```python
# skills-ref의 validator.py 참고하여 개선
def validate_strict(skill_dir: Path) -> List[str]:
    """엄격한 검증 수행"""
    problems = []
    # name 규칙 검증 (하이픈, 길이 등)
    # 디렉토리 이름 일치 확인
    # description 길이 확인
    return problems
```

#### 2. 표준 필드 추가
- `license` 필드: 각 Skill에 라이선스 명시
- `compatibility` 필드: 필요시 환경 요구사항 명시
- `metadata` 필드: 버전, 작성자 등 메타데이터

#### 3. skills-ref 라이브러리 통합
```python
# skill_loader.py에 skills-ref 통합
try:
    from skills_ref import validate as strict_validate
    # 엄격한 검증 옵션 제공
except ImportError:
    # 기본 검증 사용
    pass
```

#### 4. 표준 준수 확인 도구
```bash
# 표준 준수 확인 스크립트 추가
python skill_loader.py validate-strict skill-name
```

## 결론

### 공식 프로젝트의 강점
- ✅ 완전한 스펙 정의
- ✅ 엄격한 검증 도구
- ✅ 공식 참조 구현
- ✅ 상세한 문서

### 현재 프로젝트의 강점
- ✅ 실전 사용 가능한 Skills 제공
- ✅ 멀티 플랫폼 지원
- ✅ 사용자 친화적인 가이드
- ✅ 자동화 도구 제공
- ✅ 멀티 에이전트 워크플로우

### 상호 보완 관계

**공식 프로젝트**는 **"표준 정의자"**로서:
- 스펙 명세 및 참조 구현 제공
- 다른 구현들이 따를 기준점

**현재 프로젝트**는 **"실전 구현자"**로서:
- 표준을 따르면서도 실용성 강조
- 사용자 경험 최적화
- 멀티 플랫폼 및 멀티 에이전트 지원

### 권장 사항

1. **표준 준수 강화**: `skills-ref`의 검증 로직 통합
2. **메타데이터 보완**: `license`, `compatibility` 필드 추가
3. **문서 보완**: 스펙 문서 참조 링크 추가
4. **검증 도구 개선**: 엄격한 검증 옵션 제공

현재 프로젝트는 공식 스펙을 잘 따르면서도 실전 사용에 최적화된 훌륭한 구현입니다. 표준 준수 측면에서 일부 개선 여지가 있지만, 사용자 경험과 실용성 측면에서는 공식 프로젝트보다 더 나은 부분이 많습니다.
