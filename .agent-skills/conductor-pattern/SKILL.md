---
name: conductor-pattern
keyword: conductor
description: git worktree로 Claude/Codex/Gemini 에이전트를 병렬 실행하는 Conductor 패턴. 동일 스펙을 여러 에이전트가 독립 브랜치에서 동시 구현하고 PR로 비교.
allowed-tools: [Read, Write, Bash, Grep, Glob]
tags: [conductor, git-worktree, parallel-agents, claude-code, codex, multi-agent, pr-comparison]
platforms: [Claude, Codex, Gemini]
version: 1.0.0
source: https://code.claude.com/docs/en/common-workflows
---

# Conductor Pattern — 병렬 AI 에이전트 오케스트레이션

> git worktree로 에이전트별 샌드박스를 생성하고, 동일 스펙을 Claude/Codex/Gemini가 동시에 구현한 뒤 PR로 비교합니다.

## When to use this skill

- 동일 기능을 여러 AI 에이전트 버전으로 비교하고 싶을 때
- 난이도 높은 리팩터링에서 리스크를 분산하고 싶을 때
- Claude(설계) + Codex(보일러플레이트) 식의 역할 분담 병렬 작업
- git 충돌 없이 여러 에이전트가 동시에 같은 레포에서 작업할 때

---

## 전제 조건

```bash
# 필수 도구
git --version          # git worktree 지원 필요
tmux -V                # 병렬 세션 관리
gh --version           # PR 생성 (GitHub CLI)

# 에이전트 CLI (하나 이상)
claude --version       # Claude Code CLI
codex --version        # OpenAI Codex CLI (선택)
gemini --version       # Gemini CLI (선택)
```

---

## 디렉토리 구조

```
repo-root/
├── .git/
├── src/
├── trees/                        ← 에이전트별 worktree
│   ├── feat-<name>-claude/
│   ├── feat-<name>-codex/
│   └── feat-<name>-gemini/
├── scripts/
│   ├── conductor.sh              ← 메인 실행 스크립트
│   ├── conductor-pr.sh           ← PR 생성
│   ├── conductor-cleanup.sh      ← worktree 정리
│   ├── pipeline.sh               ← 통합 파이프라인
│   ├── pipeline-check.sh         ← 사전 점검
│   └── hooks/                    ← 단계별 훅
│       ├── pre-conductor.sh
│       └── post-conductor.sh
└── .conductor-pipeline-state.json
```

---

## 빠른 시작

```bash
# 1. 사전 점검
bash scripts/pipeline-check.sh --agents=claude,codex

# 2. 에이전트 병렬 실행 (tmux 세션 자동 생성)
bash scripts/conductor.sh user-dashboard main claude,codex

# 3. 에이전트 작업 완료 후 PR 생성
bash scripts/conductor-pr.sh user-dashboard main

# 4. 정리
bash scripts/conductor-cleanup.sh user-dashboard
```

### 통합 파이프라인 (권장)

```bash
# 모든 단계 한번에
bash scripts/pipeline.sh user-dashboard --stages check,conductor,pr

# 계획 검토 포함
bash scripts/pipeline.sh user-dashboard --stages check,plan,conductor,pr

# 드라이런 (미리보기)
bash scripts/pipeline.sh user-dashboard --dry-run

# 실패 후 재개
bash scripts/pipeline.sh --resume
```

---

## 파이프라인 플래그

| 플래그 | 설명 | 기본값 |
|--------|------|--------|
| `--base <branch>` | 베이스 브랜치 | `main` |
| `--agents <list>` | 쉼표 구분 에이전트 | `claude,codex` |
| `--stages <list>` | 실행 단계: check,plan,conductor,pr | 모두 |
| `--no-attach` | tmux 비연결 (CI용) | — |
| `--dry-run` | 실행 없이 미리보기 | — |
| `--resume` | 마지막 실패 단계부터 재개 | — |

---

## Worktree 격리 원리

```bash
# Claude용 worktree + 브랜치 생성
git worktree add trees/feat-<name>-claude -b feat/<name>-claude main

# Codex용 worktree + 브랜치 생성
git worktree add trees/feat-<name>-codex  -b feat/<name>-codex  main
```

- `.git` 디렉토리와 히스토리는 공유
- 각 `trees/*` 폴더의 작업 파일은 완전 분리
- 에이전트 간 파일 충돌 불가능

---

## 병합/PR 전략

```bash
# 각 에이전트 결과를 PR로 비교
feat/<name>-claude  ─┐
feat/<name>-codex   ─┼─ 비교 리뷰 → best-of-both → main
feat/<name>-gemini  ─┘
```

리뷰 옵션:
1. 단일 PR 선택 → merge
2. cherry-pick으로 최적 조합 생성
3. `feat/<name>-best` 브랜치 수동 조합 후 merge

---

## 훅 시스템

```
scripts/hooks/
├── pre-conductor.sh    # conductor 시작 전 (실패 시 중단)
├── post-conductor.sh   # conductor 완료 후 (실패 시 경고만)
├── pre-pr.sh           # PR 생성 전 (실패 시 중단)
└── post-pr.sh          # PR 생성 후
```

```bash
# 훅 스킵
CONDUCTOR_SKIP_HOOKS=1 bash scripts/pipeline.sh ...

# 커스텀 훅 디렉토리
CONDUCTOR_HOOKS_DIR=/path/to/hooks bash scripts/pipeline.sh ...
```

---

## 대표 사용 케이스

### 1. 동일 스펙 여러 구현 비교
```
UI 리디자인을 Claude / Codex / Gemini 3가지 버전으로 동시 생성
→ 디자인/코드품질/성능 비교 후 최적 선택
```

### 2. 리스크 헷징
```
난이도 높은 리팩터링:
  에이전트 A 실패 → 에이전트 B 성공 확률로 커버
  두 결과 중 더 안전한 구현 선택
```

### 3. 역할 분담 병렬 작업
```
Claude  → 도메인 로직/설계 (feat/<name>-claude)
Codex   → 보일러플레이트/테스트/타입 (feat/<name>-codex)
Gemini  → 문서/스토리북 (feat/<name>-gemini)
```

---

## 참고 레퍼런스

- [Claude Code 공식: Run parallel sessions with Git worktrees](https://code.claude.com/docs/en/common-workflows)
- [Leverage git worktree to parallelize work with Codex, Claude Code](https://dev.to/qlerebours_/leverage-git-worktree-to-parallelize-work-with-codex-claude-code-etc-1np1)
- [Using Git Worktrees for Parallel AI Development](https://stevekinney.com/courses/ai-development/git-worktrees)
- [Parallel AI Coding with Git Worktrees](https://docs.agentinterviews.com/blog/parallel-ai-coding-with-gitworktrees/)
- [Claude Code & Git Worktrees 데모 영상](https://www.youtube.com/watch?v=an-Abb7b2XM)

---

## Quick Reference

```
=== conductor 명령어 ===
pipeline.sh <feat> --stages check,conductor,pr   전체 파이프라인
conductor.sh <feat> main claude,codex            에이전트 병렬 실행
conductor-pr.sh <feat> main                      PR 생성
conductor-cleanup.sh <feat>                      worktree 정리

=== worktree 수동 관리 ===
git worktree list                                목록 확인
git worktree remove trees/feat-<name>-<agent>   개별 제거
git worktree prune                               고아 worktree 정리

=== 훅 ===
CONDUCTOR_SKIP_HOOKS=1   모든 훅 건너뜀
--dry-run                실행 없이 미리보기
--resume                 실패 단계부터 재개
```
