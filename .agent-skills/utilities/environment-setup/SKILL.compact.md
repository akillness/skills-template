# environment-setup

> Configure and manage development, staging, and production environments. Use when setting up environment variables, managing configurations, or sepa...

## When to use this skill
• **신규 프로젝트**: 초기 환경 설정
• **다중 환경**: dev, staging, production 분리
• **팀 협업**: 일관된 환경 공유

## Instructions
▶ S1: .env 파일 구조
**.env.example** (템플릿):
**.env.local** (개발자별):
**.env.production**:
▶ S2: Type-Safe 환경변수 (TypeScript)
**config/env.ts**:
**에러 처리**:
▶ S3: 환경별 Config 파일
**config/index.ts**:
▶ S4: 환경별 설정 파일
**config/environments/development.ts**:
**config/environments/production.ts**:
**config/index.ts** (통합):
▶ S5: Docker 환경변수
**docker-compose.yml**:

## Best practices
1. 12 Factor App
2. Type Safety
3. Secrets Management
