# Claude Code 스킬 설정 가이드

## 개요

이 가이드는 Agent Skills를 Claude Code에 설정하는 과정을 안내합니다.
setup.sh 스크립트를 사용하여 자동으로 스킬을 설치할 수 있습니다.

---

## 빠른 시작

### 1단계: setup.sh 실행

```bash
cd /path/to/skills-template/.agent-skills
bash setup.sh
```

### 2단계: Claude 옵션 선택

프롬프트가 나타나면 다음과 같이 입력합니다:

```
Select your AI platform:
1) Claude (Cursor, Claude Code, Claude.ai)
2) ChatGPT (Custom GPT setup instructions)
3) Gemini (Python integration)
4) All platforms (comprehensive setup)
5) Validate Skills (Check standards)
6) Exit

Enter your choice (1-6): 1
```

**`1`을 입력**하여 Claude Code를 선택합니다.

### 3단계: Personal Skills 설정 선택

```
Do you want to set up personal skills in ~/.claude/skills/? (y/n): y
```

**`y`를 입력**하여 개인 스킬을 설치합니다.

---

## Claude Code에서 프롬프트로 실행하기

Claude Code CLI에서 다음 프롬프트를 사용하여 설정할 수 있습니다:

### 프롬프트 예시

```
Github/skills-template/.agent-skills/setup.sh를 실행해서 Claude Code 스킬을 설정해줘.
setup.sh를 실행할 때 옵션 1 (Claude)을 선택하고, personal skills 설정 질문에는 y를 입력해줘.
```

또는 더 자세하게:

```
다음 단계를 실행해줘:
1. Github/skills-template/.agent-skills 디렉토리로 이동
2. setup.sh를 실행
3. 옵션 1 (Claude)을 선택
4. personal skills 설정 질문에 y를 답변
5. 설치된 스킬 목록을 확인
```

---

## 설치 후 확인

### 설치된 스킬 확인

```bash
# 설치된 스킬 개수 확인
find ~/.claude/skills -name "SKILL.md" -o -name "SKILL.toon" | wc -l

# 스킬 디렉토리 구조 확인
ls -la ~/.claude/skills/

# 모든 스킬 파일 목록 보기
find ~/.claude/skills -type f \( -name "SKILL.md" -o -name "SKILL.toon" \) | sort
```

### 정상 설치 시 결과

- **총 30개의 스킬**이 `~/.claude/skills/`에 설치됩니다
- 8개 카테고리: backend, frontend, code-quality, infrastructure, documentation, project-management, search-analysis, utilities

---

## 문제 해결

### 스킬이 복사되지 않는 경우

setup.sh 실행 후 스킬이 0개로 표시되면 다음 명령어로 수동 복사:

```bash
cd /path/to/skills-template/.agent-skills

# Personal skills 수동 복사
cp -r backend frontend code-quality infrastructure documentation project-management search-analysis utilities ~/.claude/skills/

# 복사 확인
find ~/.claude/skills -name "SKILL.md" -o -name "SKILL.toon" | wc -l
```

### Git 저장소에서 프로젝트 스킬 설정

Git 저장소 내에서 실행하면 `.claude/skills/`에도 자동으로 복사됩니다:

```bash
cd /path/to/your/git/project
cd .agent-skills
bash setup.sh
# 옵션 1 선택
```

이 경우 스킬이 두 곳에 설치됩니다:
- `~/.claude/skills/` - 개인 스킬 (모든 프로젝트에서 사용)
- `프로젝트/.claude/skills/` - 프로젝트 스킬 (팀과 공유)

---

## 설치되는 스킬 목록

### Backend Development (5개)
- **api-design**: RESTful 및 GraphQL API 설계
- **authentication-setup**: 인증/인가 시스템 구현
- **backend-testing**: 백엔드 테스트 작성
- **database-schema-design**: 데이터베이스 스키마 설계
- **toon-demo**: TOON 형식 데모

### Frontend Development (4개)
- **responsive-design**: 반응형 웹 디자인
- **state-management**: 상태 관리 패턴
- **ui-component-patterns**: UI 컴포넌트 패턴
- **web-accessibility**: 웹 접근성 구현

### Code Quality (4개)
- **code-refactoring**: 코드 리팩토링
- **code-review**: 코드 리뷰
- **performance-optimization**: 성능 최적화
- **testing-strategies**: 테스팅 전략

### Infrastructure (4개)
- **deployment-automation**: 배포 자동화
- **monitoring-observability**: 모니터링 및 관찰성
- **security-best-practices**: 보안 모범 사례
- **system-environment-setup**: 시스템 환경 설정

### Documentation (4개)
- **api-documentation**: API 문서화
- **changelog-maintenance**: 체인지로그 관리
- **technical-writing**: 기술 문서 작성
- **user-guide-writing**: 사용자 가이드 작성

### Project Management (4개)
- **sprint-retrospective**: 스프린트 회고
- **standup-meeting**: 스탠드업 미팅
- **task-estimation**: 태스크 추정
- **task-planning**: 태스크 계획

### Search & Analysis (1개)
- **codebase-search**: 코드베이스 검색

### Utilities (4개)
- **environment-setup**: 환경 설정
- **file-organization**: 파일 구성
- **git-workflow**: Git 워크플로우
- **workflow-automation**: 워크플로우 자동화

---

## 스킬 사용 방법

스킬은 자연어 요청 시 자동으로 활성화됩니다:

### 사용 예시

```
# API 설계
"Design a REST API for user management"

# 코드 리뷰
"Review my pull request"
"Check this code for security issues"

# 반응형 디자인
"Make this component responsive"
"Optimize this layout for mobile"

# 데이터베이스 설계
"Design a database schema for an e-commerce platform"

# 성능 최적화
"Optimize this React component for better performance"
```

---

## 스킬 검증

Python 3가 설치되어 있으면 스킬을 검증할 수 있습니다:

```bash
cd /path/to/skills-template/.agent-skills
python3 validate_claude_skills.py
```

또는 setup.sh에서 옵션 5를 선택:

```bash
bash setup.sh
# 옵션 5 선택
```

---

## 추가 정보

### 스킬 커스터마이징

개인 스킬을 커스터마이징하려면:

```bash
# 스킬 디렉토리로 이동
cd ~/.claude/skills/

# 원하는 스킬의 SKILL.md 파일 편집
nano backend/api-design/SKILL.md
```

### 새 스킬 추가

템플릿을 사용하여 새 스킬을 만들 수 있습니다:

```bash
cd /path/to/skills-template/.agent-skills/templates
# 템플릿 복사 후 편집
```

### 참고 문서

- **README.md**: Agent Skills 전체 개요
- **QUICKSTART.md**: 빠른 시작 가이드
- **CONTRIBUTING.md**: 스킬 기여 가이드
- **CLAUDE_SKILLS_GUIDE_KR.md**: Claude 스킬 상세 가이드 (한국어)

---

## 문의 및 지원

- 이슈: GitHub Issues
- 문서: 프로젝트 README.md 참조
- 업데이트: `git pull`로 최신 스킬 업데이트

---

**설치 완료 후 Claude Code를 다시 시작하면 스킬이 자동으로 로드됩니다!**
