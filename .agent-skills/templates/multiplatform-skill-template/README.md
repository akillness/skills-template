# 멀티플랫폼 스킬 템플릿

이 템플릿은 Claude, ChatGPT, Gemini에서 모두 사용 가능한 스킬을 만들기 위한 표준 형식입니다.

## 특징

- **범용성**: Claude, ChatGPT, Gemini 모든 플랫폼에서 동작
- **표준 구조**: 5가지 핵심 섹션(목적, 사용시점, 절차, 출력, 제약)
- **한국어 최적화**: 한국어 프로젝트에 적합한 구조와 예시
- **실용성**: 실제 프로젝트에서 바로 사용 가능한 형식

## 빠른 시작

### 1. 새 스킬 만들기

```bash
# 스킬 폴더 생성
cd .agent-skills/[카테고리]
mkdir my-new-skill

# 템플릿 복사
cp ../templates/multiplatform-skill-template/SKILL.md my-new-skill/

# 편집
code my-new-skill/SKILL.md
```

### 2. 템플릿 채우기

SKILL.md 파일을 열고 다음 섹션을 채웁니다:

#### 필수 섹션

1. **메타데이터** (YAML front matter)
   ```yaml
   ---
   name: my-skill
   description: 이 스킬이 하는 일
   tags: [tag1, tag2]
   platforms: [Claude, ChatGPT, Gemini]
   ---
   ```

2. **목적** (Purpose)
   - 이 스킬이 해결하는 문제
   - 제공하는 가치

3. **사용 시점** (When to Use)
   - 구체적인 트리거 조건
   - 4-5개의 시나리오

4. **작업 절차** (Procedure)
   - 단계별 작업 순서
   - 각 단계의 구체적인 행동

5. **출력 포맷** (Output Format)
   - 결과물의 정확한 구조
   - 포맷 규칙
   - 구체적인 예시

6. **제약사항** (Constraints)
   - 필수 규칙 (MUST)
   - 금지 사항 (MUST NOT)
   - 보안 규칙

#### 권장 섹션

- **작업 예시**: 실제 사용 사례
- **베스트 프랙티스**: 효과적인 사용 방법
- **자주 발생하는 문제**: 문제 해결 가이드
- **지원 파일**: 템플릿, 스크립트 등

### 3. 플랫폼별 설정

#### Claude
```bash
# 프로젝트 스킬로 설정
cp -r my-new-skill .claude/skills/

# 또는 개인 스킬로 설정
cp -r my-new-skill ~/.claude/skills/
```

#### ChatGPT
1. Custom GPT 생성
2. Knowledge 섹션에 스킬 폴더 업로드
3. Instructions에 다음 추가:
   ```
   Search for SKILL.md files in knowledge base.
   Follow the instructions in SKILL.md exactly.
   ```

#### Gemini
1. 프로젝트 루트의 `GEMINI.md`가 `.agent-skills/` 폴더를 참조하도록 설정
2. Gemini CLI 사용:
   ```bash
   gemini chat --context GEMINI.md
   ```
3. 스킬 호출:
   ```
   Use the [skill-name] skill to [task description]
   ```

## 작성 가이드

### 명확한 트리거 조건

❌ 나쁜 예:
```markdown
## 사용 시점
- 코드를 리뷰할 때
```

✅ 좋은 예:
```markdown
## 사용 시점
- 사용자가 "코드 리뷰해줘" 또는 "이 코드 검토" 요청 시
- Pull Request 검토 요청 시
- 코드 품질 개선이 필요한 경우
- 보안 취약점 검사 요청 시
```

### 구체적인 절차

❌ 나쁜 예:
```markdown
### 1단계: 코드 분석
코드를 분석합니다.
```

✅ 좋은 예:
```markdown
### 1단계: 코드 구조 파악

**작업 내용**:
1. 파일 전체를 읽어서 주요 함수/클래스 식별
2. 각 함수의 역할과 의존성 파악
3. 복잡도가 높은 부분(10줄 이상 함수, 중첩 if문) 체크

**확인 사항**:
- [ ] 모든 public 함수 확인 완료
- [ ] import/dependency 파악 완료
- [ ] 테스트 코드 유무 확인
```

### 명확한 출력 포맷

❌ 나쁜 예:
```markdown
## 출력 포맷
결과를 보기 좋게 정리해서 출력
```

✅ 좋은 예:
```markdown
## 출력 포맷

```
# 코드 리뷰 결과

## 개요
- 리뷰 대상: [파일명]
- 전체 평가: [Good/Fair/Poor]
- 주요 이슈: [개수]

## 발견된 이슈

### 1. [이슈 제목] (심각도: High/Medium/Low)
**위치**: [파일명:줄번호]
**문제**: [구체적인 문제점]
**권장사항**: [해결 방법]

## 긍정적인 부분
- [잘된 점 1]
- [잘된 점 2]

## 다음 단계
- [ ] [개선 사항 1]
- [ ] [개선 사항 2]
```
```

### 실용적인 제약사항

❌ 나쁜 예:
```markdown
## 제약사항
- 좋은 코드를 작성하세요
```

✅ 좋은 예:
```markdown
## 제약사항

### 필수 규칙
1. **전체 파일 읽기**: 부분만 읽지 말고 파일 전체를 Read 도구로 읽은 후 리뷰
2. **줄번호 명시**: 모든 이슈는 `파일명:줄번호` 형식으로 위치 표시
3. **증거 기반**: 추측이 아닌 실제 코드를 인용하여 근거 제시

### 금지 사항
1. **추측 금지**: 보지 않은 파일에 대해 언급하지 않음
2. **과도한 칭찬 금지**: "완벽합니다" 같은 무의미한 칭찬 자제
3. **보안정보 노출 금지**: API 키, 비밀번호 등이 있으면 경고만 하고 값은 출력하지 않음
```

## 체크리스트

새 스킬을 만들 때 다음을 확인하세요:

### 내용
- [ ] 메타데이터(name, description, tags, platforms) 작성
- [ ] 목적이 명확하게 설명됨
- [ ] 4개 이상의 구체적인 사용 시점 명시
- [ ] 단계별 절차가 실행 가능한 수준으로 작성됨
- [ ] 출력 포맷이 구체적인 예시와 함께 제시됨
- [ ] 제약사항에 MUST와 MUST NOT이 명확히 구분됨
- [ ] 최소 2개의 작업 예시 포함

### 품질
- [ ] 모든 섹션이 한국어로 작성됨 (코드 제외)
- [ ] 추상적인 표현 대신 구체적인 지시사항 사용
- [ ] 실제로 실행 가능한 절차인지 검증
- [ ] 예시가 실제 사용 사례를 반영함
- [ ] 출력 포맷 예시가 완전한 형태로 제시됨

### 재사용성
- [ ] 특정 프로젝트에 종속되지 않은 일반적인 구조
- [ ] 다른 사람이 읽고 바로 이해할 수 있는 수준
- [ ] Claude, ChatGPT, Gemini 모두에서 작동 가능
- [ ] 지원 파일(템플릿, 스크립트)이 필요하면 포함됨

## 예시 스킬

실제 작성된 스킬 예시를 참고하세요:

```bash
# 코드 리뷰 스킬
.agent-skills/code-quality/code-review/SKILL.md

# API 설계 스킬
.agent-skills/backend/api-design/SKILL.md

# 기술 문서 작성 스킬
.agent-skills/documentation/technical-writing/SKILL.md
```

## 팁

### 1. 작은 것부터 시작
- 복잡한 스킬을 만들기 전에 간단한 스킬부터 시작하세요
- basic-skill-template으로 시작해서 점진적으로 개선

### 2. 실제 사용하면서 개선
- 처음부터 완벽할 필요 없음
- 실제로 사용하면서 부족한 부분을 채워나가기

### 3. 기존 스킬 참고
- 이미 잘 만들어진 스킬의 구조를 참고
- 특히 출력 포맷과 제약사항 부분

### 4. 플랫폼별 테스트
- Claude, ChatGPT, Gemini에서 각각 테스트
- 플랫폼마다 다르게 해석되는 부분이 있으면 수정

## 문제 해결

### Q: 스킬이 트리거되지 않아요
**A**: "사용 시점" 섹션을 더 구체적으로 작성하고, 사용자가 사용할 만한 키워드를 포함하세요.

### Q: 결과가 일관성이 없어요
**A**: "출력 포맷"을 더 엄격하게 정의하고, 구체적인 예시를 추가하세요.

### Q: AI가 제약사항을 무시해요
**A**: "제약사항"을 "필수 규칙"으로 바꾸고, 각 절차 단계에도 제약사항을 반복해서 명시하세요.

### Q: ChatGPT에서 작동이 안 돼요
**A**: Custom GPT Instructions에 스킬 시스템 규칙이 제대로 설정되었는지 확인하세요.

### Q: Gemini에서 작동이 안 돼요
**A**: 프로젝트 루트의 GEMINI.md가 존재하고, 스킬 폴더를 올바르게 참조하는지 확인하세요.

## 더 알아보기

- [Agent Skills 공식 문서](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [ChatGPT Skills 가이드](https://simonw.substack.com/p/openai-are-quietly-adopting-skills)
- [Gemini CLI GEMINI.md](https://geminicli.com/docs/cli/gemini-md/)
- [Skill Seekers - 멀티플랫폼 도구](https://www.reddit.com/r/mcp/comments/1py1t6z/release_skill_seekers_v250_multiplatform_support/)

## 기여

더 나은 템플릿이나 예시가 있으면 기여해 주세요!

1. 템플릿 개선사항 제안
2. 실제 사용 사례 공유
3. 플랫폼별 최적화 팁 추가
