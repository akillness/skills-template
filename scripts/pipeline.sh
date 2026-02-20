#!/usr/bin/env bash
# pipeline.sh — Conductor 통합 파이프라인 (check → conductor → pr)
# 사용법: bash scripts/pipeline.sh <feature-name> [options]
#
# 옵션:
#   --base <branch>     베이스 브랜치 (기본: main)
#   --agents <list>     에이전트 목록 (기본: claude,codex)
#   --stages <list>     실행 단계 check,plan,conductor,pr (기본: check,conductor,pr)
#   --no-attach         tmux 비연결 (CI 환경용)
#   --dry-run           실행 없이 미리보기
#   --resume            마지막 실패 단계부터 재개
#
# 예시:
#   bash scripts/pipeline.sh my-feature --stages check,conductor,pr
#   bash scripts/pipeline.sh my-feature --agents claude,codex,gemini
#   bash scripts/pipeline.sh --resume

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'
info()    { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok()      { echo -e "${GREEN}✅ $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $*${NC}"; }
error()   { echo -e "${RED}❌ $*${NC}" >&2; }
stage()   { echo -e "\n${CYAN}━━━ STAGE: $* ━━━${NC}\n"; }

# ─── 기본값 ──────────────────────────────────────────────────────────────────
FEATURE_RAW=""
BASE_BRANCH="main"
AGENTS="claude,codex"
STAGES="check,conductor,pr"
NO_ATTACH=false
DRY_RUN=false
RESUME=false

ROOT_DIR="$(git rev-parse --show-toplevel)"
STATE_FILE="$ROOT_DIR/.conductor-pipeline-state.json"
SCRIPTS_DIR="$ROOT_DIR/scripts"

# ─── 인자 파싱 ───────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)    BASE_BRANCH="$2"; shift 2 ;;
    --agents)  AGENTS="$2"; shift 2 ;;
    --stages)  STAGES="$2"; shift 2 ;;
    --no-attach) NO_ATTACH=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    --resume)  RESUME=true; shift ;;
    --*)       warn "알 수 없는 옵션: $1"; shift ;;
    *)
      if [[ -z "$FEATURE_RAW" ]]; then
        FEATURE_RAW="$1"
      fi
      shift ;;
  esac
done

# ─── Resume 처리 ─────────────────────────────────────────────────────────────
if [[ "$RESUME" == "true" ]]; then
  if [[ ! -f "$STATE_FILE" ]]; then
    error "상태 파일이 없습니다. --resume 없이 새로 실행하세요."
    exit 1
  fi
  info "이전 파이프라인 상태 로드..."
  FEATURE_RAW=$(python3 -c "import json,sys; d=json.load(open('$STATE_FILE')); print(d.get('feature',''))" 2>/dev/null || echo "")
  BASE_BRANCH=$(python3 -c "import json,sys; d=json.load(open('$STATE_FILE')); print(d.get('base_branch','main'))" 2>/dev/null || echo "main")
  AGENTS=$(python3 -c "import json,sys; d=json.load(open('$STATE_FILE')); print(d.get('agents','claude,codex'))" 2>/dev/null || echo "claude,codex")
  LAST_FAILED=$(python3 -c "import json,sys; d=json.load(open('$STATE_FILE')); print(d.get('last_failed_stage',''))" 2>/dev/null || echo "")

  if [[ -z "$FEATURE_RAW" ]]; then
    error "상태 파일에서 feature를 읽을 수 없습니다."
    exit 1
  fi
  info "재개: feature=$FEATURE_RAW, 마지막 실패=$LAST_FAILED"
fi

if [[ -z "$FEATURE_RAW" ]]; then
  error "사용법: $0 <feature-name> [options] 또는 $0 --resume"
  exit 1
fi

FEATURE=$(echo "$FEATURE_RAW" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

# ─── 상태 저장 함수 ──────────────────────────────────────────────────────────
save_state() {
  local current_stage="$1"
  local status="$2"   # running | success | failed
  python3 -c "
import json, datetime
state = {}
try:
    state = json.load(open('$STATE_FILE'))
except: pass
state.update({
    'feature': '$FEATURE',
    'base_branch': '$BASE_BRANCH',
    'agents': '$AGENTS',
    'stages': '$STAGES',
    'last_stage': '$current_stage',
    'last_status': '$status',
    'last_failed_stage': '' if '$status' != 'failed' else '$current_stage',
    'updated_at': datetime.datetime.now().isoformat()
})
json.dump(state, open('$STATE_FILE', 'w'), indent=2)
" 2>/dev/null || true
}

# ─── 단계 실행 함수 ──────────────────────────────────────────────────────────
run_stage() {
  local stage_name="$1"
  local cmd="$2"

  stage "$stage_name"

  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  [DRY RUN] $cmd"
    return 0
  fi

  save_state "$stage_name" "running"

  if eval "$cmd"; then
    save_state "$stage_name" "success"
    ok "$stage_name 완료"
  else
    save_state "$stage_name" "failed"
    error "$stage_name 실패!"
    echo ""
    echo "재개하려면: bash scripts/pipeline.sh --resume"
    exit 1
  fi
}

# ─── 헤더 ────────────────────────────────────────────────────────────────────
echo "╔═══════════════════════════════════════════════╗"
echo "║  Conductor Pipeline                            ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""
echo "  Feature : $FEATURE"
echo "  Branch  : $BASE_BRANCH"
echo "  Agents  : $AGENTS"
echo "  Stages  : $STAGES"
echo "  Dry Run : $DRY_RUN"
echo ""

# ─── 단계별 실행 ─────────────────────────────────────────────────────────────
NO_ATTACH_ENV=""
[[ "$NO_ATTACH" == "true" ]] && NO_ATTACH_ENV="NO_ATTACH=true"

IFS=',' read -ra STAGE_LIST <<< "$STAGES"
for s in "${STAGE_LIST[@]}"; do
  s=$(echo "$s" | tr -d ' ')
  case "$s" in
    check)
      run_stage "pre-flight check" \
        "bash $SCRIPTS_DIR/pipeline-check.sh --agents=$AGENTS"
      ;;
    plan|planno)
      run_stage "plan review (planno)" \
        "echo 'planno 스킬로 계획을 검토하세요: planno로 $FEATURE 구현 계획 검토해줘'"
      ;;
    conductor)
      run_stage "parallel agents (conductor)" \
        "$NO_ATTACH_ENV bash $SCRIPTS_DIR/conductor.sh '$FEATURE' '$BASE_BRANCH' '$AGENTS'"
      ;;
    pr)
      run_stage "PR creation" \
        "bash $SCRIPTS_DIR/conductor-pr.sh '$FEATURE' '$BASE_BRANCH'"
      ;;
    copilot)
      run_stage "copilot assignment" \
        "bash $SCRIPTS_DIR/copilot-assign-issue.sh"
      ;;
    *)
      warn "알 수 없는 단계: $s (건너뜀)"
      ;;
  esac
done

# ─── 완료 ────────────────────────────────────────────────────────────────────
echo ""
echo "╔═══════════════════════════════════════════════╗"
echo "║  파이프라인 완료!                               ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""
echo "상태 파일: .conductor-pipeline-state.json"
echo ""
if [[ "$DRY_RUN" != "true" ]]; then
  echo "생성된 PR 확인:"
  echo "  gh pr list --search 'feat/$FEATURE'"
fi
