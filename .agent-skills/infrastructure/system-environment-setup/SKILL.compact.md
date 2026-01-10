# system-environment-setup

> Configure development and production environments for consistent and reproducible setups. Use when setting up new projects, Docker environments, or...

## When to use this skill
• **신규 프로젝트**: 초기 환경 설정
• **팀 온보딩**: 새 개발자 환경 통일
• **다중 서비스**: 마이크로서비스 로컬 실행
• **프로덕션 재현**: 로컬에서 프로덕션 환경 테스트

## Instructions
▶ S1: Docker Compose 설정
**docker-compose.yml**:
**사용**:
▶ S2: 환경변수 관리
**.env.example**:
**.env** (로컬에서만, gitignore에 추가):
**환경변수 로드** (Node.js):
▶ S3: Dev Container (VS Code)
**.devcontainer/devcontainer.json**:
▶ S4: Makefile (편의 명령어)
**Makefile**:
**사용**:
▶ S5: Infrastructure as Code (Terraform)
**main.tf** (AWS 예시):
**variables.tf**:

## Best practices
1. Docker Compose
2. Volume Mount
3. Health Checks
