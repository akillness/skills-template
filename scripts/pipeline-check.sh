#!/usr/bin/env bash
# pipeline-check.sh — Conductor 파이프라인 사전 점검
# 사용법: bash scripts/pipeline-check.sh [--agents=claude,codex]

set -euo pipefail

# ─── 색상 ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✅ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
fail() { echo -e "${RED}❌ $*${NC}"; }

# ─── 인자 파싱 ───────────────────────────────────────────────────────────────
AGENTS="claude,codex"
for arg in "$@"; do
  case "$arg" in
    --agents=*) AGENTS="${arg#--agents=}" ;;
  esac
done

echo "╔══════════════════════════════════════╗"
echo "║  Conductor 사전 점검 (pipeline-check) ║"
echo "╚══════════════════════════════════════╝"
echo ""

ERRORS=0

# ─── 필수 도구 점검 ──────────────────────────────────────────────────────────
echo "📦 필수 도구 확인..."
for tool in git tmux; do
  if command -v "$tool" &>/dev/null; then
    ok "$tool: $(command -v $tool)"
  else
    fail "$tool: 설치되지 않음"
    ERRORS=$((ERRORS + 1))
  fi
done

# gh CLI (선택사항이지만 PR 생성에 필요)
if command -v gh &>/dev/null; then
  ok "gh CLI: $(gh --version | head -1)"
else
  warn "gh CLI: 미설치 (PR 생성 기능 사용 불가)"
fi

echo ""

# ─── git 레포 확인 ───────────────────────────────────────────────────────────
echo "📁 git 레포 확인..."
if git rev-parse --git-dir &>/dev/null; then
  ROOT=$(git rev-parse --show-toplevel)
  ok "git 레포: $ROOT"
else
  fail "현재 디렉토리가 git 레포가 아닙니다"
  ERRORS=$((ERRORS + 1))
fi

# git worktree 지원 확인
if git worktree list &>/dev/null; then
  ok "git worktree: 지원됨"
else
  fail "git worktree: 지원되지 않음 (git 2.5+ 필요)"
  ERRORS=$((ERRORS + 1))
fi

echo ""

# ─── 에이전트 CLI 확인 ───────────────────────────────────────────────────────
echo "🤖 에이전트 CLI 확인 (요청: $AGENTS)..."
IFS=',' read -ra AGENT_LIST <<< "$AGENTS"
AGENT_ERRORS=0

for agent in "${AGENT_LIST[@]}"; do
  agent=$(echo "$agent" | tr -d ' ')
  case "$agent" in
    claude)
      if command -v claude &>/dev/null; then
        ok "claude: $(command -v claude)"
      else
        fail "claude: Claude Code CLI 미설치 (npm install -g @anthropic-ai/claude-code)"
        AGENT_ERRORS=$((AGENT_ERRORS + 1))
      fi
      ;;
    codex)
      if command -v codex &>/dev/null; then
        ok "codex: $(command -v codex)"
      else
        warn "codex: 미설치 (conductor에서 해당 에이전트 건너뜀)"
      fi
      ;;
    gemini)
      if command -v gemini &>/dev/null; then
        ok "gemini: $(command -v gemini)"
      else
        warn "gemini: 미설치 (conductor에서 해당 에이전트 건너뜀)"
      fi
      ;;
    *)
      warn "알 수 없는 에이전트: $agent"
      ;;
  esac
done

if [[ $AGENT_ERRORS -gt 0 ]]; then
  ERRORS=$((ERRORS + AGENT_ERRORS))
fi

echo ""

# ─── tmux 세션 충돌 확인 ─────────────────────────────────────────────────────
echo "🔍 tmux 환경 확인..."
if tmux ls &>/dev/null 2>&1; then
  SESSION_COUNT=$(tmux ls 2>/dev/null | wc -l | tr -d ' ')
  if [[ $SESSION_COUNT -gt 10 ]]; then
    warn "활성 tmux 세션이 많습니다 ($SESSION_COUNT개). 불필요한 세션을 정리하세요."
  else
    ok "tmux 세션 수: $SESSION_COUNT개"
  fi
else
  ok "tmux 서버 미실행 (정상)"
fi

echo ""

# ─── 결과 ────────────────────────────────────────────────────────────────────
if [[ $ERRORS -eq 0 ]]; then
  echo -e "${GREEN}🎉 모든 점검 통과! conductor를 실행할 준비가 되었습니다.${NC}"
  echo ""
  echo "다음 명령어로 실행:"
  echo "  bash scripts/conductor.sh <feature-name> main ${AGENTS}"
  exit 0
else
  echo -e "${RED}💥 점검 실패: ${ERRORS}개 오류. 위 항목을 해결 후 재시도하세요.${NC}"
  exit 1
fi
