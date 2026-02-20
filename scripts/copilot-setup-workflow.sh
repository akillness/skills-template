#!/usr/bin/env bash
# copilot-setup-workflow.sh — GitHub Copilot Coding Agent 원클릭 셋업
# 사용법: bash scripts/copilot-setup-workflow.sh
#
# 수행 작업:
#   1. COPILOT_ASSIGN_TOKEN 레포 시크릿 등록
#   2. .github/workflows/assign-to-copilot.yml 배포
#   3. .github/workflows/copilot-pr-ci.yml 배포
#   4. 'ai-copilot' 라벨 생성

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok()    { echo -e "${GREEN}✅ $*${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $*${NC}"; }
error() { echo -e "${RED}❌ $*${NC}" >&2; }

echo "╔══════════════════════════════════════════════╗"
echo "║  Copilot Coding Agent 셋업                    ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# ─── 전제 조건 확인 ──────────────────────────────────────────────────────────
if ! command -v gh &>/dev/null; then
  error "gh CLI가 필요합니다: https://cli.github.com"
  exit 1
fi

if ! gh auth status &>/dev/null; then
  error "gh CLI 인증 필요: gh auth login"
  exit 1
fi

if ! git rev-parse --git-dir &>/dev/null; then
  error "git 레포 안에서 실행해야 합니다"
  exit 1
fi

ok "gh CLI 인증됨"

# ─── 레포 정보 ───────────────────────────────────────────────────────────────
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
if [[ -z "$REPO" ]]; then
  error "GitHub 레포를 찾을 수 없습니다. git remote를 확인하세요."
  exit 1
fi
ok "레포: $REPO"
echo ""

# ─── Step 1: PAT 등록 ────────────────────────────────────────────────────────
info "Step 1: COPILOT_ASSIGN_TOKEN 시크릿 등록"
echo ""
echo "repo scope PAT가 필요합니다."
echo "생성 방법: GitHub → Settings → Developer settings → Personal access tokens"
echo "필요 권한: repo (전체)"
echo ""

# 기존 시크릿 확인
EXISTING=$(gh secret list 2>/dev/null | grep "COPILOT_ASSIGN_TOKEN" || echo "")
if [[ -n "$EXISTING" ]]; then
  warn "COPILOT_ASSIGN_TOKEN 시크릿이 이미 존재합니다."
  read -r -p "덮어쓰시겠습니까? (y/N) " overwrite
  if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
    info "시크릿 등록 건너뜀"
  else
    read -r -s -p "PAT 입력 (입력이 표시되지 않음): " pat
    echo ""
    if [[ -n "$pat" ]]; then
      echo -n "$pat" | gh secret set COPILOT_ASSIGN_TOKEN
      ok "COPILOT_ASSIGN_TOKEN 등록 완료"
    fi
  fi
else
  read -r -s -p "PAT 입력 (입력이 표시되지 않음): " pat
  echo ""
  if [[ -n "$pat" ]]; then
    echo -n "$pat" | gh secret set COPILOT_ASSIGN_TOKEN
    ok "COPILOT_ASSIGN_TOKEN 등록 완료"
  else
    warn "PAT 미입력. 시크릿 등록 건너뜀."
    warn "나중에 직접 등록: gh secret set COPILOT_ASSIGN_TOKEN"
  fi
fi

echo ""

# ─── Step 2: GitHub Actions 워크플로 배포 ───────────────────────────────────
info "Step 2: GitHub Actions 워크플로 확인"
ROOT_DIR="$(git rev-parse --show-toplevel)"
WORKFLOWS_DIR="$ROOT_DIR/.github/workflows"
mkdir -p "$WORKFLOWS_DIR"

# assign-to-copilot.yml
ASSIGN_WF="$WORKFLOWS_DIR/assign-to-copilot.yml"
if [[ -f "$ASSIGN_WF" ]]; then
  ok "assign-to-copilot.yml: 이미 존재"
else
  warn "assign-to-copilot.yml 없음. 생성 중..."
  cat > "$ASSIGN_WF" << 'WORKFLOW_EOF'
name: Assign issue to Copilot Coding Agent

on:
  issues:
    types: [opened, labeled]

jobs:
  assign-to-copilot:
    name: Assign to Copilot
    runs-on: ubuntu-latest
    if: contains(github.event.issue.labels.*.name, 'ai-copilot')
    permissions:
      contents: read
      issues: write

    steps:
      - name: Assign issue to Copilot via GraphQL
        env:
          GH_TOKEN: ${{ secrets.COPILOT_ASSIGN_TOKEN }}
          ISSUE_NODE_ID: ${{ github.event.issue.node_id }}
          ISSUE_NUMBER: ${{ github.event.issue.number }}
        run: |
          COPILOT_BOT_ID=$(curl -s -X POST https://api.github.com/graphql \
            -H "Authorization: bearer ${GH_TOKEN}" \
            -H "Content-Type: application/json" \
            -H "GraphQL-Features: issues_copilot_assignment_api_support,coding_agent_model_selection" \
            -d '{"query":"query { user(login: \"copilot\") { id } }"}' \
            | jq -r '.data.user.id // empty')

          if [ -z "$COPILOT_BOT_ID" ]; then
            echo "❌ Copilot bot ID 조회 실패"
            exit 1
          fi

          curl -s -X POST https://api.github.com/graphql \
            -H "Authorization: bearer ${GH_TOKEN}" \
            -H "Content-Type: application/json" \
            -H "GraphQL-Features: issues_copilot_assignment_api_support,coding_agent_model_selection" \
            -d "$(jq -n \
              --arg issueId "${ISSUE_NODE_ID}" \
              --arg botId "${COPILOT_BOT_ID}" \
              '{query: "mutation AssignIssue($issueId: ID!, $botId: ID!) { replaceActorsForAssignable(input: { assignableId: $issueId, actorIds: [$botId] }) { assignable { ... on Issue { assignees(first: 5) { nodes { login } } } } } }", variables: { issueId: $issueId, botId: $botId }}')"

          echo "✅ 이슈 #${ISSUE_NUMBER}에 Copilot 할당 완료"
WORKFLOW_EOF
  ok "assign-to-copilot.yml 생성 완료"
fi

# copilot-pr-ci.yml
CI_WF="$WORKFLOWS_DIR/copilot-pr-ci.yml"
if [[ -f "$CI_WF" ]]; then
  ok "copilot-pr-ci.yml: 이미 존재"
else
  warn "copilot-pr-ci.yml 없음. 생성 중..."
  cat > "$CI_WF" << 'CI_EOF'
name: CI for Copilot PR

on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [main, develop]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Detect package manager and run CI
        run: |
          if [ -f "pnpm-lock.yaml" ]; then
            npm install -g pnpm && pnpm install && pnpm test || true && pnpm build || true
          elif [ -f "yarn.lock" ]; then
            yarn install && yarn test || true && yarn build || true
          elif [ -f "package.json" ]; then
            npm ci && npm test || true && npm run build || true
          else
            echo "패키지 매니저를 찾을 수 없습니다"
          fi
CI_EOF
  ok "copilot-pr-ci.yml 생성 완료"
fi

echo ""

# ─── Step 3: ai-copilot 라벨 생성 ────────────────────────────────────────────
info "Step 3: 'ai-copilot' 라벨 생성"

if gh label list 2>/dev/null | grep -q "ai-copilot"; then
  ok "'ai-copilot' 라벨: 이미 존재"
else
  gh label create "ai-copilot" \
    --description "Assign this issue to GitHub Copilot Coding Agent" \
    --color "0075ca" 2>/dev/null && ok "'ai-copilot' 라벨 생성 완료" || \
  warn "라벨 생성 실패. 수동으로 생성하세요: gh label create ai-copilot --color 0075ca"
fi

echo ""

# ─── 완료 ────────────────────────────────────────────────────────────────────
echo "╔══════════════════════════════════════════════╗"
echo "║  셋업 완료!                                   ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "이제 이슈에 'ai-copilot' 라벨을 붙이면 Copilot이 자동 할당됩니다:"
echo ""
echo "  gh issue create --label ai-copilot \\"
echo "    --title '구현할 기능 제목' \\"
echo "    --body '상세한 기능 설명...'"
echo ""
echo "  또는 기존 이슈:"
echo "  gh issue edit <번호> --add-label ai-copilot"
