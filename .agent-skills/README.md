# Agent Skills Developer Guide

이 문서는 `.agent-skills/` 저장소의 **개발자 종합 가이드**입니다. 루트 `README.md`보다 상세하며, 스킬 사용/설치/통합/확장/기여 전 과정을 다룹니다.

## 목적
- Agent Skills의 구조, 사용법, 확장 방법을 한 문서에서 제공
- Claude Code, ChatGPT, Gemini 각각의 통합 방법을 명확히 안내
- 팀 단위 운영(멀티 모델 워크플로우)을 위한 실전 가이드 제공

---

## 구현된 Skills (총 31개, 전부 ✅)

아래 목록은 **모든 스킬이 구현됨(✅)** 상태이며, **8개 카테고리**로 정리되어 있습니다.

### Backend (5)
- ✅ api-design
- ✅ authentication-setup
- ✅ backend-testing
- ✅ database-schema-design
- ✅ toon-demo

### Frontend (4)
- ✅ responsive-design
- ✅ state-management
- ✅ ui-component-patterns
- ✅ web-accessibility

### Code Quality (4)
- ✅ code-refactoring
- ✅ code-review
- ✅ performance-optimization
- ✅ testing-strategies

### Infrastructure (5)
- ✅ deployment-automation
- ✅ jekyll-site-setup
- ✅ monitoring-observability
- ✅ security-best-practices
- ✅ system-environment-setup

### Documentation (4)
- ✅ api-documentation
- ✅ changelog-maintenance
- ✅ technical-writing
- ✅ user-guide-writing

### Project Management (4)
- ✅ sprint-retrospective
- ✅ standup-meeting
- ✅ task-estimation
- ✅ task-planning

### Search & Analysis (1)
- ✅ codebase-search

### Utilities (4)
- ✅ environment-setup
- ✅ file-organization
- ✅ git-workflow
- ✅ workflow-automation

---

## 플랫폼별 상세 사용법

### 1) Claude Code (자동 발견)

Claude Code는 `.claude/skills/` 또는 `~/.claude/skills/` 아래의 스킬을 **자동 발견**합니다.
`.agent-skills/`에서 스킬을 복사해 두면 Claude가 자동으로 스킬을 사용합니다.

**설정 방법 (권장: setup.sh 사용):**
```bash
chmod +x setup.sh
./setup.sh
# 메뉴에서 1) Claude 선택
```

**수동 설정 예시:**
```bash
mkdir -p ../.claude/skills
cp -r backend frontend code-quality infrastructure documentation project-management search-analysis utilities ../.claude/skills/
```

**Claude 사용 예시:**
```
"REST API 설계해줘"
"이 PR 코드 리뷰 해줘"
"접근성 기준에 맞게 컴포넌트 개선해줘"
```

---

### 2) ChatGPT (Custom GPT + 템플릿)

ChatGPT는 Claude처럼 자동 스킬 로딩이 없으므로, **Custom GPT + 템플릿** 접근이 표준입니다.

**권장 워크플로우:**
1. 템플릿 복사
   ```bash
   cp -r templates/chatgpt-skill-template chatgpt/my-skill
   ```

2. `chatgpt/my-skill/skills.md` 편집
   - 스킬 목적/트리거/절차/예시/출력 포맷 작성
   - "Instructions 탭에 넣을 압축 버전" 섹션 필수 작성

3. Custom GPT Builder에서:
   - Instructions 탭에 압축 버전 붙여넣기
   - 필요 시 Knowledge 업로드

**템플릿 위치:** `templates/chatgpt-skill-template/`

**Quick Example (요약형 Instructions):**
```text
You use Agent Skills. When a request matches a skill description:
1) find the matching SKILL.md
2) follow its steps precisely
3) output in the specified format
```

---

### 3) Gemini (Python 통합)

Gemini는 Python 통합 방식이 가장 효율적입니다.
`skill_loader.py`로 스킬을 로드해 프롬프트에 포함합니다.

**기본 예시:**
```python
from skill_loader import SkillLoader
import google.generativeai as genai

loader = SkillLoader('.agent-skills')
skill = loader.get_skill('api-design')

prompt = f"""{skill['full_content']}

Now help me design a REST API for user management.
"""

genai.configure(api_key='YOUR_API_KEY')
model = genai.GenerativeModel('gemini-2.0-flash-exp')
response = model.generate_content(prompt)
print(response.text)
```

**setup.sh로 GEMINI.md 생성:**
```bash
./setup.sh
# 메뉴에서 3) Gemini 선택
```

---

## setup.sh 상세 설명

`setup.sh`는 플랫폼별 설치 및 구성 자동화를 담당합니다.

**실행:**
```bash
chmod +x setup.sh
./setup.sh
```

**메뉴 설명:**
1) **Claude**
   - `.claude/skills/` 및 `~/.claude/skills/`에 스킬 복사
   - 스킬 검증(가능 시) 수행
2) **ChatGPT**
   - 스킬 폴더를 ZIP으로 압축하여 Knowledge 업로드 용 파일 생성
3) **Gemini**
   - `GEMINI.md` 생성 (표준 컨텍스트)
   - 옵션으로 CLI Extension 스캐폴드 생성
4) **All**
   - Claude + ChatGPT + Gemini를 한 번에 구성
5) **Validate**
   - `validate_claude_skills.py`로 스킬 포맷 검증
6) **Exit**

---

## skill_loader.py 사용법

`skill_loader.py`는 스킬 로딩/검색/검증/프롬프트 생성에 사용합니다.

### CLI 사용

**스킬 목록:**
```bash
python3 skill_loader.py list
```

**스킬 검색:**
```bash
python3 skill_loader.py search api
```

**스킬 보기:**
```bash
python3 skill_loader.py show api-design
```

**프롬프트 생성 (Markdown/XML/JSON/TOON):**
```bash
python3 skill_loader.py prompt --skills api-design code-review --format markdown
python3 skill_loader.py prompt --skills api-design --format toon
```

**검증:**
```bash
python3 skill_loader.py validate
python3 skill_loader.py validate api-design
```

### Python 사용

```python
from skill_loader import SkillLoader

loader = SkillLoader('.agent-skills')
print(loader.list_skills())
print(loader.format_for_prompt(['api-design', 'code-review'], format_type='markdown'))
```

---

## 새 Skill 추가 방법 (상세 단계)

1) **카테고리 선택**
   - `backend/`, `frontend/`, `code-quality/`, `infrastructure/`, `documentation/`, `project-management/`, `search-analysis/`, `utilities/`

2) **폴더 생성 (kebab-case)**
```bash
mkdir -p .agent-skills/backend/new-skill
```

3) **SKILL.md 작성 (YAML frontmatter 포함)**
```markdown
---
name: new-skill
description: Describe what this skill does and when to use it
allowed-tools: [python, bash]
---

# New Skill

## Purpose
- ...

## When to Trigger
- ...

## Procedure
1. ...
2. ...

## Output Format
- ...

## Constraints
- ...
```

4) **지원 파일 추가 (선택)**
- `references/`, `templates/`, `examples/` 등
- 스킬 문서에서 직접 참조

5) **검증**
```bash
python3 skill_loader.py validate new-skill
```

6) **문서 업데이트**
- 이 README의 스킬 목록에 추가
- 필요 시 `CONTRIBUTING.md` 절차 준수

7) **(ChatGPT 전용) 템플릿 기반 스킬 설계**
- `templates/chatgpt-skill-template/` 참고

---

## 멀티 모델 워크플로우

여러 모델의 강점을 결합해 품질과 속도를 높이는 방식입니다.

**예시 파이프라인:**
1. **Claude Code**: 자동 스킬 탐지로 초안 생성
2. **ChatGPT Custom GPT**: 템플릿 기반 상세화/정리
3. **Gemini**: Python 통합으로 데이터/코드 분석 자동화

**실전 운영 팁:**
- 동일한 스킬 콘텐츠를 `skill_loader.py`로 추출해 모델 간 일관성 유지
- Claude는 탐색/실행, ChatGPT는 문서화, Gemini는 자동화에 집중

---

## 기여 가이드

기여 절차는 다음 문서를 참고하세요:

**[CONTRIBUTING.md](CONTRIBUTING.md)**

---

## 빠른 참조

- **setup.sh**: 플랫폼별 설정 자동화
- **skill_loader.py**: 스킬 로딩/검증/프롬프트 생성
- **templates/**: 스킬 작성 템플릿
- **[CONTRIBUTING.md](CONTRIBUTING.md)**: 기여 규칙
- **[상위 README](../README.md)**: 프로젝트 개요

---

**최종 업데이트**: 2026-01-04
**작성**: Multi-Model AI Workflow (Gemini + Claude + Codex)
