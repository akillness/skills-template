# Contributing to Agent Skills

Agent Skills에 기여해주셔서 감사합니다! 이 가이드는 새로운 Skill을 추가하거나 기존 Skill을 개선하는 방법을 설명합니다.

## 목차

1. [시작하기](#시작하기)
2. [Skill 작성 가이드](#skill-작성-가이드)
3. [제출 프로세스](#제출-프로세스)
4. [리뷰 기준](#리뷰-기준)
5. [스타일 가이드](#스타일-가이드)

## 시작하기

### Prerequisites

- Git 기본 지식
- Markdown 작성 능력
- YAML 기본 지식
- 기여하려는 분야에 대한 전문 지식

### 저장소 클론

```bash
git clone https://github.com/yourusername/agent-skills.git
cd agent-skills/.agent-skills
```

## Skill 작성 가이드

### 1. 적절한 카테고리 선택

새 Skill을 추가하기 전에 적절한 카테고리를 선택하세요:

- `infrastructure/`: 시스템 설정, 배포, 모니터링
- `backend/`: API, 데이터베이스, 인증
- `frontend/`: UI, 상태 관리, 디자인
- `documentation/`: 문서 작성
- `code-quality/`: 코드 리뷰, 리팩토링, 테스팅
- `search-analysis/`: 검색, 분석, 패턴 감지
- `project-management/`: 프로젝트 관리, 계획
- `utilities/`: 유틸리티 및 자동화

새 카테고리가 필요하다면 Issue를 열어 논의하세요.

### 2. Skill 폴더 생성

```bash
# 예: backend 카테고리에 새 skill 추가
mkdir -p backend/my-new-skill
cd backend/my-new-skill
```

### 3. SKILL.md 작성

`templates/` 폴더의 템플릿을 사용하세요:

```bash
cp ../../templates/basic-skill-template/SKILL.md ./SKILL.md
```

#### 필수 구조

```markdown
---
name: skill-name
description: Clear description of what this skill does and when to use it. Include key technologies and use cases.
---

# Skill Name

## When to use this skill
- Scenario 1
- Scenario 2
- Scenario 3

## Instructions

### Step 1: [First Action]
Detailed instructions...

### Step 2: [Second Action]
More details...

## Examples

### Example 1: [Scenario]
```language
code example
```

### Example 2: [Scenario]
```language
code example
```

## Best practices
- Practice 1
- Practice 2
- Practice 3

## References
- [External resource](link)
```

### 4. 메타데이터 작성

**name 필드**:
- 소문자만 사용
- 숫자와 하이픈만 특수문자로 허용
- 최대 64자
- 설명적이고 명확해야 함

**좋은 예**:
- `api-design`
- `code-review`
- `docker-deployment`

**나쁜 예**:
- `API_Design` (대문자)
- `my skill` (공백)
- `skill1` (불명확)

**description 필드**:
- 최대 1024자
- 무엇을 하는지 명확히 설명
- 언제 사용하는지 명시
- 관련 기술/도구 포함
- AI가 자동으로 발견할 수 있도록 구체적으로 작성

**좋은 예**:
```yaml
description: Design RESTful and GraphQL APIs following best practices. Use when creating new APIs, refactoring endpoints, or documenting API specifications. Handles OpenAPI, REST, GraphQL, versioning.
```

**나쁜 예**:
```yaml
description: For API design
```

### 5. 지원 파일 추가 (선택사항)

복잡한 Skill의 경우 추가 파일을 포함할 수 있습니다:

```
my-skill/
├── SKILL.md                 # Required
├── README.md                # Optional: Additional context
├── REFERENCE.md             # Optional: Detailed reference
├── EXAMPLES.md              # Optional: More examples
├── TROUBLESHOOTING.md       # Optional: Common issues
├── scripts/                 # Optional: Executable scripts
│   ├── setup.sh
│   └── helper.py
├── templates/               # Optional: Template files
│   ├── config.yaml
│   └── template.txt
└── assets/                  # Optional: Images, diagrams
    └── architecture.png
```

### 6. 지침(Instructions) 작성 팁

**명확성**:
- 단계별로 명확하게 작성
- 기술 용어는 설명과 함께 사용
- 예제를 풍부하게 포함
- 명령어는 코드 블록으로 표시

**완전성**:
- Prerequisites 명시
- 에러 처리 방법 포함
- Edge cases 다루기
- 대안 제시

**구조**:
- 논리적 순서로 배열
- 헤딩으로 섹션 구분
- 리스트와 테이블 활용
- 시각 자료 포함 (다이어그램, 코드 예제)

### 7. 예제 작성

**구체적인 예제**:
```markdown
## Examples

### Example 1: Basic usage
When user needs to [specific scenario]:

```python
# Clear, working code example
def example_function():
    return "result"
```

**Expected output**:
```
result
```

### Example 2: Advanced usage
For more complex scenarios:

```python
# More sophisticated example
class AdvancedExample:
    def __init__(self):
        self.value = 0
    
    def process(self):
        # Detailed implementation
        pass
```
```

### 8. Best Practices 섹션

실무 경험에서 나온 실질적인 조언을 포함하세요:

```markdown
## Best practices

1. **Principle 1**: Explanation and why it matters
2. **Principle 2**: Concrete examples
3. **Principle 3**: Common pitfalls to avoid
4. **Principle 4**: Performance considerations
5. **Principle 5**: Security best practices
```

### 9. 참고 자료

신뢰할 수 있는 외부 리소스를 링크하세요:

```markdown
## References

- [Official Documentation](https://example.com/docs)
- [Best Practices Guide](https://example.com/guide)
- [Community Tutorial](https://example.com/tutorial)
- [Related RFC/Standard](https://example.com/rfc)
```

## 제출 프로세스

### 1. 로컬에서 테스트

Skill을 작성한 후 반드시 테스트하세요:

**Claude 테스트**:
```bash
# .claude/skills/에 복사
cp -r backend/my-new-skill .claude/skills/

# Claude에서 테스트
# 관련 작업을 요청하고 Skill이 활성화되는지 확인
```

**ChatGPT 테스트**:
```bash
# 프롬프트 생성
python skill_loader.py prompt --skills my-new-skill --output prompt.txt

# prompt.txt를 ChatGPT에 붙여넣고 테스트
```

**검증**:
```bash
# YAML 유효성 검사
python3 -c "import yaml; yaml.safe_load(open('backend/my-new-skill/SKILL.md').read().split('---')[1])"

# 메타데이터 확인
python skill_loader.py show my-new-skill
```

### 2. Branch 생성

```bash
git checkout -b add-my-new-skill
```

### 3. 변경사항 커밋

```bash
git add backend/my-new-skill/
git commit -m "Add my-new-skill for [purpose]

- Handles [feature 1]
- Includes [feature 2]
- Tested with Claude/ChatGPT/Gemini"
```

### 4. Pull Request 생성

Pull Request에 다음 정보를 포함하세요:

```markdown
## Description
Brief description of the skill and its purpose

## Category
- [ ] Infrastructure
- [ ] Backend
- [x] Code Quality
- [ ] Other: ___

## Checklist
- [x] SKILL.md follows template structure
- [x] Name uses lowercase and hyphens only
- [x] Description is clear and specific
- [x] Instructions are step-by-step
- [x] Examples are included
- [x] Best practices section included
- [x] References added
- [x] Tested with at least one AI platform
- [x] No linting errors

## Testing
Describe how you tested this skill:
- Platform: Claude
- Test scenario: [describe]
- Result: [success/issues]

## Additional Notes
Any special considerations or future improvements
```

## 리뷰 기준

Pull Request는 다음 기준으로 리뷰됩니다:

### 필수 요구사항
- [ ] SKILL.md 존재
- [ ] 유효한 YAML frontmatter
- [ ] name과 description 필드 존재
- [ ] name이 규칙을 따름 (소문자, 하이픈만)
- [ ] 적절한 카테고리에 위치

### 품질 기준
- [ ] 명확하고 구체적인 설명
- [ ] 단계별 지침
- [ ] 실용적인 예제
- [ ] Best practices 포함
- [ ] 참고 자료 링크
- [ ] 문법 및 맞춤법 확인

### 기술적 정확성
- [ ] 코드 예제가 작동함
- [ ] 보안 best practices 준수
- [ ] 최신 기술/패턴 사용
- [ ] Edge cases 고려

### 사용성
- [ ] AI가 쉽게 발견 가능
- [ ] 다양한 플랫폼에서 사용 가능
- [ ] 재사용 가능한 구조
- [ ] 유지보수 가능

## 스타일 가이드

### Markdown 스타일

**헤딩**:
```markdown
# H1: Skill 제목
## H2: 주요 섹션
### H3: 하위 섹션
```

**코드 블록**:
````markdown
```python
# 언어 지정 필수
def example():
    pass
```
````

**리스트**:
```markdown
- 항목 1
- 항목 2
  - 하위 항목 2.1
  - 하위 항목 2.2
```

**링크**:
```markdown
[Link text](URL)
[Internal reference](REFERENCE.md)
```

**테이블**:
```markdown
| Column 1 | Column 2 |
|----------|----------|
| Data 1   | Data 2   |
```

### 코드 스타일

**Python**:
- PEP 8 준수
- 타입 힌트 사용
- Docstrings 포함

**JavaScript/TypeScript**:
- ESLint 규칙 준수
- 명확한 변수명
- JSDoc 주석

**Bash**:
- ShellCheck 통과
- 명확한 주석
- 에러 처리

### 네이밍 규칙

**파일명**:
- `SKILL.md`: 필수 (대문자)
- `README.md`: 선택
- `REFERENCE.md`: 선택
- 스크립트: `setup.sh`, `helper.py` (소문자)

**폴더명**:
- 소문자
- 하이픈 사용
- 설명적인 이름

## 커뮤니티 가이드라인

### 행동 강령

- 존중하고 포용적인 태도
- 건설적인 피드백
- 협력적 문제 해결
- 다양성 존중

### 의사소통

- Issue에서 아이디어 논의
- PR에서 명확한 설명
- 리뷰에 신속하게 응답
- 문서화 우선

### 유지보수

- 정기적인 업데이트
- 버그 수정
- 커뮤니티 피드백 반영
- 문서 최신화

## 질문 및 도움

### 도움을 받는 방법

1. **Documentation**: README.md와 가이드 문서 확인
2. **Examples**: 기존 Skills 참조
3. **Issues**: 질문이나 제안 Issue 생성
4. **Discussions**: 일반적인 논의

### 연락처

- GitHub Issues: 버그 리포트, 기능 요청
- GitHub Discussions: 일반 질문, 아이디어
- Email: [maintainer-email]
- Slack: [slack-channel] (if applicable)

## 라이선스

기여한 코드는 프로젝트 라이선스(MIT)를 따릅니다.

---

**감사합니다!** 🎉

여러분의 기여로 Agent Skills가 더 나아집니다.

