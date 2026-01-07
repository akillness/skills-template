---
name: deployment-automation
description: Automate deployment processes using CI/CD pipelines, Docker, Kubernetes, and infrastructure as code. Handles GitHub Actions, GitLab CI, deployment strategies, and production releases.
tags: [deployment, CI/CD, Docker, Kubernetes, automation]
platforms: [Claude, ChatGPT, Gemini]
---

# Deployment Automation

## 목적 (Purpose)

자동화된 배포 파이프라인을 구축합니다.

## 사용 시점 (When to Use)

- **CI/CD 설정**: 자동 빌드 및 배포
- **Docker 배포**: 컨테이너화 및 배포
- **무중단 배포**: Blue-Green, Canary 배포

## 작업 절차 (Procedure)

상세 내용은 [EXAMPLES.md](./EXAMPLES.md) 참조.

### 1단계: CI/CD 파이프라인 설정

GitHub Actions 또는 GitLab CI 설정

👉 [EXAMPLES.md > CI/CD](./EXAMPLES.md)

### 2단계: Docker 이미지 빌드

Dockerfile 작성 및 이미지 빌드

### 3단계: 배포 전략 선택

Rolling, Blue-Green, Canary 중 선택

### 4단계: 모니터링 설정

배포 상태 모니터링

## 제약사항 (Constraints)

### 필수 규칙

1. **환경 분리**: dev, staging, production 구분
2. **롤백 계획**: 실패 시 롤백 가능

## 메타데이터

### 태그
`#deployment` `#CI/CD` `#Docker` `#automation`
