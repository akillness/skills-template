# Agent Skills 공식 프로젝트 분석 보고서

## 프로젝트 개요

**프로젝트명**: Agent Skills  
**저장소**: https://github.com/agentskills/agentskills.git  
**메인테이너**: Anthropic  
**라이선스**: Apache 2.0  
**목적**: AI 에이전트를 위한 오픈 포맷 스펙 및 참조 구현 제공

## 프로젝트 구조

```
agentskills/
├── README.md                    # 프로젝트 소개
├── docs/                        # 공식 문서 (MDX 형식)
│   ├── specification.mdx       # 스펙 정의
│   ├── what-are-skills.mdx      # Skills 개념 설명
│   ├── integrate-skills.mdx     # 통합 가이드
│   └── images/                  # 로고 및 이미지
├── skills-ref/                  # Python 참조 라이브러리
│   ├── src/skills_ref/          # 소스 코드
│   │   ├── models.py            # 데이터 모델
│   │   ├── parser.py            # YAML 파서
│   │   ├── validator.py         # 검증 로직
│   │   ├── prompt.py            # 프롬프트 생성
│   │   └── cli.py               # CLI 인터페이스
│   └── tests/                   # 테스트 코드
└── .claude/                     # Claude 설정
    ├── settings.json            # Claude 설정
    └── hooks/                   # 세션 훅
```

## 핵심 구성 요소

### 1. 문서 (docs/)

#### specification.mdx
- **Agent Skills 포맷의 완전한 스펙 정의**
- 디렉토리 구조, SKILL.md 형식, 필수/선택 필드 정의
- Progressive disclosure 개념 설명
- 검증 규칙 및 제약사항

**주요 내용**:
- 필수 필드: `name`, `description`
- 선택 필드: `license`, `compatibility`, `metadata`, `allowed-tools`
- `name` 필드 규칙:
  - 1-64 문자
  - 소문자, 숫자, 하이픈만 허용
  - 하이픈으로 시작/끝나면 안 됨
  - 연속 하이픈(`--`) 금지
  - 디렉토리 이름과 일치해야 함
- `description` 필드 규칙:
  - 1-1024 문자
  - 무엇을 하는지와 언제 사용하는지 설명
  - 키워드 포함 권장

#### what-are-skills.mdx
- Skills의 개념과 작동 방식 설명
- Progressive disclosure 메커니즘 설명
- SKILL.md 파일 구조 및 예시

#### integrate-skills.mdx
- 에이전트에 Skills 지원 추가 방법
- Filesystem-based vs Tool-based 접근 방식
- 메타데이터 로딩 및 프롬프트 주입 방법
- 보안 고려사항

### 2. Python 참조 라이브러리 (skills-ref/)

#### 기술 스택
- **Python**: >= 3.11
- **의존성**:
  - `click>=8.0`: CLI 인터페이스
  - `strictyaml>=1.7.3`: 엄격한 YAML 파싱
- **개발 도구**:
  - `pytest>=7.0`: 테스트
  - `ruff>=0.8.0`: 린팅

#### 주요 기능

**1. 모델 (models.py)**
```python
@dataclass
class SkillProperties:
    name: str                    # 필수
    description: str              # 필수
    license: Optional[str]        # 선택
    compatibility: Optional[str]  # 선택
    allowed_tools: Optional[str]   # 선택 (실험적)
    metadata: dict[str, str]       # 선택
```

**2. 파서 (parser.py)**
- `find_skill_md()`: SKILL.md 파일 찾기 (대소문자 구분 없음)
- `parse_frontmatter()`: YAML frontmatter 파싱
- `read_properties()`: Skills 속성 읽기

**3. 검증 (validator.py)**
- Skills 디렉토리 유효성 검사
- 필수 필드 확인
- 이름 규칙 검증
- 디렉토리 이름 일치 확인

**4. 프롬프트 생성 (prompt.py)**
- `<available_skills>` XML 생성
- Claude 모델용 최적화된 형식

**5. CLI (cli.py)**
```bash
skills-ref validate <path>           # Skills 검증
skills-ref read-properties <path>    # 속성 읽기 (JSON 출력)
skills-ref to-prompt <path>...       # 프롬프트 XML 생성
```

### 3. Claude 설정 (.claude/)

#### settings.json
```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/session-start.sh"
          }
        ]
      }
    ]
  }
}
```

- 세션 시작 시 훅 실행 설정
- 자동화된 초기화 스크립트 지원

## Agent Skills 스펙 요약

### 디렉토리 구조

```
skill-name/
├── SKILL.md          # 필수: 지침 + 메타데이터
├── scripts/          # 선택: 실행 가능한 코드
├── references/       # 선택: 추가 문서
└── assets/          # 선택: 템플릿, 리소스
```

### SKILL.md 형식

**필수 Frontmatter**:
```yaml
---
name: skill-name
description: A description of what this skill does and when to use it.
---
```

**선택 Frontmatter**:
```yaml
---
name: skill-name
description: ...
license: Apache-2.0
compatibility: Requires git, docker, jq
metadata:
  author: example-org
  version: "1.0"
allowed-tools: Bash(git:*) Read
---
```

### Progressive Disclosure

1. **Discovery** (~100 tokens): 시작 시 `name`과 `description`만 로드
2. **Activation** (< 5000 tokens 권장): 작업이 매칭되면 전체 `SKILL.md` 로드
3. **Resources** (필요 시): 참조 파일들만 필요할 때 로드

**권장사항**:
- 메인 `SKILL.md`는 500줄 이하로 유지
- 상세 참조 자료는 별도 파일로 분리
- 파일 참조는 한 단계 깊이까지만

## 주요 특징

### 1. 오픈 표준
- Anthropic이 주도하지만 커뮤니티 기여 개방
- 명확한 스펙으로 다양한 구현 가능

### 2. 플랫폼 독립적
- 파일 기반 구조로 이식성 높음
- Filesystem-based와 Tool-based 모두 지원

### 3. 컨텍스트 효율성
- Progressive disclosure로 토큰 사용 최적화
- 메타데이터만 먼저 로드하여 빠른 발견

### 4. 확장 가능성
- 단순한 텍스트 지침부터 실행 코드까지
- 복잡도에 따라 조절 가능

### 5. 자체 문서화
- SKILL.md만 읽어도 이해 가능
- 감사 및 개선이 쉬움

## 보안 고려사항

스크립트 실행 시 고려사항:
- **Sandboxing**: 격리된 환경에서 실행
- **Allowlisting**: 신뢰된 Skills만 실행
- **Confirmation**: 위험한 작업 전 사용자 확인
- **Logging**: 모든 실행 기록

## 통합 방법

### Filesystem-based Agents
- 쉘 명령어로 Skills 접근 (`cat /path/to/skill/SKILL.md`)
- 절대 경로 사용

### Tool-based Agents
- 커스텀 도구로 Skills 트리거
- 위치 필드 생략 가능

### 프롬프트 주입
```xml
<available_skills>
  <skill>
    <name>skill-name</name>
    <description>...</description>
    <location>/path/to/skill/SKILL.md</location>
  </skill>
</available_skills>
```

## 참조 구현

**skills-ref 라이브러리**:
- Python으로 작성된 참조 구현
- 프로덕션 사용 목적이 아닌 데모/참고용
- 검증, 파싱, 프롬프트 생성 기능 제공

## 프로젝트 목적

1. **스펙 정의**: Agent Skills 포맷의 공식 명세
2. **참조 구현**: Python 라이브러리로 구현 예시 제공
3. **문서화**: 완전한 문서 및 가이드 제공
4. **커뮤니티**: 오픈 소스로 기여 유도

## 결론

Agent Skills 공식 프로젝트는:
- ✅ 명확하고 완전한 스펙 정의
- ✅ 참조 구현 제공 (Python)
- ✅ 상세한 문서화
- ✅ 오픈 소스 커뮤니티 지원
- ✅ Anthropic의 공식 지원

이 프로젝트는 Agent Skills 표준의 **공식 참조**로, 다른 구현들이 따를 수 있는 기준점을 제공합니다.
