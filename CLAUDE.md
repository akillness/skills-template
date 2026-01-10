# Agent Skills - Multi-Agent Workflow

> 이 프로젝트는 Claude Code를 중심으로 Gemini-CLI와 Codex-CLI를 통합하는 Multi-Agent 시스템입니다.

## Agent Roles

| Agent | Role | MCP Tool | Best For |
|-------|------|----------|----------|
| **Claude Code** | Orchestrator | Built-in | 계획 수립, 코드 생성, 스킬 해석 |
| **Gemini-CLI** | Analyst | `ask-gemini` | 대용량 분석, 리서치, 코드 리뷰 |
| **Codex-CLI** | Executor | `shell` | 명령 실행, 빌드, 배포 |

## Multi-Agent Workflow

### When to Use Each Agent

**Claude Code (기본)**: 코드 작성/수정, 파일 읽기/쓰기, 스킬 기반 작업 계획

**Gemini-CLI (`ask-gemini`)**: 대용량 코드베이스 분석 (1M+ 토큰), 복잡한 아키텍처 리서치

**Codex-CLI (`shell`)**: 장시간 실행 명령, Docker/Kubernetes 작업, 빌드/배포

### Skill Integration

```bash
# 스킬 쿼리 (기본: toon 모드 - 95% 토큰 절감)
gemini-skill "API 설계해줘"
gemini-skill "query" compact  # 88% 절감
gemini-skill "query" full     # 상세
```

### Orchestration Examples

**API 설계 + 구현**:
1. [Claude] 스킬 로드 → API 스펙 설계
2. [Codex] shell "npm test"
3. [Claude] 결과 리포트

**대규모 코드 리뷰**:
1. [Gemini] ask-gemini "@src/ 전체 분석"
2. [Claude] 개선점 도출 및 수정

## Available Skills

- `backend/`: API 설계, DB 스키마, 인증
- `frontend/`: UI 컴포넌트, 상태 관리
- `code-quality/`: 코드 리뷰, 디버깅
- `infrastructure/`: 배포, 모니터링, 보안
- `documentation/`: 기술 문서, API 문서
- `utilities/`: Git, 환경 설정

## MCP Server Check

```bash
claude mcp list
# Expected: gemini-cli, codex-cli - Connected
```

---
**Version**: 2.3.0 | **Workflow**: Multi-Agent
