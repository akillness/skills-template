---
name: vibe-kanban
keyword: kanbanview
description: AI 코딩 에이전트를 시각적 Kanban 보드에서 관리. To Do→In Progress→Review→Done 흐름으로 병렬 에이전트 실행, git worktree 자동 격리, GitHub PR 자동 생성.
allowed-tools: [Read, Write, Bash, Grep, Glob]
tags: [vibe-kanban, kanban, kanbanview, multi-agent, git-worktree, github-pr, task-management, claude-code, codex, gemini, mcp]
platforms: [Claude, Codex, Gemini]
version: 1.1.0
source: https://github.com/BloopAI/vibe-kanban
---

# Vibe Kanban — AI 에이전트 칸반 보드

> 여러 AI 에이전트(Claude/Codex/Gemini)를 하나의 Kanban 보드에서 통합 관리합니다.
> 카드(태스크)를 In Progress로 옮기면 git worktree 생성 + 에이전트 실행이 자동 시작됩니다.

## When to use this skill

- 에픽을 여러 독립 태스크로 분해해 에이전트에게 병렬 할당할 때
- 진행 중인 AI 작업 상태를 시각적으로 추적하고 싶을 때
- 에이전트 결과를 UI에서 diff/로그로 리뷰하고 재시도하고 싶을 때
- GitHub PR 기반 팀 협업과 AI 에이전트 작업을 결합할 때

---

## 전제 조건

```bash
# Node.js 18+ 필요
node --version

# 에이전트 인증 미리 완료
claude --version    # ANTHROPIC_API_KEY 설정
# codex --version   # OPENAI_API_KEY 설정 (선택)
# gemini --version  # Google 인증 (선택)
```

---

## 설치 & 실행

### npx (가장 빠름)

```bash
# 즉시 실행 (설치 불필요)
npx vibe-kanban

# 포트 지정
npx vibe-kanban --port 3001

# 래퍼 스크립트 사용
bash scripts/vibe-kanban-start.sh
```

브라우저에서 `http://localhost:3000` 자동 오픈.

### 직접 클론 + 개발 모드

```bash
git clone https://github.com/BloopAI/vibe-kanban.git
cd vibe-kanban
pnpm i
pnpm run dev
```

---

## 환경 변수

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `PORT` | 서버 포트 | 자동할당 |
| `HOST` | 서버 호스트 | `127.0.0.1` |
| `VIBE_KANBAN_REMOTE` | 원격 연결 허용 | `false` |
| `VK_ALLOWED_ORIGINS` | CORS 허용 출처 | 미설정 |
| `DISABLE_WORKTREE_CLEANUP` | worktree 정리 비활성화 | 미설정 |
| `ANTHROPIC_API_KEY` | Claude 에이전트용 | — |
| `OPENAI_API_KEY` | Codex/GPT 에이전트용 | — |

`.env` 파일에 설정 후 서버 시작.

---

## MCP 설정

Vibe Kanban은 MCP(Model Context Protocol) 서버로 동작하여 에이전트가 직접 보드를 제어할 수 있습니다.

### Claude Code MCP 설정

`~/.claude/settings.json` 또는 프로젝트의 `.mcp.json`:

```json
{
  "mcpServers": {
    "vibe-kanban": {
      "command": "npx",
      "args": ["vibe-kanban", "--mcp"],
      "env": {
        "MCP_HOST": "127.0.0.1",
        "MCP_PORT": "3001"
      }
    }
  }
}
```

### MCP 도구 목록

| 도구 | 설명 |
|------|------|
| `vk_list_tasks` | 모든 태스크 조회 |
| `vk_create_task` | 새 태스크 생성 |
| `vk_move_task` | 태스크 상태 변경 |
| `vk_get_diff` | 태스크 diff 조회 |
| `vk_retry_task` | 태스크 재실행 |

---

## 태스크 → 병렬 에이전트 → PR 워크플로우

### 1. 서버 시작

```bash
npx vibe-kanban
# → http://localhost:3000
```

### 2. (선택) planno로 에픽 계획 검토

```text
planno로 이 기능의 구현 계획을 검토해줘
```

planno(plannotator)는 독립 스킬 — Vibe Kanban 없이도 사용 가능.

### 3. 태스크 카드 생성

- **To Do** 칼럼에 카드 추가
- 제목, 설명, 우선순위(High/Medium/Low) 입력
- 에이전트(Claude/Codex/Gemini) 선택

### 4. In Progress → 에이전트 자동 시작

카드를 **In Progress**로 드래그하면:
- `vk/<hash>-<slug>` 브랜치 자동 생성
- git worktree 자동 생성 (에이전트별 완전 격리)
- 선택한 에이전트 CLI 실행 + 로그 스트리밍

### 5. Review 칼럼

- 해당 브랜치 diff를 웹 UI에서 확인
- 에이전트 로그와 "생각 과정" 확인
- 필요 시 "Retry" 또는 다른 에이전트로 교체

### 6. PR 생성 & Done

- 승인 시 GitHub에 PR 자동 생성
- PR merge → 카드 **Done** 이동
- worktree 자동 정리

---

## Git Worktree 격리 구조

```
.vk/trees/
├── feat-<slug-1>/    ← 카드1 에이전트 격리 환경
├── feat-<slug-2>/    ← 카드2 에이전트 격리 환경
└── feat-<slug-3>/    ← 카드3 에이전트 격리 환경
```

내부 동작:
```bash
git worktree add .vk/trees/<task-slug> -b vk/<hash>-<task-slug> main
<agent-cli> -p "<task-description>" --cwd .vk/trees/<task-slug>
```

---

## 원격 배포

### Docker

```bash
# 공식 이미지
docker run -p 3000:3000 vibekanban/vibe-kanban

# 환경 변수 전달
docker run -p 3000:3000 \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  -e VK_ALLOWED_ORIGINS=https://vk.example.com \
  vibekanban/vibe-kanban
```

### 리버스 프록시 (Nginx/Caddy)

```bash
# CORS 허용 필수
VK_ALLOWED_ORIGINS=https://vk.example.com

# 또는 다중 출처
VK_ALLOWED_ORIGINS=https://a.example.com,https://b.example.com
```

### SSH 원격 열기

VSCode Remote-SSH와 통합:
```
vscode://vscode-remote/ssh-remote+user@host/path/to/.vk/trees/<task-slug>
```

---

## 트러블슈팅

### Worktree 충돌 / 고아 worktree

```bash
# 고아 worktree 정리
git worktree prune

# 현재 worktree 목록 확인
git worktree list

# 특정 worktree 강제 삭제
git worktree remove .vk/trees/<slug> --force
```

### 403 Forbidden (CORS 오류)

```bash
# 원격 접속 시 CORS 설정 필요
VK_ALLOWED_ORIGINS=https://your-domain.com npx vibe-kanban
```

### 에이전트가 시작되지 않음

```bash
# CLI 직접 테스트
claude --version
codex --version

# API 키 확인
echo $ANTHROPIC_API_KEY
echo $OPENAI_API_KEY
```

### 포트 충돌

```bash
# 다른 포트 사용
npx vibe-kanban --port 3001

# 또는 환경 변수
PORT=3001 npx vibe-kanban
```

### SQLite 락 오류

```bash
# worktree 정리 비활성화 후 재시작
DISABLE_WORKTREE_CLEANUP=1 npx vibe-kanban
```

---

## UI vs CLI 선택 기준

| 상황 | 모드 |
|------|------|
| 팀 공유 보드, 시각적 진행 추적 | UI (`npx vibe-kanban`) |
| CI/CD 파이프라인, 스크립트 자동화 | CLI (`scripts/pipeline.sh`) |
| 빠른 로컬 실험 | CLI (`scripts/conductor.sh`) |
| 브라우저 diff/로그 리뷰 | UI |

---

## 대표 사용 케이스

### 1. 에픽 병렬 분해 처리

```
"결제 플로우 v2" 에픽
  ├── 카드1: 프론트엔드 UI  → Claude
  ├── 카드2: 백엔드 API     → Codex
  └── 카드3: 통합 테스트    → Claude
→ 3개 카드 동시 In Progress → 병렬 구현
```

### 2. 역할별 전문 에이전트 배치

```
Claude  → 설계/도메인 heavy 기능
Codex   → 타입/테스트/리팩터링
Gemini  → 문서/스토리북 작성
```

### 3. GitHub PR 기반 팀 협업

```
VIBE_KANBAN_REMOTE=true 설정
→ 팀원이 보드에서 상태 확인
→ GitHub PR에서만 리뷰/승인
→ 에이전트 병렬 + 전통 PR 프로세스 결합
```

### 4. 구현 비교

```
동일 태스크, 두 개 카드:
  카드A → Claude (UI 구조 중심)
  카드B → Codex (성능 최적화 중심)
→ PR 비교 후 best-of-both 선택
```

---

## 팁

- 카드 범위를 좁게 유지 (1카드 = 1커밋 단위)
- 2개 파일 이상 변경 시 planno로 먼저 계획 검토
- `VIBE_KANBAN_REMOTE=true`는 신뢰 네트워크에서만 사용
- 에이전트 스탈 시 → 재할당 또는 카드 분할

---

## 아키텍처 개요

```
┌─────────────────────────────────────────────────────────┐
│                    Vibe Kanban UI                       │
│   ┌──────────┬──────────┬──────────┬──────────┐        │
│   │  To Do   │In Progress│  Review  │   Done   │        │
│   └──────────┴──────────┴──────────┴──────────┘        │
└───────────────────────────┬─────────────────────────────┘
                            │ REST API
┌───────────────────────────▼─────────────────────────────┐
│                    Rust Backend                         │
│  ┌─────────┐  ┌──────────┐  ┌─────────┐  ┌──────────┐  │
│  │ server  │  │executors │  │   git   │  │ services │  │
│  └─────────┘  └──────────┘  └─────────┘  └──────────┘  │
│                   │                                     │
│             ┌─────▼─────┐                               │
│             │  SQLite   │                               │
│             └───────────┘                               │
└─────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
   ┌────▼────┐        ┌─────▼─────┐       ┌────▼────┐
   │ Claude  │        │   Codex   │       │ Gemini  │
   │worktree1│        │ worktree2 │       │worktree3│
   └─────────┘        └───────────┘       └─────────┘
```

---

## 참고 레퍼런스

- [GitHub 리포: BloopAI/vibe-kanban](https://github.com/BloopAI/vibe-kanban)
- [공식 랜딩 페이지: vibekanban.com](https://vibekanban.online)
- [아키텍처 분석: vibe-kanban – a Kanban board for AI agents](https://virtuslab.com/blog/ai/vibe-kanban/)
- [한국어 도입기](https://bluedreamer-twenty.tistory.com/7)
- [데모: Run Multiple Claude Code Agents Without Git Conflicts](https://www.youtube.com/watch?v=W45XJWZiwPM)
- [데모: Claude Code Just Got Way Better | Auto Claude Kanban Boards](https://www.youtube.com/watch?v=vPPAhTYoCdA)

---

## 스킬 파일 구조

```
.agent-skills/vibe-kanban/
├── SKILL.md              # 메인 스킬 문서
├── SKILL.toon            # TOON 형식 (압축)
├── scripts/
│   ├── start.sh          # 서버 시작 래퍼
│   ├── cleanup.sh        # Worktree 정리
│   ├── mcp-setup.sh      # MCP 설정 자동화
│   └── health-check.sh   # 서버 상태 확인
├── references/
│   ├── environment-variables.md  # 환경 변수 레퍼런스
│   └── mcp-api.md                # MCP API 레퍼런스
└── templates/
    ├── claude-mcp-config.json    # Claude Code MCP 설정
    ├── docker-compose.yml        # Docker 배포 템플릿
    └── .env.example              # 환경 변수 예시
```

### 스크립트 사용법

```bash
# 서버 시작
bash scripts/start.sh --port 3001

# Worktree 정리
bash scripts/cleanup.sh --dry-run  # 미리보기
bash scripts/cleanup.sh --all       # 모든 VK worktree 삭제

# MCP 설정
bash scripts/mcp-setup.sh --claude  # Claude Code 설정
bash scripts/mcp-setup.sh --all     # 모든 에이전트 설정

# 상태 확인
bash scripts/health-check.sh
bash scripts/health-check.sh --json  # JSON 출력
```

---

## Quick Reference

```
=== 서버 실행 ===
npx vibe-kanban                  즉시 실행
npx vibe-kanban --port 3001      포트 지정
http://localhost:3000             보드 UI

=== 환경 변수 ===
PORT=3001                        포트 변경
VK_ALLOWED_ORIGINS=https://...   CORS 허용
ANTHROPIC_API_KEY=...            Claude 인증

=== MCP 연동 ===
npx vibe-kanban --mcp            MCP 모드
vk_list_tasks                    태스크 조회
vk_create_task                   태스크 생성
vk_move_task                     상태 변경

=== 카드 흐름 ===
To Do → In Progress → Review → Done
In Progress: worktree 생성 + 에이전트 시작
Review: diff/로그 확인 + Retry 가능
Done: PR merge 완료

=== worktree 정리 ===
git worktree prune               고아 정리
git worktree list                목록 확인
git worktree remove <path>       강제 삭제
```
