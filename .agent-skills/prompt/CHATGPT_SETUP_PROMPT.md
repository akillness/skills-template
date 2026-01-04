# ChatGPT용 Agent Skills 설정 프롬프트

이 문서는 `skills-template/.agent-skills/setup.sh`를 ChatGPT용으로 실행할 때 필요한 프롬프트와 실행 맥락을 정리한 것입니다.

## 실행 목적
- ChatGPT 설정 흐름(선택지 2)을 통해 `agent-skills-YYYYMMDD.zip`을 생성한다.
- 생성된 zip을 Custom GPT의 Knowledge에 업로드한다.

## 실행 전 확인
- 현재 작업 디렉터리가 `skills-template/.agent-skills`인지 확인한다.
- `setup.sh`는 해당 디렉터리 기준으로 경로를 찾는다.

## 실행 프롬프트
아래 내용을 그대로 실행하도록 지시한다.

```bash
printf "2\n" | bash setup.sh
```

## 기대 결과
- `agent-skills-YYYYMMDD.zip` 파일이 생성된다.
- 예시 출력(요약):
  - `Setting up for ChatGPT...`
  - `Creating zip file: agent-skills-YYYYMMDD.zip`
  - `Zip file created: agent-skills-YYYYMMDD.zip`

## 후속 작업
1. Custom GPT Builder에서 Knowledge에 `agent-skills-YYYYMMDD.zip` 업로드
2. 필요 시 `templates/chatgpt-skill-template/` 기반으로 `skills.md` 작성

## 참고 (이전 실행 히스토리)
- 작업 위치: `skills-template/.agent-skills`
- 선택지: `2) ChatGPT (Custom GPT setup instructions)`
- 생성 파일 예시: `agent-skills-20260102.zip`
