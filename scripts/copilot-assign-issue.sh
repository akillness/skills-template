#!/usr/bin/env bash
# copilot-assign-issue.sh — 기존 GitHub 이슈를 Copilot Coding Agent에 직접 할당
# 사용법: bash scripts/copilot-assign-issue.sh <issue-number>
#
# 환경 변수:
#   COPILOT_ASSIGN_TOKEN  — repo scope PAT (필수)
#   GH_TOKEN              — 대안 토큰
#
# 예시:
#   export COPILOT_ASSIGN_TOKEN=ghp_xxx
#   bash scripts/copilot-assign-issue.sh 42

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok()    { echo -e "${GREEN}✅ $*${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $*${NC}"; }
error() { echo -e "${RED}❌ $*${NC}" >&2; }

# ─── 인자 확인 ───────────────────────────────────────────────────────────────
ISSUE_NUMBER="${1:-}"

if [[ -z "$ISSUE_NUMBER" ]]; then
  error "사용법: $0 <issue-number>"
  error "예시:   $0 42"
  exit 1
fi

if ! [[ "$ISSUE_NUMBER" =~ ^[0-9]+$ ]]; then
  error "이슈 번호는 숫자여야 합니다: $ISSUE_NUMBER"
  exit 1
fi

# ─── 토큰 확인 ───────────────────────────────────────────────────────────────
TOKEN="${COPILOT_ASSIGN_TOKEN:-${GH_TOKEN:-}}"

if [[ -z "$TOKEN" ]]; then
  error "토큰이 필요합니다."
  error "환경 변수 설정: export COPILOT_ASSIGN_TOKEN=<your-pat>"
  error "또는: export GH_TOKEN=<your-pat>"
  exit 1
fi

# ─── gh CLI 및 레포 정보 ─────────────────────────────────────────────────────
if ! command -v gh &>/dev/null; then
  error "gh CLI가 필요합니다: https://cli.github.com"
  exit 1
fi

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
if [[ -z "$REPO" ]]; then
  error "GitHub 레포를 찾을 수 없습니다."
  exit 1
fi

echo "╔══════════════════════════════════════════════╗"
echo "║  Copilot 이슈 할당                            ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
info "레포: $REPO"
info "이슈: #$ISSUE_NUMBER"
echo ""

# ─── 이슈 node_id 조회 ───────────────────────────────────────────────────────
info "Step 1: 이슈 정보 조회..."
ISSUE_DATA=$(gh api "repos/$REPO/issues/$ISSUE_NUMBER" \
  --jq '{node_id: .node_id, title: .title, state: .state}' 2>/dev/null || echo "")

if [[ -z "$ISSUE_DATA" ]]; then
  error "이슈 #$ISSUE_NUMBER를 찾을 수 없습니다."
  exit 1
fi

ISSUE_NODE_ID=$(echo "$ISSUE_DATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['node_id'])")
ISSUE_TITLE=$(echo "$ISSUE_DATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['title'])")
ISSUE_STATE=$(echo "$ISSUE_DATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['state'])")

ok "이슈: #$ISSUE_NUMBER — $ISSUE_TITLE ($ISSUE_STATE)"
echo ""

if [[ "$ISSUE_STATE" != "open" ]]; then
  warn "이슈가 열려 있지 않습니다 (상태: $ISSUE_STATE). 계속하시겠습니까?"
  read -r -p "(y/N) " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
fi

# ─── Copilot bot GraphQL ID 조회 ─────────────────────────────────────────────
info "Step 2: Copilot bot ID 조회..."
GRAPHQL_RESPONSE=$(curl -s -X POST https://api.github.com/graphql \
  -H "Authorization: bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "GraphQL-Features: issues_copilot_assignment_api_support,coding_agent_model_selection" \
  -d '{"query":"query { user(login: \"copilot\") { id login } }"}')

COPILOT_BOT_ID=$(echo "$GRAPHQL_RESPONSE" | python3 -c "
import json,sys
d=json.load(sys.stdin)
print(d.get('data',{}).get('user',{}).get('id',''))
" 2>/dev/null || echo "")

if [[ -z "$COPILOT_BOT_ID" ]]; then
  error "Copilot bot ID 조회 실패."
  error "응답: $GRAPHQL_RESPONSE"
  error ""
  error "확인 사항:"
  error "  1. Copilot Coding Agent 활성화 여부 (Pro+/Business/Enterprise)"
  error "  2. PAT에 repo scope 부여 여부"
  exit 1
fi

ok "Copilot bot ID: $COPILOT_BOT_ID"
echo ""

# ─── Copilot을 assignee로 설정 ───────────────────────────────────────────────
info "Step 3: Copilot을 이슈 assignee로 설정..."
ASSIGN_RESPONSE=$(curl -s -X POST https://api.github.com/graphql \
  -H "Authorization: bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "GraphQL-Features: issues_copilot_assignment_api_support,coding_agent_model_selection" \
  -d "$(python3 -c "
import json
print(json.dumps({
  'query': '''mutation AssignIssue(\$issueId: ID!, \$botId: ID!) {
    replaceActorsForAssignable(input: { assignableId: \$issueId, actorIds: [\$botId] }) {
      assignable {
        ... on Issue {
          id
          title
          assignees(first: 5) { nodes { login } }
        }
      }
    }
  }''',
  'variables': {
    'issueId': '$ISSUE_NODE_ID',
    'botId': '$COPILOT_BOT_ID'
  }
}))
")")

# 오류 확인
ERRORS=$(echo "$ASSIGN_RESPONSE" | python3 -c "
import json,sys
d=json.load(sys.stdin)
errs=[e.get('message','') for e in d.get('errors',[])]
print('\n'.join(errs))
" 2>/dev/null || echo "")

if [[ -n "$ERRORS" ]]; then
  error "할당 실패:"
  echo "$ERRORS" | while read -r e; do error "  $e"; done
  exit 1
fi

ASSIGNEE=$(echo "$ASSIGN_RESPONSE" | python3 -c "
import json,sys
d=json.load(sys.stdin)
nodes=d.get('data',{}).get('replaceActorsForAssignable',{}).get('assignable',{}).get('assignees',{}).get('nodes',[])
print(', '.join([n.get('login','') for n in nodes]))
" 2>/dev/null || echo "copilot")

echo ""
ok "할당 완료! Assignee: $ASSIGNEE"
echo ""
echo "Copilot이 이슈 #$ISSUE_NUMBER를 처리하고 Draft PR을 생성합니다."
echo ""
echo "확인:"
echo "  gh issue view $ISSUE_NUMBER"
echo "  gh pr list --search 'head:copilot/'"
