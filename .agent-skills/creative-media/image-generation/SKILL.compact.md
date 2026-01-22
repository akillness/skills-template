# image-generation-mcp

> Generate high-quality images via MCP (Gemini models or compatible services) using structured prompts, ratios, and validation for marketing, UI, or ...

## When to use this skill
• **마케팅 에셋**: 히어로 이미지, 배너, 소셜 미디어 콘텐츠
• **UI/UX 디자인**: 플레이스홀더 이미지, 아이콘, 일러스트레이션
• **프레젠테이션**: 슬라이드 배경, 제품 시각화
• **브랜드 일관성**: 스타일 가이드 기반 이미지 생성
---

## Instructions
▶ S1: Configure MCP Environment
**필수 설정**:
• Model name (gemini-2.5-flash, gemini-3-pro 등)
• API key reference (환경 변수로 저장)
• Output directory
▶ S2: Define the Prompt
구조화된 프롬프트 작성:
▶ S3: Choose the Model
| 모델 | 용도 | 특징 |
|-----|------|------|
| `gemini-3-pro-image` | 고품질 | 복잡한 구성, 디테일 |
| `gemini-2.5-flash-image` | 빠른 반복 | 프로토타이핑, 테스트 |
| `gemini-2.5-pro-image` | 균형 | 품질/속도 밸런스 |
▶ S4: Generate and Review
**리뷰 체크리스트**:
• [ ] 브랜드 적합성
• [ ] 구성 명확성
• [ ] 비율 정확성
• [ ] 텍스트 가독성 (텍스트 포함 시)
▶ S5: Deliverables
최종 산출물:
• 최종 이미지 파일
• 프롬프트 메타데이터 기록
• 모델, 비율, 사용 노트
---

## Best practices
1. Specify ratio early
2. Use style anchors
3. Iterate with constraints
4. Track prompts
5. Batch similar requests
