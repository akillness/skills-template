# Script Reference

아래 스크립트는 `agentskills/scripts`에서 실제 동작하는 오퍼레이터입니다.

## 핵심 스크립트

| 파일 | 용도 | 사용법 |
|---|---|---|
| `scripts/pipeline-check.sh` | 실행 전 선점검 | `bash scripts/pipeline-check.sh --agents=claude,codex` |
| `scripts/conductor.sh` | 병렬 에이전트 worktree 생성/실행 | `bash scripts/conductor.sh <feature-name> [base-branch] [agents]` |
| `scripts/conductor-pr.sh` | 각 worktree 브랜치 커밋/푸시/PR 생성 | `bash scripts/conductor-pr.sh <feature-name> [base-branch]` |
| `scripts/conductor-cleanup.sh` | worktree, tmux 세션, 로컬 브랜치 정리 | `bash scripts/conductor-cleanup.sh <feature-name>` |
| `scripts/pipeline.sh` | check → conductor → pr 전체 자동화 | `bash scripts/pipeline.sh <feature-name> [options]` |
| `scripts/copilot-setup-workflow.sh` | Copilot 워크플로우/secret/라벨 설치 | `bash scripts/copilot-setup-workflow.sh` |
| `scripts/copilot-assign-issue.sh` | 기존 이슈 번호를 Copilot에 직접 할당 | `bash scripts/copilot-assign-issue.sh <issue-number>` |
| `scripts/vibe-kanban-start.sh` | Vibe Kanban UI 실행 | `bash scripts/vibe-kanban-start.sh [--port 3000] [--remote]` |

## 파이프라인 옵션 (scripts/pipeline.sh)

| 옵션 | 설명 |
|---|---|
| `--base <branch>` | 기본 브랜치 지정 (기본 `main`) |
| `--agents <list>` | 에이전트 목록(쉼표 구분) |
| `--stages <list>` | 실행 단계: `check,plan,conductor,pr,copilot` |
| `--no-attach` | tmux 세션을 강제로 attach 하지 않음 |
| `--dry-run` | 실행 없이 단계만 출력 |
| `--resume` | 이전 실패 지점부터 재개 |

## 훅(Hooks)

기본 경로: `scripts/hooks/`

- `pre-conductor.sh`: conductor 실행 전, 실패 시 전체 중단
- `post-conductor.sh`: conductor 완료 후, 실패 시 경고만

`CONDUCTOR_SKIP_HOOKS=1` 로 모든 훅 스킵이 가능합니다.
`CONDUCTOR_HOOKS_DIR=<custom-dir>` 로 커스텀 훅 디렉토리를 지정할 수 있습니다.

## 사용 중 자주 발생하는 산출물

- worktree: `trees/feat-<name>-<agent>`
- 브랜치: `feat/<name>-<agent>`
- 파이프라인 상태: `.conductor-pipeline-state.json`
