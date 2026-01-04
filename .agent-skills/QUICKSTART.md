# Agent Skills 빠른 시작 가이드

Agent Skills를 5분 안에 설정하고 사용하는 방법을 안내합니다.

## 1단계: 설정 스크립트 실행

```bash
cd /Users/supercent/Documents/Github/doc/.agent-skills

# 자동 설정 실행
./setup.sh
```

설정 메뉴에서 플랫폼을 선택하세요:
1. Claude (자동 설정)
2. ChatGPT (zip 파일 생성)
3. Gemini (Python 통합)
4. 모든 플랫폼

## 2단계: 첫 번째 Skill 사용

### Claude 사용자

설정이 완료되면 바로 사용 가능합니다:

```
사용자: "REST API를 설계해줘"
→ Claude가 자동으로 'api-design' Skill 활성화
```

```
사용자: "이 코드를 리뷰해줘"
→ Claude가 자동으로 'code-review' Skill 활성화
```

### ChatGPT 사용자

**방법 1: ChatGPT 전용 템플릿 사용 (권장)**

1. 템플릿 복사:
   ```bash
   cp -r templates/chatgpt-skill-template chatgpt/my-skill
   ```

2. skills.md 작성:
   - `chatgpt/my-skill/skills.md` 파일 편집
   - 플레이스홀더(`{SKILL_NAME}`, `{역할}` 등)를 실제 내용으로 교체
   - 스킬의 목적, 사용 방법, 예시 등을 상세히 작성

3. Custom GPT 생성:
   - ChatGPT Builder에서 "Create a GPT" 클릭
   - Instructions 탭 열기
   - `skills.md`의 "7. Instructions 탭에 넣을 압축 버전" 섹션 복사
   - 실제 값으로 교체하여 붙여넣기

4. Knowledge 설정 (선택사항):
   - `skills.md`의 "2.2 Knowledge" 섹션 참고
   - 필요한 문서를 Knowledge에 업로드

5. Actions 설정 (선택사항):
   - `skills.md`의 "3. GPT Actions" 섹션 참고
   - OpenAPI 스키마 작성 및 연결

6. 테스트:
   ```
   사용자: "Design a REST API for user management"
   ```

**방법 2: Knowledge Base 업로드 (레거시)**

1. 생성된 zip 파일 확인:
   ```bash
   ls -lh agent-skills-*.zip
   ```

2. Custom GPT 생성:
   - ChatGPT에서 "Create a GPT" 클릭
   - Knowledge 섹션에 zip 파일 업로드
   - Instructions에 기본 가이드 추가

3. 테스트:
   ```
   사용자: "Design a REST API for user management"
   ```

**템플릿 가이드**: `templates/chatgpt-skill-template/README.md` 참고

### Gemini 사용자

1. Python 스크립트 사용:
   ```python
   from skill_loader import SkillLoader
   
   # Skills 로드
   loader = SkillLoader('.agent-skills')
   
   # 사용 가능한 Skills 확인
   print(loader.list_skills())
   
   # 특정 Skill 가져오기
   skill = loader.get_skill('api-design')
   print(skill['description'])
   ```

2. Gemini API와 통합:
   ```python
   import google.generativeai as genai
   from skill_loader import SkillLoader
   
   # Skills 로드
   loader = SkillLoader('.agent-skills')
   api_skill = loader.get_skill('api-design')
   
   # Gemini 설정
   genai.configure(api_key='YOUR_API_KEY')
   model = genai.GenerativeModel('gemini-pro')
   
   # Skill과 함께 프롬프트 생성
   prompt = f"""
   {api_skill['body']}
   
   Now help me design a REST API for user management with authentication.
   """
   
   response = model.generate_content(prompt)
   print(response.text)
   ```

## 3단계: Skills 탐색

### 사용 가능한 Skills 확인

```bash
# Python 스크립트 사용
python skill_loader.py list
```

**현재 구현된 Skills**:
- ✅ `api-design`: REST/GraphQL API 설계
- ✅ `code-review`: 코드 리뷰
- ✅ `technical-writing`: 기술 문서 작성
- ✅ `codebase-search`: 코드베이스 검색

### Skill 상세 정보 보기

```bash
# 특정 Skill 내용 보기
python skill_loader.py show api-design
```

### Skill 검색

```bash
# 키워드로 검색
python skill_loader.py search "api"
```

## 4단계: 새 Skill 추가

### 간단한 방법

```bash
# 템플릿에서 복사
cp -r templates/basic-skill-template backend/my-new-skill

# SKILL.md 편집
vi backend/my-new-skill/SKILL.md
```

### 상세 방법

1. 적절한 카테고리 선택:
   - `infrastructure/`: 인프라, 시스템
   - `backend/`: API, 데이터베이스
   - `frontend/`: UI, 컴포넌트
   - `documentation/`: 문서 작성
   - `code-quality/`: 코드 리뷰, 테스팅
   - `search-analysis/`: 검색, 분석
   - `project-management/`: 프로젝트 관리
   - `utilities/`: 유틸리티

2. 폴더 생성:
   ```bash
   mkdir -p backend/my-new-skill
   ```

3. SKILL.md 작성:
   ```markdown
   ---
   name: my-new-skill
   description: What it does and when to use it
   ---
   
   # My New Skill
   
   ## When to use this skill
   - Use case 1
   - Use case 2
   
   ## Instructions
   1. Step 1
   2. Step 2
   
   ## Examples
   ...
   ```

4. 테스트:
   ```bash
   python skill_loader.py show my-new-skill
   ```

## 5단계: 팀과 공유 (옵션)

### Git으로 공유

```bash
# Git에 추가
git add .agent-skills/
git commit -m "Add agent skills infrastructure"
git push

# 팀 멤버는 자동으로 받게 됨
git pull
```

### Claude 프로젝트 Skills

```bash
# .claude/skills/로 복사 (프로젝트 Skills)
cp -r backend frontend documentation code-quality .claude/skills/

# Git에 추가
git add .claude/skills/
git commit -m "Add project skills for Claude"
git push
```

## 실전 예제

### 예제 1: API 설계

```
사용자: "전자상거래 시스템을 위한 REST API를 설계해줘. 상품, 주문, 사용자 관리가 필요해."

Claude (api-design Skill 활성화):
- 리소스 정의: products, orders, users
- 엔드포인트 설계:
  * GET /api/v1/products
  * POST /api/v1/orders
  * GET /api/v1/users/{id}
- 인증: JWT 기반
- 페이지네이션: 쿼리 파라미터
- OpenAPI 스펙 생성
```

### 예제 2: 코드 리뷰

```
사용자: "이 pull request를 리뷰해줘"

Claude (code-review Skill 활성화):
1. 코드 구조 분석
2. 보안 취약점 검사
3. 성능 고려사항 확인
4. 테스트 커버리지 검토
5. 구체적인 피드백 제공
```

### 예제 3: 문서 작성

```
사용자: "이 기능에 대한 기술 명세서를 작성해줘"

Claude (technical-writing Skill 활성화):
1. 문서 구조 제안
2. 각 섹션 내용 작성
3. 다이어그램 포함
4. 코드 예제 추가
5. 베스트 프랙티스 반영
```

### 예제 4: 코드베이스 검색

```
사용자: "사용자 인증이 어디서 구현되어 있는지 찾아줘"

Claude (codebase-search Skill 활성화):
1. Semantic search: "user authentication implementation"
2. Grep: "def authenticate" 또는 "function authenticate"
3. 관련 파일 읽기
4. 구현 위치 설명
```

## 문제 해결

### Skills가 작동하지 않음

**Claude**:
```bash
# Skills 위치 확인
ls -la ~/.claude/skills/
ls -la .claude/skills/

# SKILL.md 파일 확인
find .claude/skills -name "SKILL.md"
```

**ChatGPT**:
- 템플릿 방식 사용 시: `skills.md` 파일이 올바르게 작성되었는지 확인
- Instructions 탭에 압축 버전이 올바르게 복사되었는지 확인
- Knowledge 파일이 필요한 경우 업로드되었는지 확인
- Actions 사용 시 OpenAPI 스키마가 올바르게 연결되었는지 확인
- 레거시 방식 사용 시: Custom GPT에 zip 파일이 업로드되었는지 확인

**Gemini**:
```bash
# Python 패키지 확인
python3 -c "import google.generativeai"

# skill_loader 테스트
python skill_loader.py list
```

### YAML 파싱 오류

```bash
# YAML 유효성 검사
python3 -c "
import yaml
content = open('backend/my-skill/SKILL.md').read()
frontmatter = content.split('---')[1]
yaml.safe_load(frontmatter)
print('YAML is valid!')
"
```

### Skills가 발견되지 않음

```bash
# Skills 디렉토리 확인
python skill_loader.py list

# 특정 Skill 확인
python skill_loader.py show skill-name
```

## 다음 단계

### 학습 리소스

1. **상세 가이드**: 
   - [README.md](README.md) - 전체 개요
   - [universal_agent_skills_architecture.md](/Skills/universal_agent_skills_architecture.md) - 아키텍처
   - [claude_skill_template_guide.md](/Skills/claude_skill_template_guide.md) - 작성 가이드

2. **기여하기**:
   - [CONTRIBUTING.md](CONTRIBUTING.md) - 기여 가이드
   - [templates/](templates/) - Skills 템플릿

3. **예제 Skills**:
   - [backend/api-design/](backend/api-design/)
   - [code-quality/code-review/](code-quality/code-review/)
   - [documentation/technical-writing/](documentation/technical-writing/)
   - [search-analysis/codebase-search/](search-analysis/codebase-search/)

### 커뮤니티

- 공식 사이트: [agentskills.io](https://agentskills.io/)
- GitHub: [agentskills/agentskills](https://github.com/agentskills/agentskills)
- Claude Docs: [code.claude.com/docs/ko/skills](https://code.claude.com/docs/ko/skills)

### 고급 사용법

1. **도구 제한**:
   ```yaml
   allowed-tools: Read, Grep, Glob
   ```

2. **다중 파일 Skills**:
   ```
   my-skill/
   ├── SKILL.md
   ├── REFERENCE.md
   ├── scripts/
   └── templates/
   ```

3. **의존성 관리**:
   ```yaml
   description: ... Requires pypdf and pdfplumber packages.
   ```

## 유용한 명령어

```bash
# Skills 목록
python skill_loader.py list

# Skill 검색
python skill_loader.py search "keyword"

# Skill 내용 보기
python skill_loader.py show skill-name

# 프롬프트 생성 (Markdown)
python skill_loader.py prompt --skills api-design code-review

# 프롬프트 생성 (XML, Claude 최적화)
python skill_loader.py prompt --format xml --output prompt.xml

# 프롬프트 생성 (JSON)
python skill_loader.py prompt --format json --output prompt.json

# 파일로 저장
python skill_loader.py prompt --skills api-design --output api-design-prompt.txt
```

## 요약

1. ✅ `./setup.sh` 실행하여 플랫폼 설정
2. ✅ AI 에이전트와 함께 Skills 사용
3. ✅ `python skill_loader.py list`로 Skills 탐색
4. ✅ 템플릿에서 새 Skills 생성
5. ✅ Git으로 팀과 공유

**5분 만에 시작하고, 팀의 생산성을 향상시키세요!** 🚀

