#!/usr/bin/env bash
# conductor-cleanup.sh — Conductor worktree 및 tmux 세션 정리
# 사용법: bash scripts/conductor-cleanup.sh <feature-name> [--all] [--force]
#
# 옵션:
#   --all     모든 feat-* worktree 정리
#   --force   확인 없이 강제 삭제

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok()    { echo -e "${GREEN}✅ $*${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $*${NC}"; }

# ─── 인자 파싱 ───────────────────────────────────────────────────────────────
FEATURE_RAW="${1:-}"
CLEAN_ALL=false
FORCE=false

for arg in "${@:2}"; do
  case "$arg" in
    --all)   CLEAN_ALL=true ;;
    --force) FORCE=true ;;
  esac
done

ROOT_DIR="$(git rev-parse --show-toplevel)"
TREES_DIR="$ROOT_DIR/trees"

if [[ -z "$FEATURE_RAW" ]] && [[ "$CLEAN_ALL" == "false" ]]; then
  echo "사용법: $0 <feature-name> [--all] [--force]"
  echo "  --all    모든 feat-* worktree 정리"
  echo "  --force  확인 없이 강제 삭제"
  exit 1
fi

FEATURE=""
if [[ -n "$FEATURE_RAW" ]]; then
  FEATURE=$(echo "$FEATURE_RAW" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
fi

# ─── 삭제 대상 수집 ──────────────────────────────────────────────────────────
declare -a TARGETS=()

if [[ "$CLEAN_ALL" == "true" ]]; then
  for tree_path in "$TREES_DIR"/feat-*/; do
    [[ -d "$tree_path" ]] && TARGETS+=("$tree_path")
  done
else
  for tree_path in "$TREES_DIR"/feat-"$FEATURE"-*/; do
    [[ -d "$tree_path" ]] && TARGETS+=("$tree_path")
  done
fi

if [[ ${#TARGETS[@]} -eq 0 ]]; then
  warn "정리할 worktree가 없습니다."
  exit 0
fi

# ─── 확인 프롬프트 ───────────────────────────────────────────────────────────
echo "삭제 대상:"
for t in "${TARGETS[@]}"; do
  echo "  🗑️  $(basename "$t")"
done
echo ""

if [[ "$FORCE" != "true" ]]; then
  read -r -p "계속하시겠습니까? (y/N) " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "취소됨."; exit 0; }
fi

# ─── tmux 세션 정리 ──────────────────────────────────────────────────────────
if [[ -n "$FEATURE" ]]; then
  SESSION="feat-$FEATURE"
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    info "tmux 세션 종료: $SESSION"
    tmux kill-session -t "$SESSION"
    ok "tmux 세션 종료됨"
  fi
fi

# ─── worktree 제거 ───────────────────────────────────────────────────────────
for tree_path in "${TARGETS[@]}"; do
  TREE_NAME=$(basename "$tree_path")
  BRANCH=$(cd "$tree_path" 2>/dev/null && git branch --show-current 2>/dev/null || echo "")

  info "worktree 제거: $TREE_NAME"
  git worktree remove --force "$tree_path" 2>/dev/null || rm -rf "$tree_path"

  # 로컬 브랜치 삭제 (선택)
  if [[ -n "$BRANCH" ]] && [[ "$BRANCH" != "main" ]] && [[ "$BRANCH" != "master" ]]; then
    git branch -D "$BRANCH" 2>/dev/null && info "브랜치 삭제: $BRANCH" || true
  fi

  ok "$TREE_NAME 정리 완료"
done

# ─── 고아 worktree 정리 ──────────────────────────────────────────────────────
git worktree prune 2>/dev/null && info "git worktree prune 완료" || true

echo ""
ok "정리 완료!"
echo ""
echo "현재 worktree 목록:"
git worktree list
