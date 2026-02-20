#!/usr/bin/env bash
# conductor.sh — 병렬 AI 에이전트 실행 (git worktree 기반)
# 사용법: bash scripts/conductor.sh <feature-name> [base-branch] [agents]
#
# 예시:
#   bash scripts/conductor.sh user-dashboard main claude,codex
#   bash scripts/conductor.sh auth-refactor develop claude

set -euo pipefail

# ─── 색상 ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok()    { echo -e "${GREEN}✅ $*${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $*${NC}"; }
error() { echo -e "${RED}❌ $*${NC}" >&2; }

# ─── 인자 파싱 ───────────────────────────────────────────────────────────────
FEATURE_RAW="${1:-}"
BASE_BRANCH="${2:-main}"
AGENTS_RAW="${3:-claude,codex}"
NO_ATTACH="${NO_ATTACH:-false}"
SKIP_HOOKS="${CONDUCTOR_SKIP_HOOKS:-0}"

if [[ -z "$FEATURE_RAW" ]]; then
  error "사용법: $0 <feature-name> [base-branch] [agents]"
  error "예시:   $0 user-dashboard main claude,codex"
  exit 1
fi

# feature name 정규화 (소문자 + 하이픈만)
FEATURE=$(echo "$FEATURE_RAW" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

ROOT_DIR="$(git rev-parse --show-toplevel)"
TREES_DIR="$ROOT_DIR/trees"
HOOKS_DIR="${CONDUCTOR_HOOKS_DIR:-$ROOT_DIR/scripts/hooks}"
SESSION="feat-$FEATURE"

info "Conductor 시작"
echo "  Feature : $FEATURE"
echo "  Branch  : $BASE_BRANCH"
echo "  Agents  : $AGENTS_RAW"
echo ""

# ─── 훅 실행 함수 ────────────────────────────────────────────────────────────
run_hook() {
  local hook_name="$1"
  local hook_file="$HOOKS_DIR/${hook_name}.sh"
  if [[ "$SKIP_HOOKS" == "1" ]]; then return 0; fi
  if [[ -x "$hook_file" ]]; then
    info "훅 실행: $hook_name"
    bash "$hook_file" "$FEATURE" "$BASE_BRANCH" || return 1
  fi
  return 0
}

# ─── pre-conductor 훅 ────────────────────────────────────────────────────────
if ! run_hook "pre-conductor"; then
  error "pre-conductor 훅 실패. 중단합니다."
  exit 1
fi

# ─── trees 디렉토리 준비 ─────────────────────────────────────────────────────
mkdir -p "$TREES_DIR"

# ─── 에이전트별 worktree 생성 ────────────────────────────────────────────────
IFS=',' read -ra AGENT_LIST <<< "$AGENTS_RAW"
CREATED_AGENTS=()
TMUX_PANES=()

for agent in "${AGENT_LIST[@]}"; do
  agent=$(echo "$agent" | tr -d ' ')

  # 에이전트 CLI 존재 확인
  if ! command -v "$agent" &>/dev/null; then
    warn "$agent CLI를 찾을 수 없습니다. 건너뜁니다."
    continue
  fi

  TREE_PATH="$TREES_DIR/feat-$FEATURE-$agent"
  BRANCH_NAME="feat/$FEATURE-$agent"

  # 기존 worktree 정리
  if [[ -d "$TREE_PATH" ]]; then
    warn "$TREE_PATH 이미 존재. 제거 후 재생성..."
    git worktree remove --force "$TREE_PATH" 2>/dev/null || rm -rf "$TREE_PATH"
  fi

  # 기존 브랜치 정리
  if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    git branch -D "$BRANCH_NAME" 2>/dev/null || true
  fi

  info "worktree 생성: $TREE_PATH ($BRANCH_NAME)"
  git worktree add "$TREE_PATH" -b "$BRANCH_NAME" "$BASE_BRANCH"

  # 공통 설정 파일 복사
  for config_file in .env .env.local .nvmrc .node-version; do
    if [[ -f "$ROOT_DIR/$config_file" ]]; then
      cp "$ROOT_DIR/$config_file" "$TREE_PATH/$config_file" 2>/dev/null || true
    fi
  done

  ok "worktree 준비: feat-$FEATURE-$agent"
  CREATED_AGENTS+=("$agent")
  TMUX_PANES+=("$TREE_PATH")
done

if [[ ${#CREATED_AGENTS[@]} -eq 0 ]]; then
  error "실행 가능한 에이전트가 없습니다."
  exit 1
fi

# ─── tmux 세션 생성 ──────────────────────────────────────────────────────────
echo ""
info "tmux 세션 생성: $SESSION"

# 기존 세션 제거
tmux kill-session -t "$SESSION" 2>/dev/null || true

FIRST_AGENT="${CREATED_AGENTS[0]}"
FIRST_TREE="${TMUX_PANES[0]}"

# 첫 번째 pane
tmux new-session -d -s "$SESSION" -c "$FIRST_TREE" \
  -x 220 -y 50 \
  "echo '🤖 [$FIRST_AGENT] feat/$FEATURE-$FIRST_AGENT'; echo ''; $FIRST_AGENT; exec bash"

# 추가 에이전트 pane (split-window)
for i in "${!CREATED_AGENTS[@]}"; do
  if [[ $i -eq 0 ]]; then continue; fi
  agent="${CREATED_AGENTS[$i]}"
  tree="${TMUX_PANES[$i]}"
  tmux split-window -h -t "$SESSION:0" -c "$tree" \
    "echo '🤖 [$agent] feat/$FEATURE-$agent'; echo ''; $agent; exec bash"
done

# 레이아웃 정렬
tmux select-layout -t "$SESSION:0" tiled

ok "tmux 세션 준비: $SESSION"
echo ""

# ─── post-conductor 훅 ───────────────────────────────────────────────────────
run_hook "post-conductor" || warn "post-conductor 훅 경고 (계속 진행)"

# ─── 완료 안내 ───────────────────────────────────────────────────────────────
echo "╔═══════════════════════════════════════════════════╗"
echo "║  Conductor 준비 완료                               ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""
echo "생성된 worktree:"
for i in "${!CREATED_AGENTS[@]}"; do
  agent="${CREATED_AGENTS[$i]}"
  echo "  🌿 trees/feat-$FEATURE-$agent  →  feat/$FEATURE-$agent"
done
echo ""
echo "에이전트 작업 완료 후:"
echo "  bash scripts/conductor-pr.sh $FEATURE $BASE_BRANCH"
echo ""

# tmux attach
if [[ "$NO_ATTACH" != "true" && -t 1 ]]; then
  echo "tmux 세션에 연결합니다... (Ctrl+B D로 분리)"
  tmux attach-session -t "$SESSION"
else
  echo "tmux 세션 백그라운드 실행 중: $SESSION"
  echo "연결하려면: tmux attach-session -t $SESSION"
fi
