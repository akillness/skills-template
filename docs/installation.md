# Installation Guide

`agentskills/README.md`의 핵심 설치 명령은 축약형이며, 이 문서는 정확한 설치 옵션을 정리합니다.

## 1) 기본 설치 경로(현재 저장소 기준)

```bash
# 전체 스킬 설치
npx skills add https://github.com/supercent-io/skills-template

# 특정 스킬만 설치
npx skills add https://github.com/supercent-io/skills-template --skill conductor-pattern
npx skills add https://github.com/supercent-io/skills-template --skill copilot-coding-agent
```

## 2) 특수/커뮤니티 스킬

- Awesome Claude Skills 소스에서 추가 스킬 설치:

```bash
npx skills add https://github.com/ComposioHQ/awesome-claude-skills --skill github-automation
npx skills add https://github.com/ComposioHQ/awesome-claude-skills --skill slack-automation
```

- 일부 스킬 소스는 독립 설치가 필요할 수 있습니다.

```bash
# Playwright 기반 브라우저 자동화
npx -y skills add remorses/playwriter
```

```bash
# Vercel-labs 에이전트 패키지
npx skills add vercel-labs/agent-browser
```

## 3) 설치 유효성 확인

```bash
# 등록된 스킬 목록 확인
python3 .agent-skills/skill_loader.py list

# 키워드 기반 검색
python3 .agent-skills/skill_loader.py search "rest api"

# 토큰 최적화 인덱스(TOON) 조회
python3 .agent-skills/skill_query_handler.py query "conductor"
```

## 4) 설치 후 권장 점검

- `agentskills/.agent-skills/README.md`의 카테고리/수량/버전 표와 일치하는지 확인
- `npx`가 없으면 Node.js 설치 후 재시도
- `skills.json`은 스킬 manifest이며, 수동 수정 시 형식 손상 주의
