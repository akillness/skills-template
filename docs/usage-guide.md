# Usage Guide

`agentskills`는 설치 후 스킬 사용을 바로 적용할 수 있도록 스크립트 기반 워크플로를 제공합니다. 아래는 실제 사용에 맞춘 가시적 실행 순서입니다.

## A. Conductor Pattern: 병렬 에이전트 실행

### 1) 실행 전 점검

```bash
bash scripts/pipeline-check.sh --agents=claude,codex
```

필수 점검 항목:
- `git` + `git worktree`
- `tmux`
- `gh`(PR 생성 시)
- `claude`, `codex`, `gemini` 중 최소 1개 CLI

### 2) 병렬 실행

```bash
bash scripts/conductor.sh <feature-name> <base-branch> <agent-list>
# 예시
bash scripts/conductor.sh user-dashboard main claude,codex
```

생성 규칙:
- worktree: `trees/feat-<feature>-<agent>`
- branch: `feat/<feature>-<agent>`
- 기본 에이전트는 `claude,codex`

### 3) PR 생성

```bash
bash scripts/conductor-pr.sh <feature-name> <base-branch>
# 예시
bash scripts/conductor-pr.sh user-dashboard main
```

### 4) 정리

```bash
bash scripts/conductor-cleanup.sh <feature-name>
# 예시
bash scripts/conductor-cleanup.sh user-dashboard
```

## B. Pipeline 통합 실행

```bash
bash scripts/pipeline.sh <feature-name> --stages check,conductor,pr
bash scripts/pipeline.sh <feature-name> --stages check,plan,conductor,pr
bash scripts/pipeline.sh <feature-name> --dry-run
```

주요 옵션:
- `--base <branch>`: 기본 `main`
- `--agents <claude,codex,...>`: 에이전트 목록
- `--stages <check,plan,conductor,pr,copilot>`
- `--no-attach`: tmux 자동 attach 비활성
- `--resume`: 실패 단계부터 재개
- `--dry-run`: 실행 없이 예측 출력

## C. Hook(훅) 동작

현재 기본 훅 경로: `scripts/hooks/`
- `pre-conductor.sh` (실패 시 실행 중단)
- `post-conductor.sh` (실패해도 경고만)

추가 훅(`pre-pr`, `post-pr`)은 필요 시 동일 패턴으로 추가/교체 가능합니다.

```bash
# 모든 훅 건너뛰기
CONDUCTOR_SKIP_HOOKS=1 bash scripts/pipeline.sh <feature-name> --stages check,conductor,pr

# 훅 디렉토리 변경
CONDUCTOR_HOOKS_DIR=/path/to/hooks bash scripts/pipeline.sh <feature-name> --stages check,conductor,pr
```

## D. Copilot Coding Agent 연동

```bash
bash scripts/copilot-setup-workflow.sh
bash scripts/copilot-assign-issue.sh <issue-number>
```

`copilot-setup-workflow.sh`는 레포 secrets/워크플로우/라벨을 초기화하고,
`copilot-assign-issue.sh`는 기존 이슈를 직접 할당합니다.

## E. Vibe Kanban 실행

```bash
bash scripts/vibe-kanban-start.sh
bash scripts/vibe-kanban-start.sh --port 3001
bash scripts/vibe-kanban-start.sh --remote
```

Conductor와 동일한 에이전트 병렬 메커니즘을 UI로 사용하려면 Vibe Kanban 문서를 함께 확인하세요.

## F. 추천 운영 순서

1. `pipeline-check.sh`로 환경 점검
2. `pipeline.sh`로 check + conductor + pr
3. 완료 후 `conductor-cleanup.sh`로 worktree 정리
4. `git worktree list`/`git status`로 정합성 확인
