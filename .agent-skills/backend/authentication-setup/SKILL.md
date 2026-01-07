---
name: authentication-setup
description: Design and implement authentication and authorization systems. Use when setting up user login, JWT tokens, OAuth, session management, or role-based access control. Handles password security, token management, SSO integration.
tags: [authentication, authorization, security, JWT, OAuth, RBAC]
platforms: [Claude, ChatGPT, Gemini]
---

# Authentication Setup

## 목적 (Purpose)

사용자 인증(Authentication)과 권한 부여(Authorization) 시스템을 안전하게 설계하고 구현합니다.

이 스킬은 다음을 도와줍니다:
- 안전한 사용자 인증 시스템 구축
- JWT, OAuth 2.0, Session 기반 인증 구현
- 역할 기반 접근 제어(RBAC) 설정
- 비밀번호 보안 및 암호화
- 다중 인증(MFA) 통합

## 사용 시점 (When to Use)

이 스킬을 트리거해야 하는 구체적인 상황을 나열합니다:

- **사용자 로그인 시스템**: 새로운 애플리케이션에 사용자 인증 기능을 추가할 때
- **API 보안**: REST API나 GraphQL API에 인증 레이어를 추가할 때
- **권한 관리**: 사용자 역할에 따른 접근 제어가 필요할 때
- **인증 마이그레이션**: 기존 인증 시스템을 JWT나 OAuth로 전환할 때
- **SSO 통합**: Google, GitHub, Microsoft 등의 소셜 로그인을 통합할 때

## 입력 형식 (Input Format)

사용자로부터 받아야 할 입력의 형식과 필수/선택 정보:

### 필수 정보
- **인증 방식**: JWT, Session, OAuth 2.0 중 선택
- **백엔드 프레임워크**: Express, Django, FastAPI, Spring Boot 등
- **데이터베이스**: PostgreSQL, MySQL, MongoDB 등
- **보안 요구사항**: 비밀번호 정책, 토큰 만료 시간 등

### 선택 정보
- **MFA 지원**: 2FA/MFA 활성화 여부 (기본값: false)
- **소셜 로그인**: OAuth 제공자 (Google, GitHub, etc.)
- **세션 저장소**: Redis, in-memory 등 (Session 방식인 경우)
- **Refresh Token**: 사용 여부 (기본값: true)

## 작업 절차 (Procedure)

단계별로 정확하게 따라야 할 작업 순서를 명시합니다. 상세 코드는 [EXAMPLES.md](./EXAMPLES.md)를 참조하세요.

### 1단계: 데이터 모델 설계

사용자 및 인증 관련 데이터베이스 스키마를 설계합니다.

**작업 내용**:
- User 테이블 설계 (id, email, password_hash, role, created_at, updated_at)
- RefreshToken 테이블 (선택사항)
- OAuthProvider 테이블 (소셜 로그인 사용시)
- 비밀번호는 절대 평문 저장하지 않음 (bcrypt/argon2 해싱 필수)

👉 **상세 코드**: [EXAMPLES.md > 1단계: 데이터 모델 설계](./EXAMPLES.md#1단계-데이터-모델-설계-sql)

### 2단계: 비밀번호 보안 구현

비밀번호 해싱 및 검증 로직을 구현합니다.

**작업 내용**:
- bcrypt (Node.js) 또는 argon2 (Python) 사용
- Salt rounds 최소 10 이상 설정
- 비밀번호 강도 검증 (최소 8자, 대소문자, 숫자, 특수문자)

**판단 기준**:
- Node.js 프로젝트 → bcrypt 라이브러리 사용
- Python 프로젝트 → argon2-cffi 또는 passlib 사용
- 성능이 중요한 경우 → bcrypt 선택
- 최고 보안이 필요한 경우 → argon2 선택

👉 **상세 코드**: [EXAMPLES.md > 2단계: 비밀번호 보안](./EXAMPLES.md#2단계-비밀번호-보안-구현-nodejs--typescript)

### 3단계: JWT 토큰 생성 및 검증

JWT 기반 인증을 위한 토큰 시스템을 구현합니다.

**작업 내용**:
- Access Token (짧은 만료 시간: 15분)
- Refresh Token (긴 만료 시간: 7일~30일)
- JWT 서명에 강력한 SECRET 키 사용 (환경변수로 관리)
- 토큰 페이로드에 최소 정보만 포함 (user_id, role)

👉 **상세 코드**: [EXAMPLES.md > 3단계: JWT 토큰](./EXAMPLES.md#3단계-jwt-토큰-생성-및-검증-nodejs)

### 4단계: 인증 미들웨어 구현

API 요청을 보호하는 인증 미들웨어를 작성합니다.

**확인 사항**:
- [x] Authorization 헤더에서 Bearer 토큰 추출
- [x] 토큰 검증 및 만료 확인
- [x] 유효한 토큰인 경우 req.user에 사용자 정보 추가
- [x] 에러 처리 (401 Unauthorized)

👉 **상세 코드**: [EXAMPLES.md > 4단계: 인증 미들웨어](./EXAMPLES.md#4단계-인증-미들웨어-구현-expressjs)

### 5단계: 인증 API 엔드포인트 구현

회원가입, 로그인, 토큰 갱신 등의 API를 작성합니다.

**작업 내용**:
- POST /auth/register - 회원가입
- POST /auth/login - 로그인
- POST /auth/refresh - 토큰 갱신
- POST /auth/logout - 로그아웃
- GET /auth/me - 현재 사용자 정보

👉 **상세 코드**: [EXAMPLES.md > 5단계: API 엔드포인트](./EXAMPLES.md#5단계-인증-api-엔드포인트-구현)

## 출력 포맷 (Output Format)

결과물이 따라야 할 정확한 형식을 정의합니다.

### 기본 구조

```
프로젝트 디렉토리/
├── src/
│   ├── auth/
│   │   ├── password.ts          # 비밀번호 해싱/검증
│   │   ├── jwt.ts                # JWT 토큰 생성/검증
│   │   ├── middleware.ts         # 인증 미들웨어
│   │   └── routes.ts             # 인증 API 엔드포인트
│   ├── models/
│   │   └── User.ts               # 사용자 모델
│   └── database/
│       └── schema.sql            # 데이터베이스 스키마
├── .env.example                  # 환경변수 템플릿
└── README.md                     # 인증 시스템 문서
```

## 제약사항 (Constraints)

반드시 지켜야 할 규칙과 금지 사항을 명시합니다.

### 필수 규칙 (MUST)

1. **비밀번호 보안**: 절대 평문으로 저장하지 않음
   - bcrypt, argon2 등 검증된 해싱 알고리즘 사용
   - Salt rounds 최소 10 이상

2. **환경변수 관리**: 모든 시크릿 키는 환경변수로 관리
   - .env 파일은 .gitignore에 추가
   - .env.example로 필요한 변수 목록 제공

3. **토큰 만료**: Access Token은 짧게 (15분), Refresh Token은 적절히 (7일)
   - 보안과 UX의 균형 고려
   - Refresh Token은 DB에 저장하여 무효화 가능하게

### 금지 사항 (MUST NOT)

1. **평문 비밀번호**: 절대 비밀번호를 평문으로 저장하거나 로그에 출력하지 않음
   - 심각한 보안 위험
   - 법적 책임 문제

2. **JWT SECRET 하드코딩**: 코드에 SECRET 키를 직접 작성하지 않음
   - GitHub에 노출될 위험
   - 프로덕션 보안 취약점

3. **민감정보 토큰 포함**: JWT 페이로드에 비밀번호, 카드번호 등 민감정보 포함 금지
   - JWT는 디코딩 가능 (암호화 아님)
   - 최소한의 정보만 포함 (user_id, role)

### 보안 규칙

- **Rate Limiting**: 로그인 API에 rate limiting 적용 (brute force 방지)
- **HTTPS 필수**: 프로덕션 환경에서는 HTTPS만 사용
- **CORS 설정**: 허용된 도메인만 API 접근 가능하도록 설정
- **Input Validation**: 모든 사용자 입력 검증 (SQL Injection, XSS 방지)

## 메타데이터

### 버전
- **현재 버전**: 1.0.0
- **최종 업데이트**: 2025-01-01
- **호환 플랫폼**: Claude, ChatGPT, Gemini

### 관련 스킬
- [api-design](../api-design/SKILL.md): API 엔드포인트 설계
- [security-best-practices](../../infrastructure/security-best-practices/SKILL.md): 보안 베스트 프랙티스

### 태그
`#authentication` `#authorization` `#JWT` `#OAuth` `#security` `#backend`
