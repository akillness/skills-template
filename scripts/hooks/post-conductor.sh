#!/usr/bin/env bash
# hooks/post-conductor.sh — conductor 완료 후 실행되는 훅 예시
# 실패해도(exit 1) 경고만 표시하고 파이프라인은 계속됩니다.
#
# 인자:
#   $1 = feature name
#   $2 = base branch

FEATURE="${1:-}"
BASE_BRANCH="${2:-main}"

echo "🪝 [post-conductor] feature=$FEATURE"

# ─── 예시: Slack/Discord 알림 ──────────────────────────────────────────────
# if [[ -n "${SLACK_WEBHOOK_URL:-}" ]]; then
#   curl -s -X POST "$SLACK_WEBHOOK_URL" \
#     -H 'Content-type: application/json' \
#     -d "{\"text\":\"🤖 Conductor 완료: feat/$FEATURE (에이전트 작업 중)\"}"
# fi

# ─── 예시: worktree 상태 리포트 ────────────────────────────────────────────
ROOT_DIR="$(git rev-parse --show-toplevel)"
TREES_DIR="$ROOT_DIR/trees"

if [[ -d "$TREES_DIR" ]]; then
  echo "📁 생성된 worktree:"
  for tree in "$TREES_DIR"/feat-"$FEATURE"-*/; do
    [[ -d "$tree" ]] || continue
    AGENT=$(basename "$tree" | sed "s/feat-$FEATURE-//")
    echo "   🌿 $AGENT → $(basename $tree)"
  done
fi

echo "✅ [post-conductor] 완료"
exit 0
