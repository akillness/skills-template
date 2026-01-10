# deployment-automation

> Automate application deployment to cloud platforms and servers. Use when setting up CI/CD pipelines, deploying to Docker/Kubernetes, or configuring...

## When to use this skill
• **신규 프로젝트**: 처음부터 자동 배포 설정
• **수동 배포 개선**: 반복적인 수동 작업 자동화
• **멀티 환경**: dev, staging, production 환경 분리
• **스케일링**: 트래픽 증가 대비 Kubernetes 도입

## Instructions
▶ S1: Docker 컨테이너화
애플리케이션을 Docker 이미지로 패키징합니다.
**Dockerfile** (Node.js 앱):
**.dockerignore**:
**빌드 및 실행**:
▶ S2: GitHub Actions CI/CD
코드 푸시 시 자동으로 테스트 및 배포합니다.
**.github/workflows/deploy.yml**:
▶ S3: Kubernetes 배포
확장 가능한 컨테이너 오케스트레이션을 구현합니다.
**k8s/deployment.yaml**:
**배포 스크립트** (deploy.sh):
▶ S4: Vercel/Netlify (프론트엔드)
정적 사이트 및 Next.js 앱을 간단히 배포합니다.
**vercel.json**:
**CLI 배포**:
▶ S5: 무중단 배포 전략
서비스 중단 없이 새 버전을 배포합니다.
**Blue-Green 배포** (docker-compose):
**switch.sh** (Blue/Green 전환):

## Best practices
1. Multi-stage Docker builds
2. Immutable infrastructure
3. Blue-Green deployment
4. Monitoring 필수
