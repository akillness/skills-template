# Agent Skills 설정 프롬프트 (TOON 포맷)

AI 에이전트에게 Agent Skills 시스템을 설정하고 구성하도록 요청하는 구조화된 프롬프트입니다.

---

## 📋 TOON 프롬프트: Agent Skills 시스템 설정

### T - Task (작업)
Agent Skills 시스템을 설치하고 설정하여 Claude, ChatGPT, Gemini에서 사용할 수 있도록 준비합니다.

### O - Objective (목표)
1. 대상 플랫폼 선택 및 설정
2. Skills 폴더 구조 생성 또는 검증
3. 필요한 도구 및 스크립트 설치
4. Skills 활성화 및 테스트
5. 팀 공유 설정 (선택사항)

### O - Output (출력)
플랫폼별로 다음을 완료합니다:

**Claude**:
- Personal Skills: `~/.claude/skills/` 설정
- Project Skills: `.claude/skills/` 설정
- Skills 자동 인식 확인

**ChatGPT**:
- Skills zip 파일 생성
- Custom GPT Instructions 템플릿
- Knowledge 업로드 가이드

**Gemini**:
- Python 환경 설정
- `skill_loader.py` 통합
- API 연동 코드

### N - Notes (주의사항)

#### 전제 조건
- Git 설치 (팀 공유 시)
- Python 3.8+ (Gemini, 유틸리티 사용 시)
- 쓰기 권한 (홈 디렉토리, 프로젝트 디렉토리)

#### 주의사항
- 기존 Skills를 덮어쓰지 않도록 확인
- 플랫폼별 제약사항 이해
- 테스트 후 프로덕션 적용

---

## 🎯 프롬프트 사용 예제

### 예제 1: Claude 자동 설정

```
@setup_skills_prompt.md 를 참조하여 Claude를 설정해줘:

**Task**: Agent Skills를 Claude에서 사용할 수 있도록 설정

**Target Platform**: Claude (Cursor, Claude Code)

**Setup Type**: 
- [ ] Personal Skills (모든 프로젝트에서 사용)
- [x] Project Skills (현재 프로젝트만)
- [ ] Both

**Objective**:
1. .agent-skills/ 폴더 확인
2. Skills를 .claude/skills/로 복사
3. Git에 추가 (프로젝트 Skills의 경우)
4. Skills 자동 인식 테스트

**Actions**:
1. 현재 .agent-skills/ 구조 확인
2. .claude/skills/ 디렉토리 생성
3. Skills 복사 (backend, frontend, documentation, code-quality 등)
4. SKILL.md 파일들의 YAML 유효성 검증
5. 테스트 프롬프트 제공

**Output**:
- 설정 완료 확인 메시지
- 테스트 명령어
- 사용 예제
```

### 예제 2: ChatGPT Custom GPT 설정

```
@setup_skills_prompt.md 를 참조하여 ChatGPT용 설정 파일을 생성해줘:

**Task**: Agent Skills를 ChatGPT Custom GPT에서 사용할 수 있도록 준비

**Target Platform**: ChatGPT (Custom GPT)

**Objective**:
1. Skills zip 파일 생성
2. Custom GPT Instructions 작성
3. 업로드 가이드 제공

**Requirements**:
- .agent-skills/ 폴더의 모든 구현된 Skills 포함
- 템플릿 파일 제외
- 최적화된 압축

**Output**:
1. agent-skills-[date].zip 파일
2. custom_gpt_instructions.txt (Instructions용)
3. custom_gpt_setup_guide.md (업로드 가이드)

**Instructions Content Should Include**:
- Skills 사용 방법
- SKILL.md 파일 찾는 방법
- Skills 활성화 로직
- 사용 가능한 Skills 목록
```

### 예제 3: Gemini API 통합

```
@setup_skills_prompt.md 를 참조하여 Gemini 통합 코드를 작성해줘:

**Task**: Agent Skills를 Gemini API와 통합

**Target Platform**: Gemini (API)

**Setup Type**: Python 스크립트

**Objective**:
1. google-generativeai 패키지 설치
2. skill_loader.py 통합
3. Gemini API 호출 래퍼 작성
4. 사용 예제 제공

**Output Requirements**:
1. requirements.txt 업데이트
2. gemini_skills_integration.py 작성
3. 환경 변수 설정 가이드 (.env.example)
4. 사용 예제 스크립트

**Integration Features**:
- Skills 자동 로드
- 쿼리 기반 Skill 선택
- 프롬프트 자동 생성
- 에러 핸들링
- 로깅

**Example Usage**:
```python
from gemini_skills_integration import GeminiWithSkills

client = GeminiWithSkills(api_key="...")
response = client.ask("Design a REST API for user management", 
                      use_skills=["api-design"])
print(response)
```
```

### 예제 4: 전체 플랫폼 설정

```
@setup_skills_prompt.md 를 참조하여 모든 플랫폼에서 사용할 수 있도록 설정해줘:

**Task**: Agent Skills를 Claude, ChatGPT, Gemini 모두에서 사용 가능하도록 설정

**Target Platforms**: All (Claude, ChatGPT, Gemini)

**Objective**:
1. Claude: Personal + Project Skills 설정
2. ChatGPT: zip 파일 + Instructions 생성
3. Gemini: Python 통합 코드 작성
4. 크로스 플랫폼 테스트

**Setup Steps**:
1. **Claude**:
   - ~/.claude/skills/ 설정
   - .claude/skills/ 설정
   - Git 추가

2. **ChatGPT**:
   - zip 생성
   - Instructions 작성
   - 업로드 가이드

3. **Gemini**:
   - Python 환경 설정
   - 통합 스크립트 작성
   - 테스트 코드

**Output**:
- setup_summary.md (설정 요약)
- 플랫폼별 설정 파일
- 통합 테스트 스크립트
- 사용 가이드
```

### 예제 5: 팀 공유 설정

```
@setup_skills_prompt.md 를 참조하여 팀과 공유할 수 있도록 Git 설정을 해줘:

**Task**: Agent Skills를 Git을 통해 팀과 공유

**Objective**:
1. .agent-skills/ 폴더를 Git에 추가
2. .gitignore 검토 및 수정
3. README 업데이트
4. 팀 온보딩 가이드 작성

**Git Setup**:
- .agent-skills/ 전체 추가
- .claude/skills/ 추가 (프로젝트 Skills)
- 적절한 커밋 메시지
- 브랜치 전략 (선택사항)

**Documentation**:
- TEAM_ONBOARDING.md 작성
- 팀원별 설정 방법
- 플랫폼별 가이드
- 트러블슈팅

**Output**:
1. Git 커밋 준비
2. TEAM_ONBOARDING.md
3. 팀 공지 템플릿 (Slack/Email)
```

---

## 📝 빠른 시작 템플릿

### Claude 설정 (최소)

```
@setup_skills_prompt.md

Claude 설정:
- Type: Project Skills
- Action: .agent-skills/를 .claude/skills/로 복사
```

### ChatGPT 설정 (최소)

```
@setup_skills_prompt.md

ChatGPT 설정:
- Action: zip 파일 생성
- Output: agent-skills.zip + instructions.txt
```

### Gemini 설정 (최소)

```
@setup_skills_prompt.md

Gemini 설정:
- Action: Python 통합 스크립트 작성
- Features: skill_loader.py 활용
```

---

## 🔧 설정 스크립트 사용

기존 `setup.sh` 스크립트를 사용하는 프롬프트:

```
@setup_skills_prompt.md
@.agent-skills/setup.sh

**Task**: setup.sh 스크립트 실행 및 검증

**Platform**: [Claude/ChatGPT/Gemini/All]

**Objective**:
1. setup.sh 실행
2. 선택한 플랫폼 설정
3. 설정 검증
4. 테스트

**Commands**:
```bash
cd /Users/supercent/Documents/Github/doc/.agent-skills
./setup.sh
```

**After Setup**:
- 설정 결과 확인
- 테스트 프롬프트 실행
- 문제 발생 시 트러블슈팅
```

---

## ✅ 설정 검증 프롬프트

설정 후 검증:

```
@setup_skills_prompt.md

**Task**: Agent Skills 설정 검증

**Platform**: [설정한 플랫폼]

**Verification Steps**:

1. **파일 구조 확인**:
```bash
# Claude
ls -la ~/.claude/skills/
ls -la .claude/skills/

# ChatGPT
ls -lh agent-skills-*.zip

# Gemini
python -c "from skill_loader import SkillLoader; print('OK')"
```

2. **Skills 목록 확인**:
```bash
python .agent-skills/skill_loader.py list
```

3. **특정 Skill 테스트**:
```bash
python .agent-skills/skill_loader.py show api-design
```

4. **YAML 검증**:
```bash
python .agent-skills/skill_loader.py prompt --skills api-design
```

**Expected Results**:
- 모든 Skills 인식됨
- YAML 오류 없음
- 프롬프트 정상 생성

**If Issues**:
- [문제 상황 설명]
- [에러 메시지]
```

---

## 🔄 설정 업데이트 프롬프트

기존 설정 업데이트:

```
@setup_skills_prompt.md

**Task**: Agent Skills 설정 업데이트

**Reason**: [업데이트 이유]
- 새 Skill 추가됨
- 기존 Skill 수정됨
- 플랫폼 추가

**Current Setup**: [현재 설정 상태]

**Update Actions**:
1. 변경사항 확인
2. 영향받는 파일 식별
3. 업데이트 수행
4. 검증

**For Claude**:
```bash
# Skills 재동기화
cp -r .agent-skills/{new-skills} .claude/skills/
```

**For ChatGPT**:
```bash
# 새 zip 생성
./setup.sh
# 옵션 2 선택
```

**For Gemini**:
```bash
# Python 환경 업데이트
pip install -r requirements.txt --upgrade
python skill_loader.py list
```
```

---

## 🐛 트러블슈팅 프롬프트

문제 해결:

```
@setup_skills_prompt.md

**Task**: Agent Skills 설정 문제 해결

**Platform**: [문제 발생 플랫폼]

**Issue Description**:
[문제 상세 설명]

**Error Messages**:
```
[에러 메시지 붙여넣기]
```

**Symptoms**:
- 증상 1
- 증상 2

**Environment**:
- OS: [운영체제]
- Python: [버전]
- Location: [경로]

**Troubleshooting Steps Needed**:
1. 파일 존재 확인
2. 권한 확인
3. YAML 유효성 검사
4. 로그 분석
5. 해결책 제시
```

---

## 📊 설정 상태 확인 프롬프트

현재 설정 상태 확인:

```
@setup_skills_prompt.md

**Task**: Agent Skills 현재 설정 상태 확인

**Check**:
1. 설치된 플랫폼
2. Skills 개수
3. 마지막 업데이트
4. Git 상태

**Generate Report**:
- 플랫폼별 설정 현황
- Skills 목록 및 상태
- 누락된 설정
- 권장 사항

**Output Format**: 
설정 현황 보고서 (Markdown)
```

---

## 🚀 자동화 설정 프롬프트

CI/CD 또는 자동화:

```
@setup_skills_prompt.md

**Task**: Agent Skills 자동 설정 스크립트 작성

**Objective**:
- 새 팀원 자동 온보딩
- CI/CD 파이프라인 통합
- 정기적 동기화

**Requirements**:
1. 비대화형 실행
2. 에러 핸들링
3. 로깅
4. 롤백 기능

**Scripts Needed**:
- auto_setup.sh (자동 설정)
- validate_setup.sh (검증)
- sync_skills.sh (동기화)

**Features**:
- 플랫폼 자동 감지
- 환경 변수 설정
- 의존성 자동 설치
- 검증 및 테스트
```

---

## 📚 참고 자료

### 설정 관련 파일
- **자동 설정**: `.agent-skills/setup.sh`
- **빠른 시작**: `.agent-skills/QUICKSTART.md`
- **README**: `.agent-skills/README.md`
- **기여 가이드**: `.agent-skills/CONTRIBUTING.md`

### 플랫폼 문서
- **Claude**: https://code.claude.com/docs/ko/skills
- **Agent Skills**: https://agentskills.io/
- **Gemini**: https://ai.google.dev/

### 유틸리티
- **skill_loader.py**: Skills 관리 CLI
- **템플릿**: `.agent-skills/templates/`

---

## 💡 설정 팁

### 1. 단계적 설정
```
1단계: Claude만 설정 (가장 쉬움)
2단계: 테스트 및 검증
3단계: 다른 플랫폼 추가
4단계: 팀 공유
```

### 2. 플랫폼 우선순위
```
우선순위 1: Claude (자동 지원)
우선순위 2: ChatGPT (Custom GPT)
우선순위 3: Gemini (개발 필요)
```

### 3. 점진적 확장
```
초기: 핵심 5개 Skills
중기: 카테고리별 추가
장기: 모든 24개 Skills
```

### 4. 정기적 동기화
```
- 주간: 새 Skills 확인
- 월간: 전체 검토
- 분기: 대규모 업데이트
```

### 5. 문서화
```
- 설정 과정 기록
- 팀원 피드백 수집
- FAQ 업데이트
- 트러블슈팅 사례
```

---

## 🎓 학습 경로

### 초보자
1. `./setup.sh` 실행
2. Claude로 시작
3. 기본 Skills 사용
4. 문서 읽기

### 중급자
1. 모든 플랫폼 설정
2. Custom GPT 생성
3. Python 통합
4. 새 Skills 추가

### 고급자
1. CI/CD 통합
2. 자동화 스크립트
3. 팀 프로세스 구축
4. Skills 기여

---

**버전**: 1.0.0  
**최종 업데이트**: 2024-12-31  
**포맷**: TOON (Task-Objective-Output-Notes)

