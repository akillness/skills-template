---
name: ai-paper-writing
description: Create professional academic AI research papers with proper structure, methodology, experiments, and evaluation. Covers paper sections, AI writing standards, reproducibility checklists, and academic metrics.
tags: [ai, academic-writing, research-paper, iclr, neurips, ijcai, machine-learning, deep-learning]
platforms: [Claude, ChatGPT, Gemini]
allowed-tools: [read, grep, write, shell]
---

# AI 및 공학 논문 완벽 작성 가이드

## 목적 (Purpose)

AI 및 머신러닝(ML) 논문은 새로운 알고리즘, 신경망 아키텍처(Deep Learning), 또는 기존 기법의 혁신적 적용을 제시하는 학술 논문입니다. 성공적인 AI 논문은 **명확성, 재현성, 엄밀한 실�**을 기본으로 합니다. 본 가이드는 ICLR, NeurIPS, IJCAI 등 주요 AI 학회의 요구사항을 바탕으로 작성되었습니다[1][2][3]

## 사용 시점 (When to Use)

- **연구 논문(Research Paper)** 작성할 때
- **보고서(Report)** 작성할 때
- **석사 학위 논문(Thesis)** 작성할 때
- **기술 매뉴얼(Workshop Paper)** 작성할 때
- **논문 초안 작성**할 때
- **참고 문헌(Bibliography)** 관리가 필요할 때
- **AI 및 머신러닝 응용 논문** 작성할 때

## 사전 요구사항 (Prerequisites)

### 필수 조건
- **영어 쓰기 능력**: 학술 영어(특히 기술 용어) 구사 능력
- **통계적 이해**: 머신러닝, 딥러닝, 컴퓨터 사이언스 이해
- **논문 읽기 경험**: 해당 분야의 선행 논문 30-50편 이상 정독
- **실험 설계 능력**: 과학적 타당성, 통계적 검증 능력
- **작성 능력**: 명료하고 간결한 글쓰기 능력

### 도구 추천

#### 편집기 (Editing)
- **VS Code**: LaTeX Workshop 확장
- **Overleaf**: 웹 기반 LaTeX 에디터 (https://www.overleaf.com)
- **TeXstudio**: 로컬 LaTeX 개발 환경

#### PDF 뷰어 (PDF Viewer)
- **Adobe Acrobat Reader**: PDF 확인 및 주석
- **Preview.app** (macOS): macOS PDF 뷰어
- **Sumatra PDF**: (Windows) 가볍고 빠른 PDF 뷰어

#### 수식 확인 (Math Validation)
- **Detexify** (http://detexify.kirelabs.org/): 수식 오류 확인
- **arXiv sanity check**: arXiv 제출 전 필수 체크

## 작업 절차 (Procedure)

상세 예제는 [EXAMPLES.md](./EXAMPLES.md)를 참조하세요.

### 1단계: 논문 유형 및 대상 파악

사용자 요청을 분석하여:

**작성 내용**: 
- 새로운 알고리즘 제안?
- 기존 방법의 혁신적 적용?
- 문헌 조사(Survey) 또는 실험 연구?
- 이론적 연구(theroetical work)인가?

**사용자에게 질문** (명확하지 않을 때):
```
1. 논문의 주요 목적은 무엇인가요?
   - [ ] 새로운 알고리즘/아키텍처 제안
   - [ ] 기존 방법의 개선/혁신적 적용
   - [ ] 문헌 조사/서베이(Survey paper)
   - [ ] 실험 연구(experiment paper)
   - [ ] 이론적 연구(theroetical)
   - [ ] 기타 (설명): ______

2. 어떤 회의/콘퍼런스에 제출할 예정인가요?
   - [ ] ICLR (Machine Learning)
   - [ ] NeurIPS (Neural Information Processing Systems)
   - [ ] IJCAI (International Joint Conference on AI)
   - [ ] ICML (International Conference on Machine Learning)
   - [ ] ECCV (European Conference on Computer Vision)
   - [ ] AAAI (Association for the Advancement of AI)
   - [ ] CVPR (Computer Vision and Pattern Recognition)
   - [ ] 기타 (설명): ______

3. 실험 재현성이 중요한가요?
   - [ ] 네 (공개 코드/데이터셋 필수)
   - [ ] 아니오 (요약만 제공해도됨)
   - [ ] 부분적 (핵심 코드만 공개)

4. 논문의 예상 분량은 어느 정도인가요?
   - [ ] 포스터/단쪽 (1-3페이지, 짧은 발표)
   - ] [ ] 전체 논문 (8-15페이지, 완전한 보고서)
   - ] [ ] 워크샵(2시간 발표, 6-8페이지)
   - ] [ ] 기타 (설명): ______

5. 주요 기여도/제약사항은 있나요?
   - [ ] 페이지 제한
   - [ ] 파일 형식 요구사항 (예: LaTeX, 2단)
   - ] ] 코드/실험 결과 포함 필수
   - ] ] 기타 (설명): ______
```

**구성 요소 파악**:
- 명확한 표준(Standard: 8-12페이지, Workshop: 4-6페이지)
- 필수 섹션 (Title, Abstract, Introduction, Method, Experiments, Results, Discussion, Conclusion, References)
- 선택적 섹션 (Appendix, Acknowledgments)
- 그림/표 최대 개수 제한

### 2단계: 관련 연구(Related Work) 조사

문헌 조사를 체계적으로 수행합니다.

**작업 내용**:
- Google Scholar, arXiv, Semantic Scholar에서 최신 논문 검색
- 관련 연구의 기여도 분석 및 평가
- 우리의 방법과의 차별점 명확히 파악
- 비판적 관점(연구의 한계, 부족한 점) 식별

**관련 연구 포함 내용**:
```
연구 1: [저자, 논문 제목, 회의, 출판 연도]
   - 기여도: 왜 중요한 연구인가?
   - 우리의 방법과의 차이점: ______

연구 2: [저자, 논문 제목, 회의, 출판 연도]
   - 기여도: 어떤 점을 제공하는가?

...
```

### 3단계: 논문 구조 설계

표준 학술 논문 구조를 계획합니다.

**구조 요약**:
```
총 페이지수: [최종 페이지]

1. 타이틀 페이지
   - 제목
   - 저자 정보
   - 연구 주제

2. Abstract (150-250단어)
   - 문제 정의
   - 기존 방법과의 한계
   - 우리의 방법 요약
   - 정량적 결과 (78.3% 정확도)

3. Introduction (1-2페이지)
   - 배경 및 동기
   - 문헌 조사 결과 요약
   - 연구의 필요성
   - 논문의 주요 기여도

4. Methodology (3-5페이지)
   - 제안하는 방법 명확히 설명
   - 알고리즘/모델 아키텍처
   - 손실 함수 정의
   - 평가 메트릭

5. Experiments (3-6페이지)
   - 실험 설계 (datasets, baselines, hyperparameters)
   - 구현 세부사항
   - 결과 분석 방법론

6. Results (2-4페이지)
   - 표로 결과 정리
   - 그래프 및 도표 포함
   - 주요 발견사항

7. Discussion (1-2페이지)
   - 결과 해석 및 의미
   - 한계점 및 부족한 점
- 추가 방향 제안

8. Conclusion (1페이지)
   - 전체 요약
   - 기여도 및 영향
- 향후 연구 제안

9. References (1-2페이지)
   - 인용 논문 목록
   - 일관된 서식 (예: IEEE, ACM)

10. (선택사항) Appendix / Acknowledgments
```

### 4단계: Abstract 작성 (초록)

**목적**: 문제 정의 및 해결책을 간결히 요약

**구성 요소**:
1. **문제 정의**: 무엇 해결하려는가?
2. **기존 방법**: 어떤 한계가 있나?
3. **우리의 방법**: 요약 (1-2문장)
4. **정량적 결과**: "78.3% 정확도" 같은 구체적 수치
5. **예상 기여도**: "코드는 XX에 공개" 같은 실질적 기여

**작성 팁**:
```
• 1단계: 전체 내용 요약 (3-4문장)
• 2단계: 수식 없이 가능하면 간단한 문장으로 표현
• 3단계: 일반 독자가 이해하도록 작성 (전문 용어 어피해)
• 4단계: 주요 키워드 굵게 표시 (예: "attention mechanism", "CNN-based")
```

### 5단계: Introduction 작성 (서론)

**목적**: 연구의 필요성과 동기를 설명

**구성 요소**:
- 배경(Background): 분야의 최신 동향
- 동기(Motivation): 왜 이 연구가 필요한가?
- 기여도(Contribution): 어떻게 다른 연구와 다른가?

**작성 팁**:
```
• 첫 문단은 "우리는... (We...)" 형식
• 문헌 인용은 "[Author et al.]" 형식 사용
• 점한 목록 사용 (bullet points)
• 논문 흐름을 자연스럽게 만들기 위해 transition 문장 활용
```

### 6단계: Related Work 작성

**목적**: 기존 연구와 우리의 방법을 비교

**작성 팁**:
```
• 연구별로 그룹화 (비슷한 방법들 묶기)
• 각 연구에 대해 최소 3가지 비교 지점 포함
• 우리의 방법이 어떻게 더 나은지 명확히 설명
• 관련 연구를 표(Table 1, Table 2)로 정리
```

### 7단계: Methodology 작성 (방법론)

**목적**: 제안하는 방법을 명확하고 기술적으로 설명

**구성 요소**:
- 알고리즘/모델 아키텍처 (diagrams, pseudo-code)
- 수식(Mathematical notation): 명확한 표기법
- 실험 설계 (데이터셋, baselines, hyperparameters)
- 평가 메트릭 (metrics, 통계적 유의성 검정)

**작성 팁**:
```
• 알고리즘/모델 구조도는 포함 (LaTeX tikz 또는 수동으로)
• 수식은 [inline: $E = mc^2$] 또는 [display: \[E = mc^2\] 형식
• 실험 절차를 번호로 구분 (3.1, 3.2, 3.3...)
• Table/그림은 반드시 캡션(Caption)과 레벨(label) 포함
```

### 8단계: Experiments 섹션 작성

**목적**: 실험 결과를 명확하고 체계적으로 보고

**구성 요소**:
- 실험 설정: 데이터셋, baselines, hyperparameters
- 결과 분석: 정량적 비교, 통계적 유의성 검정
- 그래프/도표: matplotlib/plotly 혹은 LaTeX pgfplots

**작성 팁**:
```
• 최소 3가지 baseline과 비교 (Table 2)
• 표준 오차(mean ± std) 또는 confidence interval 포함
• 통계적 유의성 검정: t-test, ANOVA 등
• 그래프는 "Figure X: Accuracy vs Baseline" 형식으로 캡션
• 주요 하이라이트 강조로 표시 (**Table X**, **Figure 1**)
```

### 9단계: Results 및 Discussion 작성

**목적**: 결과를 해석하고 논문 전체를 마무리

**작성 팁**:
```
• Results 섹션은 객관적인 결과만
• Discussion 섹션에서 주요 발견사항과 한계점을 논의
• Conclusion에서 향후 연구 방향을 제안
• 명확하지 않은 가설은 하지 않기
```

### 10단계: References 작성 (참고 문헌)

**목적**: 인용 논문을 관리하고 형식을 맞춤

**구성 요소**:
- BibTeX 파일 사용 (.bib 확장자)
- 인용 형식 일관성 (예: IEEE, ACM)
- 최소 10-15개 인용 포함

**작성 팁**:
```
• Google Scholar "Cite" 기능으로 BibTeX 형식으로 직접 내보내기
• 인용은 논문의 순서대로 정렬
• 저자 이름은 "First Name Last Name" 형식 (예: "Lee et al.")
• 회의명은 논문 제목이 아닌 경우 생략
```

### 11단계: AI 활용 가이드

**작성 내용**:
- AI를 활용한 논문 작성 예시 제공
- 도구 추천 (Overleaf, arXiv sanity checker)
- 일반적인 팁 및 주의사항

**작성 팁**:
```
• 논문 작성 전에 AI를 사용하여 초안/구조 생성
• AI로 내용 검토 및 문법 교정
• 주요 기여도/제약사항은 AI에게 묻지 말고 직접 작성
• 재현성 체크리스트를 사용하여 실험 절차 검토
```

## 출력 포맷 (Output Format)

### 성공 시

```markdown
## ✅ AI 논문 완벽 작성 가이드 생성 완료

### 생성된 구조
- 문서 클래스: article, report, book, beamer 포함
- 템플릿 시스템: default, post, conference 완성
- 참고 문헌 관리: BibTeX 기반

### 사용 가능한 기능
- 학술 논문 구조 (8개 주요 섹션)
- 수학식 작성 가이드 (inline, display, matrix)
- 표/그림 포함 형식
- 실험 결과 분석 방법론
- AI 작성 예시 및 가이드

### AI 작성 지원
- 제목/초록/결론/토론 초안 생성
- 내용 검토 및 교정
- 수식 검증
- 참고 문헌 관리 자동화 제안

### 사용 방법
```bash
# AI 논문 작성
claude "학술 논문 초안을 작성해줘: [주제]"

# 실험 결과 분석
claude "이 실험 결과를 분석해서 표와 그래프를 만들어줘"

# 관련 연구 조사
claude "최신 CNN 기반 논문 10편을 찾아서 조사해줘"
```

### 다음 단계

1. **첫 초안 작성**: 논문 구조를 기반으로 각 섹션 작성
2. **내용 검토**: AI를 활용하여 논리적 흐름과 일관성 확인
3. **실험 설계**: baseline 선정 및 실험 계획 수립
4. **참고 문헌**: 관련 연구 최소 10개 수집
5. **재현성 검증**: 코드/데이터셋, 실험 결과 확인
```

### 오류 발생 시

```markdown
## ❌ AI 논문 작성 실패

### 원인
- [구체적인 원인 설명]

### 해결 방법
```bash
# 제안된 해결 방법
```

### 추가 도움
- [AI 논문 작성 가이드](https://turing.com/kb/how-to-write-research-paper-in-machine-learning-area/)
- [arXiv 문서 작성 가이드](https://arxiv.org/help/submit)
- [NeurIPS 제출 가이드](https://neurips.cc/author/instructions/)
```

## 제약사항 (Constraints)

### 필수 준수 사항

1. **명확성**: 각 섹션은 명확한 목적과 내용을 가져야 함
2. **일관성**: 전체 논문의 스타일과 형식 유지
3. **학술적 엄격함**: 수학식은 올바른 문법 사용, 엄밀한 정의
4. **인용 형식**: 선언된 형식(예: IEEE, ACM) 준수
5. **코드 재현성**: 실험 결과를 재현할 수 있는 코드/데이터 공개
6. **페이지 제한**: 회의 요구사항에 맞는 페이지 수 준수

### 보안 규칙

1. **연구 윤리**: 타인저 저자는 모두 포함, 편견되지 않음
2. **자기 인용**: 본인의 저자 인용 방지
3. **과장된 결과 제시**: 주요 결과는 과장되지 않음
4. **AI 비평 방지**: AI를 보조 도구로만 활용, 주도권 유지
5. **데이터 프라이버시**: 민감한 정보 포함 금지

### 코딩 표준

1. **들여쓰기**: LaTeX 코드에서는 4칸 들여쓰기 필수
2. **수식 표기**: `\(x\)`와 `$x$` 구분 사용
3. **함수명**: 카멜케이스로 작성 (예: `calculate_loss` 아닌 `CalculateLoss`)
4. **주석**: 코드 어려운 부분에 `# FIXME`, `# TODO` 추가

## 참고 자료 (References)

### 공식 가이드
- [ICLR Author Guidelines](https://iclr.cc/2022/conferences/authorguide)
- [NeurIPS Author Guidelines](https://neurips.cc/author-guide)
- [IJCAI Formatting Guidelines](https://ijcai.org/author-guidelines)
- [ECCV Author Guidelines](https://eccv2022.eccv.org/author-guidelines)
- [ML Workshop Paper Template](https://ml-workshop.org/papers/paper_template/)

### 학습 가이드
- [How to Write a Deep Learning Paper](https://turing.com/kb/how-to-write-research-paper-in-machine-learning-area/)
- [A Beginner's Guide to Writing Academic Papers](https://www-users.york.ac.uk/~pjh503/latex/first_latex.html)
- [LaTeX Document Structure](https://en.wikibooks.org/wiki/LaTeX/Document_Structure)

### 도구 및 템플릿
- [Overleaf](https://www.overleaf.com) - 웹 기반 LaTeX 에디터
- [arXiv](https://arxiv.org/) - 논문 저장소 및 검색
- [Google Scholar](https://scholar.google.com/) - 문헌 검색
- [Semantic Scholar](https://www.semanticscholar.org/) - 문헌 검색

## 예시 사용 사례 (Examples)

### 예시 1: Image Classification 논문

**사용자 요청**: "CNN 기반 이미지 분류 논문을 작성해줘"

**실행 절차**:
1. 관련 연구 10편 수집 및 분석
2. 논문 구조 설계 (Title, Abstract, Intro, Method, Experiments, Results, Discussion, Conclusion)
3. Abstract 초안 작성: "CNN 기반 이미지 분류는... 정확도 78.3% 달성"
4. Methodology 섹션: ResNet-50 baseline 비교, 우리 방법 설명
5. Experiments 섹션: CIFAR-10, ImageNet-1K, 실험 세부사항
6. Results 섹션: Table로 성능 비교, 그래프 생성
7. 참고 문헌: 15개 인용 수집
8. 전체 논문 10쪄 작성

### 예시 2: Transformer 논문

**사용자 요청**: "Vision Transformer 논문을 작성해줘"

**실행 절차**:
1. 최신 논문 5편 수집
2. Attention mechanism 수식 포함 (Self-attention, Multi-head attention)
3. 실험 설계: 3개 baselines (ViT, DeiT, Swin Transformer)
4. Results: Figure로 ablation study 포함
5. Discussion: computational cost vs performance trade-off 분석

### 예시 3: Survey 논문

**사용자 요청**: "서베이(Survey) 논문 작성해줘"

**실행 절차**:
1. 연구 주제별로 그룹화 (예: CNN-based, Transformer-based)
2. 각 연구의 기여도/한계점 명확히 정리
3. Table로 비교: Accuracy, FLOPs, Computational Cost
4. Discussion: 향후 방향 제안

## 성공 기준 (Success Criteria)

### 필수 조건
- [ ] 논문 구조 완료 (Title, Abstract, Intro, Method, Experiments, Results, Discussion, Conclusion, References)
- [ ] 최소 10개 인용 포함
- [ ] 수학식 예시 포함
- [ ] 실험 설계 가이드 포함
- [ ] 재현성 체크리스트 포함

### 권장 조건
- [ ] 관련 연구 최소 10편 분석 완료
- [ ] 각 섹션이 적어도로 작성됨
- [ ] 수식이 명확한 문법으로 작성됨
- [ ] 인용 형식이 일관성 유지됨

## 문제 해결 (Troubleshooting)

### 일반적인 문제

#### 문제 1: 논문 구조가 명확하지 않음

**증상**: 각 섹션의 목적과 내용이 불분명

**해결**:
```
1. 각 섹션의 첫 문단에 1-2문장으로 섹션 목적 명시
2. 연결 문장(transition)을 사용하여 자연스러운 흐름
```

#### 문제 2: 수식이 컴파일되지 않음

**증상**: `x^2`가 일반 텍스트로 출력됨

**해결**:
```
\documentclass{article}
\usepackage{amsmath}

% 일반 텍스트에서도 수식이 보이도록 수학 모드 사용
\begin{document}
이차방정식은 \(x^2\)입니다.
\end{document}
```

#### 문제 3: 표 형식 오류

**증상**: LaTeX 컴파일 중에 `Missing } inserted` 에러

**해결**:
```
1. 열과 닫힌짝 쌍 `{}` 쌍 검사
2. 라인 끝에 `\\` 있는지 확인
3. 테이블 형식의 column spec 확인 (예: {c|c|c}는 3열)
```

### 고급 문제 해결

#### 문제: arXiv 제출 거부

**증상**: PDF 버전이 맞지 않거나 포맷 오류

**해결**:
```
1. arXiv 스타일(`\usepackage[hyperref]{a4paper}`) 사용 시 `\hypersetup`
2. PDFXLaTeX 대신 `xelatex` 또는 `lualatex` 사용
3. arXiv의 검증 도구(https://arxiv.org/validate/) 사용하여 사전 검증
4. 커맨드 라인 `\hypersetup{author={...},title={...}}` 정확히 작성
```

## 버전 기록 (Version History)

| 날짜 | 버전 | 변경 내용 |
|------|------|---------|
| 2026-01-08 | 1.0.0 | 초기 스킬 생성 - AI 및 공학 논문 완벽 작성 가이드 |

---

**Platform**: Claude, ChatGPT, Gemini
**Skill Type**: Documentation
**Complexity**: Advanced
**Estimated Time**: 60-120분 (초안 작성) / 2-4시간 (초안 검토 및 연구 조사) / 1-3시간 (논문 작성)
