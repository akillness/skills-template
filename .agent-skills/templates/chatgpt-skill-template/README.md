# ChatGPT Skill Template

이 템플릿은 ChatGPT Custom GPT를 위한 내부 설계 문서 템플릿입니다.

## 사용 목적

ChatGPT에는 공식적인 `skills.md` 포맷이 없고, 대신 **Custom GPT 설명서**를 Instructions 탭에 작성하는 방식입니다. 따라서:

- **`skills.md`**: 내부용 설계 문서/템플릿으로 사용
- **Instructions 탭**: `skills.md`의 압축 버전을 옮겨서 사용
- **Actions**: OpenAPI 스키마를 Actions에 연결

## 파일 구조

```
chatgpt-skill-template/
├── skills.md          # 내부 설계 문서 (이 파일)
├── README.md          # 사용 가이드 (이 파일)
└── openapi/           # Actions용 OpenAPI 스키마 (선택사항)
    └── {action_name}.json
```

## 사용 방법

### 1. skills.md 작성
1. `skills.md` 파일을 복사
2. `{SKILL_NAME}`, `{역할}` 등 플레이스홀더를 실제 내용으로 교체
3. 스킬의 목적, 사용 방법, 예시 등을 상세히 작성

### 2. Instructions 탭 설정
1. ChatGPT Builder에서 Custom GPT 생성
2. Instructions 탭 열기
3. `skills.md`의 "7. Instructions 탭에 넣을 압축 버전" 섹션 복사
4. 실제 값으로 교체하여 붙여넣기

### 3. Knowledge 설정 (선택사항)
1. `skills.md`의 "2.2 Knowledge" 섹션 참고
2. 필요한 문서를 Knowledge에 업로드
3. 문서 사용 원칙을 Instructions에 명시

### 4. Actions 설정 (선택사항)
1. `skills.md`의 "3. GPT Actions" 섹션 참고
2. OpenAPI 스키마 작성 (`openapi/{action_name}.json`)
3. ChatGPT Builder의 Actions 탭에서 스키마 연결
4. 사용 규칙을 Instructions에 명시

## 템플릿 섹션 설명

### 1. Skill Summary
스킬의 전체적인 개요를 한눈에 파악할 수 있도록 작성

### 2. ChatGPT 설정 매핑
ChatGPT Builder의 각 탭에 어떤 내용을 넣을지 명시

### 3. GPT Actions
외부 시스템 연동이 필요한 경우 OpenAPI 스키마와 사용 방법

### 4. 예시 프롬프트 & 기대 응답
실제 사용 시나리오와 기대되는 응답 형식

### 5. 운영 및 버전 관리
스킬의 라이프사이클 관리 방법

### 6. 주의/보안 가이드
보안 및 개인정보 보호 관련 주의사항

### 7. Instructions 탭에 넣을 압축 버전
실제로 ChatGPT Builder에 넣을 간결한 버전

## 실무 팁

1. **버전 관리**: `skills.md`와 `openapi.json`을 같은 폴더에서 버전 관리
2. **동기화**: Instructions 변경 시 `skills.md`도 함께 업데이트
3. **테스트**: 핵심 시나리오를 정기적으로 테스트하여 동작 확인
4. **문서화**: 변경 이력을 `skills.md`에 기록하여 추적 가능하게 유지

## 예시

실제 사용 예시는 다음 Skills를 참고하세요:
- `backend/api-design/` - API 설계 스킬
- `code-quality/code-review/` - 코드 리뷰 스킬
- `documentation/technical-writing/` - 기술 문서 작성 스킬

## 참고 자료

- [OpenAI Custom GPT 가이드](https://help.openai.com/en/articles/8554397-creating-a-gpt)
- [GPT Actions 시작하기](https://platform.openai.com/docs/actions/getting-started)
- [OpenAI Actions 라이브러리](https://platform.openai.com/docs/actions/actions-library)
