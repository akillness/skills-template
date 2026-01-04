# Claude Code에서 Gemini & Codex MCP 서버 설정 가이드

## 개요

이 가이드는 Claude Code에서 Google Gemini와 OpenAI Codex를 MCP(Model Context Protocol) 서버로 설정하여 사용하는 방법을 안내합니다.

---

## 사전 요구사항

### 1. Gemini CLI 설치 및 인증

```bash
# Gemini CLI 설치
npm install -g @anthropic-ai/gemini-cli

# 버전 확인
gemini --version

# OAuth 인증 (브라우저에서 Google 계정 로그인)
gemini auth login
```

### 2. Codex CLI 설치 및 인증

```bash
# Codex CLI 설치
npm install -g @openai/codex

# 버전 확인
codex --version

# API 키로 인증
codex auth login --api-key "your-openai-api-key"

# 또는 대화형 로그인
codex auth login
```

---

## 설치 상태 확인

### CLI 설치 확인

```bash
# Gemini CLI 확인
which gemini
gemini --version

# Codex CLI 확인
which codex
codex --version
```

### 인증 상태 확인

```bash
# Gemini 인증 파일 확인
ls -la ~/.gemini/oauth_creds.json

# Codex 인증 파일 확인
ls -la ~/.codex/auth.json
```

### 현재 MCP 서버 확인

```bash
claude mcp list
```

---

## MCP 서버 설정

### 1. Gemini MCP 서버 추가

```bash
claude mcp add gemini-cli -s user -- npx -y gemini-mcp-tool
```

**패키지 정보:**
- **이름**: `gemini-mcp-tool`
- **용도**: Gemini CLI를 MCP 서버로 래핑
- **장점**: 1M+ 토큰 컨텍스트 윈도우 활용 가능

### 2. Codex MCP 서버 추가

```bash
claude mcp add codex-cli -s user -- npx -y @openai/codex-shell-tool-mcp
```

**패키지 정보:**
- **이름**: `@openai/codex-shell-tool-mcp`
- **용도**: OpenAI Codex CLI를 MCP 서버로 래핑
- **장점**: ChatGPT 구독자는 GPT-5 무료 사용 가능

### 3. 설정 확인

```bash
claude mcp list
```

**예상 출력:**
```
gemini-cli: npx -y gemini-mcp-tool - ✓ Connected
codex-cli: npx -y @openai/codex-shell-tool-mcp - ✓ Connected
```

---

## 설정 파일 구조

### ~/.claude.json

```json
{
  "mcpServers": {
    "gemini-cli": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "gemini-mcp-tool"],
      "env": {}
    },
    "codex-cli": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@openai/codex-shell-tool-mcp"],
      "env": {}
    }
  }
}
```

### 스코프 옵션

| 스코프 | 명령어 | 용도 |
|--------|--------|------|
| user | `-s user` | 모든 프로젝트에서 사용 (개인용) |
| project | `-s project` | 현재 프로젝트만 (팀 공유) |
| repo | `-s repo` | Git 저장소에 커밋 |

---

## 사용 방법

### Gemini 사용 예시

```
# 대용량 코드베이스 분석
"gemini-cli를 사용해서 이 프로젝트 전체 아키텍처를 분석해줘"

# 코드 리뷰
"gemini-cli로 이 PR의 코드를 리뷰해줘"

# 문서 생성
"gemini-cli를 활용해서 API 문서를 작성해줘"
```

### Codex 사용 예시

```
# 코드 리팩토링
"codex-cli를 사용해서 이 함수를 리팩토링해줘"

# 테스트 코드 생성
"codex-cli로 이 모듈의 유닛 테스트를 작성해줘"

# 버그 수정
"codex-cli를 활용해서 이 에러를 분석하고 수정해줘"
```

---

## 멀티 모델 활용 패턴

| 작업 유형 | 권장 모델 | 이유 |
|----------|----------|------|
| 대용량 코드 분석 | Gemini 2.5 Pro | 1M+ 토큰 컨텍스트 |
| 빠른 코드 생성 | Codex / Claude | 속도와 정확도 |
| 복잡한 추론 | Claude Opus | 깊은 분석 |
| 코드 리뷰 | Gemini + Claude | 상호 검증 |

---

## 문제 해결

### MCP 서버 연결 실패 시

```bash
# 서버 제거 후 재추가
claude mcp remove gemini-cli
claude mcp add gemini-cli -s user -- npx -y gemini-mcp-tool

# npx 캐시 정리
npx clear-npx-cache
```

### 인증 만료 시

```bash
# Gemini 재인증
gemini auth login

# Codex 재인증
codex auth login
```

### 패키지 버전 확인

```bash
# 최신 버전 확인
npm view gemini-mcp-tool version
npm view @openai/codex-shell-tool-mcp version
```

---

## 대체 MCP 패키지

### Gemini 대체 옵션

| 패키지 | 특징 |
|--------|------|
| `gemini-mcp` | 기본 Gemini MCP |
| `@iflow-mcp/gemini-mcp` | 고급 기능 포함 |
| `@anthropic-ai/gemini-mcp` | 공식 Anthropic 버전 |

### OpenAI 대체 옵션

| 패키지 | 특징 |
|--------|------|
| `@mzxrai/mcp-openai` | ChatGPT 모델 직접 호출 |
| `codex-mcp-server` | Codex CLI 래퍼 |

---

## 빠른 설정 스크립트

```bash
#!/bin/bash
# Claude Code MCP 설정 스크립트

echo "=== Gemini & Codex MCP 설정 ==="

# 1. CLI 설치 확인
echo "Checking CLI installations..."
gemini --version || npm install -g @anthropic-ai/gemini-cli
codex --version || npm install -g @openai/codex

# 2. MCP 서버 추가
echo "Adding MCP servers..."
claude mcp add gemini-cli -s user -- npx -y gemini-mcp-tool
claude mcp add codex-cli -s user -- npx -y @openai/codex-shell-tool-mcp

# 3. 확인
echo "Verifying setup..."
claude mcp list

echo "=== Setup Complete ==="
```

---

## 참고 자료

- [gemini-mcp-tool (npm)](https://www.npmjs.com/package/gemini-mcp-tool)
- [@openai/codex-shell-tool-mcp (npm)](https://www.npmjs.com/package/@openai/codex-shell-tool-mcp)
- [RLabs-Inc/gemini-mcp (GitHub)](https://github.com/RLabs-Inc/gemini-mcp)
- [Claude Code MCP 공식 문서](https://code.claude.com/docs/mcp)

---

## 변경 이력

| 날짜 | 변경 내용 |
|------|----------|
| 2026-01-02 | 초기 문서 작성 |
| - | gemini-mcp-tool v1.1.4 기준 |
| - | @openai/codex-shell-tool-mcp v0.77.0 기준 |
