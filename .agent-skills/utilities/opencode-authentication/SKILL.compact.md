# opencode-authentication

> Opencode OAuth authentication flows for Claude Code, Gemini/Antigravity, and Codex. Use when setting up multi-provider authentication, configuring ...

## When to use this skill
• **Opencode 초기 설정**: 처음 Opencode를 설치하고 인증 설정 시
• **멀티 프로바이더 연동**: 여러 AI 서비스를 Opencode에서 통합 사용 시
• **인증 문제 해결**: OAuth 토큰 만료, 인증 실패 등 문제 발생 시
• **Rate Limit 극복**: 다중 계정 등록으로 Rate Limit 우회 시
---

## Instructions
▶ S1: 현재 환경 확인
▶ S2: 인증 방식 선택
1. **API 키 방식** (권장, 안정적)
• Claude: Anthropic Console에서 API 키 발급
• Gemini: Google AI Studio에서 API 키 발급
• OpenAI: OpenAI Platform에서 API 키 발급
2. **OAuth 방식** (무료/구독 활용)
• Antigravity 플러그인 설치 후 Google OAuth 인증
• ChatGPT Plus 구독자는 Codex 플러그인 사용
▶ S3: 플러그인 설치 및 설정
▶ S4: 다중 계정 설정 (Rate Limit 대응)
---
