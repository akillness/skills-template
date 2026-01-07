---
name: prompt-engineering
description: AI 모델(Claude, GPT, Gemini)을 위한 효과적인 프롬프트 작성 및 최적화 스킬. 멀티 에이전트 워크플로우 설계 포함.
---

# Prompt Engineering

## When to use this skill
- AI 모델의 응답 품질이 낮거나 모호할 때 (프롬프트 최적화 필요 시)
- 복잡한 작업을 수행하기 위해 멀티 에이전트 워크플로우를 설계할 때
- 특정 출력 형식(JSON, 코드 등)을 엄격하게 준수해야 할 때
- Few-shot 예제를 통해 모델의 성능을 향상시켜야 할 때

## Instructions

### Step 1: 작업 정의 및 목표 설정 (Define Task & Goal)
작업의 목표를 명확히 정의하고, 모델이 수행해야 할 역할을 부여합니다.

- **Role**: 모델의 페르소나 정의 (예: "당신은 시니어 소프트웨어 엔지니어입니다.")
- **Goal**: 구체적인 작업 목표 서술
- **Context**: 작업에 필요한 배경 정보 제공

```markdown
# 역할 부여 예시
당신은 10년 경력의 데이터 분석가입니다. 주어진 판매 데이터를 분석하여 인사이트를 도출해주세요.
```

### Step 2: 프롬프트 구조화 및 컨텍스트 제공 (Structure & Context)
프롬프트를 논리적인 섹션으로 나누어 가독성을 높이고, 필요한 컨텍스트를 제공합니다. XML 태그 등을 활용하여 입력을 구분하는 것이 좋습니다.

- 입력 데이터와 지시사항을 명확히 분리
- `<context>`, `<instructions>`, `<input>` 등의 태그 활용

### Step 3: Few-shot 예제 작성 (Provide Few-Shot Examples)
모델이 원하는 출력을 이해하도록 예시를 제공합니다. 특히 복잡한 포맷이나 스타일을 요구할 때 효과적입니다.

```markdown
User: 사과의 색깔은?
Assistant: 빨간색
User: 바나나의 색깔은?
Assistant: 노란색
User: 하늘의 색깔은?
Assistant:
```

### Step 4: Chain-of-Thought (CoT) 유도
복잡한 추론이 필요한 경우, 모델이 생각하는 과정을 출력하도록 유도합니다. "단계별로 생각해보세요"와 같은 문구를 추가합니다.

### Step 5: 멀티 에이전트 워크플로우 설계 (Multi-Agent Design)
단일 프롬프트로 해결하기 어려운 작업은 여러 단계나 여러 에이전트로 분할합니다.

- **Planner Agent**: 전체 계획 수립
- **Executor Agent**: 각 단계 실행
- **Reviewer Agent**: 결과물 검증

## Examples

### Example 1: 코드 생성 프롬프트 (Claude/Gemini)
명확한 요구사항과 제약조건을 포함한 코드 생성 요청입니다.

```markdown
당신은 Python 전문가입니다. 다음 요구사항에 맞춰 CSV 파일을 읽고 처리하는 스크립트를 작성해주세요.

<requirements>
- `pandas` 라이브러리 사용
- 결측치는 평균값으로 대체
- 'date' 컬럼은 datetime 객체로 변환
- 처리된 데이터를 'processed_data.csv'로 저장
- 각 함수에 Google Style Docstring 추가
</requirements>

<input_format>
CSV 파일 경로: data/input.csv
</input_format>
```

**Expected output**:
```python
import pandas as pd
# ... (generated code)
```

### Example 2: 멀티 에이전트 계획 수립 (Architect/Planner)
복잡한 시스템 구축을 위한 계획을 수립하는 프롬프트입니다.

```markdown
당신은 시스템 아키텍트입니다. 사용자가 "실시간 채팅 애플리케이션"을 만들고 싶어합니다.
이 프로젝트를 위한 기술 스택을 제안하고, 개발 단계를 5단계로 나누어 상세히 기술해주세요.
각 단계별로 필요한 예상 파일 구조와 핵심 기능을 명시해야 합니다.
```

## Best practices

1. **명확하고 구체적인 지시 (Be Specific)**
   - 모호한 표현("적당히", "짧게")을 피하고, 구체적인 제약조건("3문장 이내", "JSON 형식")을 제시합니다.

2. **구조화된 포맷 사용 (Use Structured Format)**
   - Markdown 헤더, 불렛 포인트, XML 태그 등을 사용하여 프롬프트의 가독성을 높이고 모델이 구조를 파악하기 쉽게 합니다.

3. **반복적인 최적화 (Iterative Refinement)**
   - 한 번에 완벽한 결과를 기대하기보다, 결과를 보고 프롬프트를 수정/보완하는 과정을 거칩니다.

4. **출력 형식 지정 (Output Formatting)**
   - 결과를 파싱하기 쉽도록 JSON, Markdown, CSV 등 구체적인 포맷을 지정합니다.

## Common pitfalls

- **컨텍스트 누락**: 모델이 배경 지식 없이 추론하게 하여 환각(Hallucination)을 유발함.
- **과도한 복잡성**: 하나의 프롬프트에 너무 많은 지시사항을 넣어 모델이 일부를 무시하게 만듦. (작업 분할 필요)
- **부정적인 제약조건**: "하지 마세요"보다 "하세요" 긍정문이 더 효과적일 때가 많음.

## Troubleshooting

### Issue 1: 모델이 지시사항을 무시함
**Symptoms**: 출력 형식을 지키지 않거나 특정 제약조건을 위반함.
**Cause**: 프롬프트가 너무 길거나 지시사항이 충돌함. 또는 중요도가 낮게 인식됨.
**Solution**: 핵심 지시사항을 프롬프트의 맨 마지막에 다시 한 번 강조(Recap)하거나, 작업을 더 작은 단위로 분할.

### Issue 2: 환각 (Hallucination) 발생
**Symptoms**: 사실이 아닌 정보를 생성함.
**Cause**: 컨텍스트가 부족하거나 모델이 모르는 정보를 억지로 답하게 함.
**Solution**: "모르면 모른다고 대답하세요"라는 지시를 추가하고, 필요한 참조 문서(Reference Context)를 제공.

## References

- [Anthropic Prompt Engineering Guide](https://docs.anthropic.com/claude/docs/prompt-engineering)
- [Google Gemini Prompting Guide](https://ai.google.dev/gemini-api/docs/prompting-intro)
- [OpenAI Prompt Engineering](https://platform.openai.com/docs/guides/prompt-engineering)
