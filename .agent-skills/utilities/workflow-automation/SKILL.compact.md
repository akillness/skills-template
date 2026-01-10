# workflow-automation

> Automate repetitive development tasks and workflows. Use when creating build scripts, automating deployments, or setting up development workflows. ...

## When to use this skill
• **반복 작업**: 매번 같은 명령어 실행
• **복잡한 빌드**: 여러 단계 빌드 프로세스
• **팀 온보딩**: 일관된 개발 환경

## Instructions
▶ S1: npm scripts
**package.json**:
▶ S2: Makefile
**Makefile**:
**사용**:
▶ S3: Husky + lint-staged (Git Hooks)
**package.json**:
**.husky/pre-commit**:
▶ S4: Task Runner 스크립트
**scripts/dev-setup.sh**:
**scripts/deploy.sh**:
▶ S5: GitHub Actions Workflow 자동화
**.github/workflows/ci.yml**:

## Best practices
1. Make 사용
2. Git Hooks
3. CI/CD
