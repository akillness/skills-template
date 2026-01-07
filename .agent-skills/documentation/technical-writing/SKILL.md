---
name: technical-writing
description: Write clear and effective technical documentation including API docs, user guides, READMEs, and tutorials. Use when documenting code, creating user manuals, or writing technical blog posts. Handles Markdown, documentation tools, and technical communication best practices.
tags: [documentation, technical-writing, markdown, API-docs, README]
platforms: [Claude, ChatGPT, Gemini]
---

# Technical Writing

## 목적 (Purpose)

명확하고 효과적인 기술 문서를 작성합니다.

이 스킬은 다음을 도와줍니다:
- API 문서 작성
- README 파일 작성
- 사용자 가이드 작성
- 기술 블로그 글 작성
- 코드 주석 및 문서화

## 사용 시점 (When to Use)

- **프로젝트 시작**: README 및 기본 문서 작성
- **API 개발**: API 엔드포인트 문서화
- **라이브러리 배포**: 사용법 및 예제 문서 작성
- **기능 추가**: 변경사항 문서화
- **사용자 지원**: 튜토리얼 및 FAQ 작성

## 입력 형식 (Input Format)

### 필수 정보
- **문서 유형**: README, API Docs, User Guide, Tutorial
- **대상 독자**: 개발자, 일반 사용자, 관리자
- **주제**: 문서화할 내용

### 선택 정보
- **형식**: Markdown, RST, AsciiDoc (기본값: Markdown)
- **도구**: Docusaurus, MkDocs, GitBook

## 작업 절차 (Procedure)

상세 예제는 [EXAMPLES.md](./EXAMPLES.md)를 참조하세요.

### 1단계: 문서 구조 설계

문서의 전체 구조를 계획합니다.

**작업 내용**:
- 목차 작성
- 섹션 구분
- 흐름 설계

👉 **상세 예제**: [EXAMPLES.md > 문서 구조](./EXAMPLES.md#1단계-문서-구조-설계)

### 2단계: 명확한 작성

간결하고 명확하게 작성합니다.

**작업 내용**:
- 능동태 사용
- 짧은 문장
- 전문 용어 설명

👉 **상세 예제**: [EXAMPLES.md > 명확한 작성](./EXAMPLES.md#2단계-명확한-작성)

### 3단계: 코드 예제 추가

실제 동작하는 코드 예제를 포함합니다.

**확인 사항**:
- [x] 복사/붙여넣기 가능한 코드
- [x] 주석 포함
- [x] 예상 출력 표시

👉 **상세 예제**: [EXAMPLES.md > 코드 예제](./EXAMPLES.md#3단계-코드-예제-추가)

### 4단계: 시각 자료 활용

다이어그램, 스크린샷 등을 추가합니다.

👉 **상세 예제**: [EXAMPLES.md > 시각 자료](./EXAMPLES.md#4단계-시각-자료-활용)

### 5단계: 검토 및 개선

문서를 검토하고 개선합니다.

👉 **상세 예제**: [EXAMPLES.md > 검토](./EXAMPLES.md#5단계-검토-및-개선)

## 출력 포맷 (Output Format)

```
docs/
├── README.md
├── API.md
├── GUIDE.md
└── images/
    └── diagram.png
```

## 제약사항 (Constraints)

### 필수 규칙 (MUST)

1. **명확성**: 간결하고 명확하게 작성
2. **정확성**: 기술적으로 정확한 내용
3. **완전성**: 필요한 정보 모두 포함

### 금지 사항 (MUST NOT)

1. **전문 용어 남용**: 설명 없이 전문 용어 사용 금지
2. **오래된 정보**: 최신 상태 유지

## 메타데이터

### 버전
- **현재 버전**: 1.0.0

### 태그
`#documentation` `#technical-writing` `#markdown`
