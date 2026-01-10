# opencode-authentication

> Opencode OAuth authentication flows for Claude Code, Gemini/Antigravity, and Codex. Use when setting up multi-provider authentication or troubleshooting auth issues.

## When to use this skill
• **Opencode 초기 설정**: 처음 Opencode 설치 후 인증 설정
• **멀티 프로바이더 연동**: 여러 AI 서비스 통합 사용
• **인증 문제 해결**: OAuth 토큰 만료, 인증 실패
• **Rate Limit 극복**: 다중 계정 등록

## Instructions
▶ S1: Claude Code OAuth (차단됨 - API 키 권장)
**OAuth 엔드포인트**: `https://console.anthropic.com/oauth/authorize`
**CLIENT_ID**: `9d1c250a-e61b-44d9-88ed-5944d1962f5e`
**필수 헤더**:
```javascript
headers = {
  authorization: `Bearer ${access_token}`,
  "anthropic-beta": "oauth-2025-04-20,claude-code-20250219,interleaved-thinking-2025-05-14"
}
```
**주의**: 2026.01~ 서드파티 OAuth 차단, API 키만 사용 가능

▶ S2: Gemini/Antigravity OAuth
**플러그인 설치**:
```json
{"plugin": ["opencode-google-antigravity-auth"]}
```
**인증 플로우**:
```bash
opencode auth login
# -> "Google - OAuth with Google (AntiGravity)" 선택
```
**다중 계정 (Rate Limit 극복)**:
```bash
opencode auth login  # "Add another?" -> y (최대 10개)
```

▶ S3: Codex (OpenAI)
**플러그인**: `opencode-openai-codex-auth`
```bash
opencode auth login
# -> "OpenAI - Use ChatGPT Plus/Pro subscription" 선택
```

▶ S4: 통합 인증 명령어
```bash
opencode auth login      # 로그인
opencode auth list       # 인증 목록
opencode auth remove <n> # 인증 제거
opencode models list     # 모델 목록
```

▶ S5: 모델 설정 예시
```json
{
  "models": [
    {"id": "gemini-3-pro-high", "provider": "google", "settings": {"model": "gemini-3-pro-high"}},
    {"id": "claude-opus-4-5", "provider": "anthropic", "settings": {"model": "claude-opus-4-5-thinking"}}
  ]
}
```

## 서비스 상태 요약
| 서비스 | 인증 방식 | 상태 |
|--------|----------|------|
| Claude Code OAuth | OAuth 2.0 + PKCE | 차단됨 |
| Claude API Key | API Key | 활성 |
| Antigravity | OAuth 2.0 + PKCE | 활성 |
| ChatGPT Plus | Subscription OAuth | 활성 |

## Best practices
1. API 키는 환경변수로 관리
2. 다중 계정으로 Rate Limit 분산
3. OAuth 토큰 주기적 갱신
4. Claude Code는 API 키 방식 사용
5. System Prompt 정확히 일치 필수
