---
name: opencode-authentication
description: Opencode OAuth authentication flows for Claude Code, Gemini/Antigravity, and Codex. Use when setting up multi-provider authentication, configuring Opencode with various AI services, or troubleshooting auth issues.
tags: [opencode, oauth, authentication, claude-code, gemini, antigravity, codex, multi-provider]
platforms: [Claude, ChatGPT, Gemini, Opencode]
allowed-tools:
  - Bash
  - Read
  - Write
---

# Opencode Authentication Guide

Opencode에서 **Claude Code, Gemini/Antigravity, Codex** 인증을 받아 사용하는 흐름을 정리합니다.

## When to use this skill

- **Opencode 초기 설정**: 처음 Opencode를 설치하고 인증 설정 시
- **멀티 프로바이더 연동**: 여러 AI 서비스를 Opencode에서 통합 사용 시
- **인증 문제 해결**: OAuth 토큰 만료, 인증 실패 등 문제 발생 시
- **Rate Limit 극복**: 다중 계정 등록으로 Rate Limit 우회 시

---

## 1. Claude Code OAuth 인증 (Opencode)

### 인증 페이지 & 플로우

Claude Code는 **OAuth 2.0 + PKCE** 방식을 사용합니다.

```
https://console.anthropic.com/oauth/authorize
또는
https://claude.ai/oauth/authorize
```

**인증 파라미터:**

```javascript
const CLIENT_ID = "9d1c250a-e61b-44d9-88ed-5944d1962f5e"; // Opencode 공식 CLIENT_ID
const { challenge, verifier } = await generatePKCE();

const authUrl = new URL("https://console.anthropic.com/oauth/authorize");
authUrl.searchParams.set("client_id", CLIENT_ID);
authUrl.searchParams.set("response_type", "code");
authUrl.searchParams.set("redirect_uri", "https://console.anthropic.com/oauth/code/callback");
authUrl.searchParams.set("scope", "org:create_api_key user:profile user:inference");
authUrl.searchParams.set("code_challenge", challenge);
authUrl.searchParams.set("code_challenge_method", "S256");
authUrl.searchParams.set("state", verifier);
```

### 토큰 교환 (Token Exchange)

사용자가 승인하면 인증 코드를 받고, 토큰으로 교환:

```javascript
const response = await fetch("https://console.anthropic.com/v1/oauth/token", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    code: authCode,
    state: pkceVerifier,
    grant_type: "authorization_code",
    client_id: CLIENT_ID,
    redirect_uri: "https://console.anthropic.com/oauth/code/callback",
    code_verifier: verifier,
  }),
});

const { access_token, refresh_token, expires_in } = await response.json();
```

### API 호출 시 헤더

**중요:** Claude Code 토큰을 쓸 때는 다음 헤더를 반드시 포함해야 합니다.

```javascript
const headers = {
  authorization: `Bearer ${access_token}`,
  "anthropic-beta":
    "oauth-2025-04-20,claude-code-20250219,interleaved-thinking-2025-05-14",
};
// x-api-key 헤더는 제거
```

**주의:** 2026년 1월 이후 Anthropic은 Claude Code 구독 토큰의 서드파티 용도 사용을 차단했습니다. 현재는 API 키 방식만 가능합니다.

---

## 2. Gemini/Antigravity OAuth 인증 (Opencode)

### 플러그인 설치

`opencode-antigravity-auth` 플러그인을 사용합니다.

```bash
# Opencode config에 플러그인 추가
# ~/.config/opencode/opencode.json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-google-antigravity-auth"]
}
```

### 인증 플로우

```bash
opencode auth login
# -> "Google - OAuth with Google (AntiGravity)" 선택
# -> 브라우저에서 Google 계정으로 로그인
# -> Antigravity 액세스 권한 승인
```

**Google OAuth 엔드포인트:**

```
인증: https://accounts.google.com/o/oauth2/v2/auth
토큰: https://oauth2.googleapis.com/token
```

### 설정 파일 저장 위치

인증 정보는 다음 경로에 저장됩니다:

```
$XDG_DATA_HOME/opencode/antigravity-accounts.json
# 또는 ~/.local/share/opencode/antigravity-accounts.json (Linux)
```

**여러 계정 등록 (Rate Limit 극복):**

```bash
opencode auth login
# -> 첫 번째 계정 인증
# -> "Add another? (y/n)" -> y
# -> 최대 10개까지 추가 가능
```

자동으로 여러 계정 간 로드 밸런싱이 이루어집니다.

### API 호출 예시

Opencode 설정에서 모델 정의:

```json
{
  "models": [
    {
      "id": "antigravity-gemini-3-pro-high",
      "provider": "google",
      "settings": { "model": "gemini-3-pro-high" }
    },
    {
      "id": "antigravity-claude-opus-4-5-thinking-low",
      "provider": "anthropic",
      "settings": { "model": "claude-opus-4-5-thinking" }
    }
  ]
}
```

---

## 3. Claude Code (CLI) 인증 페이지

**공식 Claude Code 로그인:**

```bash
code login
# 또는
claude login
```

**인증 페이지:**

```
https://console.anthropic.com/oauth/authorize
(로그인 요청 시 자동으로 뜸)
```

**System Prompt 요구사항:**

Claude Code로 인정받으려면 **반드시** 다음 시스템 메시지를 포함해야 합니다:

```
"You are Claude Code, Anthropic's official CLI for Claude."
```

한 글자라도 틀리면 API 거절 에러가 발생합니다.

---

## 4. Codex (OpenAI) 인증

### 플러그인

`opencode-openai-codex-auth` 플러그인 사용

```bash
opencode auth login
# -> "OpenAI - Use ChatGPT Plus/Pro subscription" 선택
```

### 인증 방식

```bash
opencode auth login
# -> API 키 입력 (또는 OAuth 기반 subscription 토큰)
```

---

## 5. Opencode 통합 인증 명령어

### 기본 흐름

```bash
# 1. 인증 로그인
opencode auth login

# 2. 제공자 선택 (TUI 메뉴)
# ├─ Anthropic (Claude Code OAuth / API Key)
# ├─ Google (Antigravity OAuth)
# ├─ OpenAI (Codex / ChatGPT Plus)
# ├─ Local (ollama 등)
# └─ 기타

# 3. 인증 정보 저장
# ~/.config/opencode/auth.json (또는 플랫폼별 위치)

# 4. 모델 선택
opencode models list  # 인증된 모델 목록 보기
```

### 자격 증명 관리

```bash
opencode auth list           # 등록된 인증 정보 조회
opencode auth remove <name>  # 특정 인증 제거
opencode auth login --add    # 추가 계정 등록
```

---

## 6. 주요 차이점 & 주의사항

| 서비스 | 인증 방식 | 상태 | 비고 |
|--------|----------|------|------|
| **Claude Code (OAuth)** | OAuth 2.0 + PKCE | 차단됨 (2026.01~) | API 키만 사용 가능 |
| **Claude API Key** | API Key 방식 | 활성 | 유료 API 크레딧 필요 |
| **Antigravity (Gemini)** | OAuth 2.0 + PKCE | 활성 | 플러그인: `opencode-google-antigravity-auth` |
| **ChatGPT Plus (Codex)** | Subscription OAuth | 활성 | 플러그인: `opencode-openai-codex-auth` |
| **Local (Ollama)** | 로컬 연결 | 활성 | API 키 불필요 |

---

## 7. 실제 설정 예시 (Opencode + Antigravity)

```bash
# 1. 플러그인 설정
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-google-antigravity-auth"],
  "models": [
    {
      "id": "gemini-3-pro-high",
      "provider": "google",
      "settings": { "model": "gemini-3-pro-high" }
    },
    {
      "id": "claude-opus-4-5-thinking",
      "provider": "anthropic",
      "settings": { "model": "claude-opus-4-5-thinking" }
    }
  ]
}
EOF

# 2. 인증
opencode auth login
# -> "Google - OAuth with Google (AntiGravity)" 선택
# -> 브라우저에서 Google 로그인
# -> Antigravity 권한 승인

# 3. 다중 계정 추가 (선택사항)
opencode auth login
# -> "Add another? (y/n)" -> y

# 4. Opencode 시작
opencode
```

이제 Opencode 내에서 Antigravity의 Gemini 3 Pro, Claude Opus 4.5 등을 자유롭게 전환하며 사용할 수 있습니다.

---

## Instructions

### Step 1: 현재 환경 확인

```bash
# Opencode 설치 확인
which opencode || echo "Opencode not installed"

# 기존 설정 확인
cat ~/.config/opencode/opencode.json 2>/dev/null || echo "No config found"
```

### Step 2: 인증 방식 선택

1. **API 키 방식** (권장, 안정적)
   - Claude: Anthropic Console에서 API 키 발급
   - Gemini: Google AI Studio에서 API 키 발급
   - OpenAI: OpenAI Platform에서 API 키 발급

2. **OAuth 방식** (무료/구독 활용)
   - Antigravity 플러그인 설치 후 Google OAuth 인증
   - ChatGPT Plus 구독자는 Codex 플러그인 사용

### Step 3: 플러그인 설치 및 설정

```bash
# Antigravity 플러그인 (Gemini 무료 사용)
opencode plugin add opencode-google-antigravity-auth

# Codex 플러그인 (ChatGPT Plus 구독 활용)
opencode plugin add opencode-openai-codex-auth

# 설정 확인
opencode config show
```

### Step 4: 다중 계정 설정 (Rate Limit 대응)

```bash
# 여러 Google 계정 등록
opencode auth login  # 첫 번째 계정
opencode auth login  # "Add another?" -> y -> 두 번째 계정
# 최대 10개까지 추가 가능
```

---

## Constraints

### 필수 규칙 (MUST)

1. **Claude Code OAuth 차단 인지**: 2026년 1월부터 서드파티 사용 차단됨
2. **System Prompt 정확히**: Claude Code 인식을 위한 정확한 문구 사용
3. **API 키 보안**: 환경변수나 보안 저장소 사용

### 금지 사항 (MUST NOT)

1. **API 키 하드코딩 금지**: 소스 코드에 직접 입력 금지
2. **토큰 공유 금지**: 인증 토큰을 타인과 공유 금지
3. **Rate Limit 남용 금지**: 과도한 요청으로 서비스 악용 금지

---

## Best Practices

### 1. 환경별 설정 분리

```bash
# 개발 환경
export OPENCODE_CONFIG=~/.config/opencode/dev.json

# 프로덕션 환경
export OPENCODE_CONFIG=~/.config/opencode/prod.json
```

### 2. API 키 안전한 관리

```bash
# .env 파일 사용
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_API_KEY=AIza...
OPENAI_API_KEY=sk-...

# 환경변수로 로드
source .env
```

### 3. 토큰 갱신 자동화

```bash
# cron으로 토큰 체크 및 갱신
0 */6 * * * opencode auth refresh --silent
```

---

## Troubleshooting

### 문제 1: OAuth 인증 실패

```bash
# 캐시 삭제 후 재인증
rm -rf ~/.config/opencode/cache
opencode auth logout
opencode auth login
```

### 문제 2: Rate Limit 초과

```bash
# 다중 계정 등록으로 해결
opencode auth login --add
# 또는 API 키 방식으로 전환
```

### 문제 3: Claude Code 인식 실패

```
# System Prompt 정확히 확인
"You are Claude Code, Anthropic's official CLI for Claude."
# 띄어쓰기, 대소문자 모두 정확히 일치해야 함
```

---

## References

- [Opencode 공식 문서](https://opencode.ai/docs/)
- [Opencode는 어떻게 claude 구독 API를 쓸 수 있나?](https://zp.gy/blog/how-opencode-use-claude-subscription/)
- [Anthropic이 Claude Code 구독의 서드파티 사용을 차단](https://news.hada.io/topic?id=25702)
- [shekohex/opencode-google-antigravity-auth](https://github.com/shekohex/opencode-google-antigravity-auth)
- [Opencode & Google Antigravity 활용](https://apidog.com/kr/blog/claude-opus-4-5-api-free-using-opencode/)
- [Opencode Ecosystem](https://opencode.ai/docs/ecosystem/)

---

## Metadata

### 버전
- **현재 버전**: 1.0.0
- **최종 업데이트**: 2026-01-10
- **호환 플랫폼**: Claude, ChatGPT, Gemini, Opencode

### 관련 스킬
- [mcp-codex-integration](../mcp-codex-integration/SKILL.md)
- [environment-setup](../environment-setup/SKILL.md)

### 태그
`#opencode` `#oauth` `#authentication` `#claude-code` `#gemini` `#antigravity` `#codex` `#multi-provider`
