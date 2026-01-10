# backend-testing

> Write comprehensive backend tests including unit tests, integration tests, and API tests. Use when testing REST APIs, database operations, authenti...

## When to use this skill
이 스킬을 트리거해야 하는 구체적인 상황을 나열합니다:
• **새 기능 개발**: TDD(Test-Driven Development) 방식으로 테스트 먼저 작성
• **API 엔드포인트 추가**: REST API의 성공/실패 케이스 테스트
• **버그 수정**: 회귀 방지를 위한 테스트 추가
• **리팩토링 전**: 기존 동작을 보장하는 테스트 작성
• **CI/CD 설정**: 자동화된 테스트 파이프라인 구축

## Instructions
단계별로 정확하게 따라야 할 작업 순서를 명시합니다.
▶ S1: 테스트 환경 설정
테스트 프레임워크 및 도구를 설치하고 설정합니다.
**작업 내용**:
• 테스트 라이브러리 설치
• 테스트 데이터베이스 설정 (in-memory 또는 별도 DB)
• 환경변수 분리 (.env.test)
• jest.config.js 또는 pytest.ini 설정
**예시** (Node.js + Jest + Supertest):
**jest.config.js**:
**setup.ts** (테스트 전역 설정):
▶ S2: Unit Test 작성 (비즈니스 로직)
개별 함수/클래스의 단위 테스트를 작성합니다.
**작업 내용**:
• 순수 함수 테스트 (의존성 없음)
• 모킹을 통한 의존성 격리
• Edge case 테스트 (경계값, 예외)
• AAA 패턴 (Arrange-Act-Assert)
**판단 기준**:
• 외부 의존성(DB, API) 없음 → 순수 Unit Test
• 외부 의존성 있음 → Mock/Stub 사용
• 복잡한 로직 → 다양한 입력 케이스 테스트
**예시** (비밀번호 검증 함수):
▶ S3: Integration Test (API 엔드포인트)
API 엔드포인트의 통합 테스트를 작성합니다.
**작업 내용**:
• HTTP 요청/응답 테스트
• 성공 케이스 (200, 201)
• 실패 케이스 (400, 401, 404, 500)
• 인증/권한 테스트
• 입력 검증 테스트
**확인 사항**:
• [x] Status code 확인
• [x] Response body 구조 검증
• [x] Database 상태 변화 확인
• [x] 에러 메시지 검증
**예시** (Express.js + Supertest):
▶ S4: 인증/권한 테스트
JWT 토큰 및 권한 기반 접근 제어를 테스트합니다.
**작업 내용**:
• 토큰 없이 접근 시 401 확인
• 유효한 토큰으로 접근 성공 확인
• 만료된 토큰 처리 테스트
• Role-based 권한 테스트
**예시**:
▶ S5: Mocking 및 테스트 격리
외부 의존성을 모킹하여 테스트를 격리합니다.
**작업 내용**:
• 외부 API 모킹
• 이메일 발송 모킹
• 파일 시스템 모킹
• 시간 관련 함수 모킹
**예시** (외부 API 모킹):

## Best practices
1. TDD (Test-Driven Development)
2. Given-When-Then 패턴
3. Test Fixtures
