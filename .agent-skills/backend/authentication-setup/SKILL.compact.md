# authentication-setup

> Design and implement authentication and authorization systems. Use when setting up user login, JWT tokens, OAuth, session management, or role-based...

## When to use this skill
이 스킬을 트리거해야 하는 구체적인 상황을 나열합니다:
• **사용자 로그인 시스템**: 새로운 애플리케이션에 사용자 인증 기능을 추가할 때
• **API 보안**: REST API나 GraphQL API에 인증 레이어를 추가할 때
• **권한 관리**: 사용자 역할에 따른 접근 제어가 필요할 때
• **인증 마이그레이션**: 기존 인증 시스템을 JWT나 OAuth로 전환할 때
• **SSO 통합**: Google, GitHub, Microsoft 등의 소셜 로그인을 통합할 때

## Instructions
단계별로 정확하게 따라야 할 작업 순서를 명시합니다.
▶ S1: 데이터 모델 설계
사용자 및 인증 관련 데이터베이스 스키마를 설계합니다.
**작업 내용**:
• User 테이블 설계 (id, email, password_hash, role, created_at, updated_at)
• RefreshToken 테이블 (선택사항)
• OAuthProvider 테이블 (소셜 로그인 사용시)
• 비밀번호는 절대 평문 저장하지 않음 (bcrypt/argon2 해싱 필수)
**예시** (PostgreSQL):
▶ S2: 비밀번호 보안 구현
비밀번호 해싱 및 검증 로직을 구현합니다.
**작업 내용**:
• bcrypt (Node.js) 또는 argon2 (Python) 사용
• Salt rounds 최소 10 이상 설정
• 비밀번호 강도 검증 (최소 8자, 대소문자, 숫자, 특수문자)
**판단 기준**:
• Node.js 프로젝트 → bcrypt 라이브러리 사용
• Python 프로젝트 → argon2-cffi 또는 passlib 사용
• 성능이 중요한 경우 → bcrypt 선택
• 최고 보안이 필요한 경우 → argon2 선택
**예시** (Node.js + TypeScript):
▶ S3: JWT 토큰 생성 및 검증
JWT 기반 인증을 위한 토큰 시스템을 구현합니다.
**작업 내용**:
• Access Token (짧은 만료 시간: 15분)
• Refresh Token (긴 만료 시간: 7일~30일)
• JWT 서명에 강력한 SECRET 키 사용 (환경변수로 관리)
• 토큰 페이로드에 최소 정보만 포함 (user_id, role)
**예시** (Node.js):
▶ S4: 인증 미들웨어 구현
API 요청을 보호하는 인증 미들웨어를 작성합니다.
**확인 사항**:
• [x] Authorization 헤더에서 Bearer 토큰 추출
• [x] 토큰 검증 및 만료 확인
• [x] 유효한 토큰인 경우 req.user에 사용자 정보 추가
• [x] 에러 처리 (401 Unauthorized)
**예시** (Express.js):
▶ S5: 인증 API 엔드포인트 구현
회원가입, 로그인, 토큰 갱신 등의 API를 작성합니다.
**작업 내용**:
• POST /auth/register - 회원가입
• POST /auth/login - 로그인
• POST /auth/refresh - 토큰 갱신
• POST /auth/logout - 로그아웃
• GET /auth/me - 현재 사용자 정보
**예시**:

## Best practices
1. Password Rotation Policy
2. Multi-Factor Authentication (MFA)
3. Audit Logging
