# Gemini Agent Skills Setup Prompt

이 문서는 `/skills-template/.agent-skills/setup.sh` 스크립트를 사용하여 Gemini 환경에 맞는 스킬 시스템을 설정하기 위한 프롬프트 가이드입니다.

## 프롬프트 (Prompt)

아래 내용을 복사하여 AI 에이전트(Gemini)에게 전달하세요.

---

**Context:**
현재 프로젝트는 `/skills-template`에 위치해 있으며, Agent Skills 시스템을 도입하려고 합니다. 이를 위해 `.agent-skills/setup.sh` 설정 스크립트가 준비되어 있습니다.

**Task:**
Gemini CLI 환경에서 사용할 수 있도록 Agent Skills를 설정해주세요.

**Detailed Instructions:**
1.  `/skills-template/.agent-skills` 디렉토리로 이동하세요.
2.  `setup.sh` 스크립트를 실행하여 다음 옵션을 순서대로 선택하세요:
    *   **플랫폼 선택:** `3` (Gemini)
    *   **설정 모드:** `1` (Standard Context - 프로젝트 루트에 GEMINI.md 생성)
    *   **Python 의존성 설치:** `n` (현재는 설치하지 않음)
3.  스크립트 실행이 완료되면, 프로젝트 루트(`/skills-template/`)에 `GEMINI.md` 파일이 올바르게 생성되었는지 확인해주세요.
4.  생성된 `GEMINI.md`의 내용을 간략히 읽어보고, 어떤 스킬 카테고리들이 활성화되었는지 요약해주세요.

**Execution Command (Automation Hint):**
상호작용 없이 한 번에 실행하려면 다음 명령어를 사용할 수 있습니다:
```bash
cd /skills-template/.agent-skills && printf "3\n1\nn\n" | bash setup.sh
```

---

```