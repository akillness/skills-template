---
name: latex-writing
description: Create professional academic and technical documents using LaTeX typesetting system. Covers document structure, mathematical notation, tables, figures, citations, bibliography management, and best practices. Essential for research papers, theses, academic reports, and scientific documentation.
tags: [latex, academic-writing, mathematics, documentation, typesetting]
platforms: [Claude, ChatGPT, Gemini]
allowed-tools: [read, grep, write, shell]
---

# LaTeX Writing

## 목적 (Purpose)

LaTeX는 전문적인 학술 및 기술 문서를 작성하기 위한 강력한 조판(Typesetting) 시스템입니다. Microsoft Word 같은 WYSIWYG 에디터와 달리, LaTeX는 텍스트 파일에 명령어를 삽입하여 TeX 엔진이 최종 PDF로 변환합니다. 특히 복잡한 수학식, 과학 논문, 학위 논문, 책 등의 작성에 탁월합니다.

## 사용 시점 (When to Use)

- **학술 논문 작성**할 때
- **연구 논문(Research Paper)** 작성할 때
- **보고서(Report)** 작성할 때
- **석사 학위 논문(Thesis)** 작성할 때
- **기술 매뉴얼(Manual)** 작성할 때
- **수학식이 포함된 문서**를 작성할 때
- **참고 문헌(Bibliography)** 관리가 필요할 때

## 사전 요구사항 (Prerequisites)

### 필수 조건
- **TeX 배포판 설치**:
  - Windows: MiKTeX, TeX Live
  - macOS: MacTeX
  - Linux: TeX Live
- **LaTeX 컴파일러**: `pdflatex`, `xelatex`, `lualatex`
- **BibTeX**: 참고 문헌 관리 (`bibtex`, `biber`)

### 도구 추천
- **편집기**: VS Code (LaTeX Workshop 확장), Overleaf (웹 기반)
- **PDF 뷰어**: Adobe Acrobat Reader, Preview.app
- **수식 확인**: Detexify (http://detexify.kirelabs.org/)

## 작업 절차 (Procedure)

상세 예제는 [EXAMPLES.md](./EXAMPLES.md)를 참조하세요.

### 1단계: 문서 유형 파악

사용자 요청을 분석하여:
- **새로운 문서**인지, 기존 문서 작성인지
- **논문**, **보고서**, **보고서(Thesis)**, **기술 매뉴얼** 중 어느 유형인지
- **학문적**인지, **기술 문서**인지 파악
- **목적 및 대상** 명확히 확인

**사용자에게 질문** (명확하지 않을 때):
```
1. 문서 유형은 무엇인가요?
   - [ ] 연구 논문 (Research Paper)
   - [ ] 석사 학위 논문 (Thesis)
   - [ ] 보고서 (Report)
   - [ ] 기술 매뉴얼 (Manual)
   - [ ] 책 (Book)
   - [ ] 기타 (설명): ______

2. 문서의 주요 목적은 무엇인가요?
   - [ ] 학술 발표
   - [ ] 기술 문서화
   - [ ] 과제 제출
   - [ ] 튜토리얼 작성
   - [ ] 기타 (설명): ______

3. 주요 요구사항이 있나요?
   - [ ] 구체적인 문서 클래스 (article, report, book, beamer)
   - [ ] 특정 스타일 템플릿
   - [ ] 참고 문헌 형식 (APA, IEEE, ACM)
   - [ ] 페이지 제한 (페이지 수, 레이아웃)
   - [ ] 기타 (설명): ______

4. 작성할 내용의 범위는?
   - [ ] 연구 논문 (서론, 본론, 결론)
   - [ ] 수학적 증명
   - [ ] 실험 결과
   - [ ] 알고리즘 설명
   - [ ] 기타 (설명): ______
```

### 2단계: 문서 클래스 및 템플릿 선택

적절한 문서 클래스를 선택하고 설정합니다.

#### 문서 클래스 비교

| 클래스 | 용도 | 장점 |
|--------|------|------|
| **article** | 논문, 보고서, 짧은 문서 | 간단, 널리 사용됨 |
| **report** | 여러 장을 포함하는 긴 보고서 | 장 번호 자동 생성 |
| **book** | 책 형식 문서 | 장, 부, 절 구조 |
| **beamer** | 프레젠테이션 슬라이드 | 발표 자동화 |

#### 기본 문서 구조

```latex
\documentclass{article}           % 문서 클래스 선언

% ===== 프리앰블 (Preamble) =====
\usepackage{amsmath}              % 패키지 로드
\title{문서 제목}
\author{저자명}
\date{\today}

% ===== 문서 본문 =====
\begin{document}

\maketitle                        % 제목 페이지 생성

\section{첫 번째 섹션}
문서 내용...

\end{document}
```

#### 프리앰블 (Preamble) 구성

`\begin{document}` 이전의 모든 내용을 포함합니다:

- 문서 클래스 정의
- 패키지 로드 (`\usepackage`)
- 메타데이터 설정 (제목, 저자, 날짜)
- 커스텀 명령어 정의

### 3단계: 수학식 작성

텍스트 중간에 수학식을 삽입합니다.

#### 인라인 수식

```latex
이차방정식 $ax^2 + bx + c = 0$의 해는...
또는
이차방정식 \(ax^2 + bx + c = 0\)의 해는...
```

#### 디스플레이 수식

한 줄에 별도로 표시되는 수식:

```latex
\[ E = mc^2 \]

또는

\begin{equation}
E = mc^2
\end{equation}

또는 (번호 없음)

\begin{equation*}
E = mc^2
\end{equation*}
```

#### 기본 수학 명령어

```latex
$a^2$                       % 제곱 (위첨자)
$x_1$                       % 아래첨자
$\frac{1}{2}$              % 분수
$\sqrt{2}$                 % 제곱근
$\int_0^1 f(x) dx$         % 적분
$\sum_{i=1}^n a_i$         % 합

\alpha, \beta, \gamma      % 그리스 문자
\le, \ge, \neq             % 관계 기호
\times, \cdot, \div        % 연산 기호
```

#### 정렬된 여러 수식

```latex
\usepackage{amsmath}

\begin{align*}
2x + 3y &= 10 \\
x - y &= 2
\end{align*}
```

여기서 `&`는 정렬점입니다 (보통 `=` 기호 앞).

#### 경우의 수 (Cases)

```latex
\[ f(x) = \begin{cases}
x & \text{if } x \geq 0 \\
-x & \text{if } x < 0
\end{cases} \]
```

### 4단계: 문서 구조 및 섹션

섹션 명령어로 논리적 구조를 만듭니다.

#### 섹션 명령어

```latex
\part{부}                    % 최상위 (책만)
\chapter{장}                 % 장 (책, 리포트만)
\section{섹션}               % 섹션
\subsection{부섹션}          % 부섹션
\subsubsection{부부섹션}     % 부부섹션
\paragraph{단락}             % 단락 제목
```

#### 번호 제거

섹션 뒤에 `*`를 추가하면 번호가 붙지 않습니다:

```latex
\section*{번호 없는 섹션}
\chapter*{번호 없는 장}
```

#### 목차 생성

```latex
\tableofcontents              % 목차 생성
\listoffigures                % 그림 목록
\listoftables                 % 표 목록
```

**주의**: 목차가 올바르게 생성되려면 **두 번 컴파일**해야 합니다.

#### 제목 정보

```latex
\title{문서 제목}
\author{저자명}
\date{\today}                 % 또는 \date{2024년 1월 15일}

\begin{document}
\maketitle                    % 제목 페이지 생성
\end{document}
```

#### 초록 (Abstract)

```latex
\begin{abstract}
이 문서의 초록입니다.
주요 내용을 간단히 요약합니다.
\end{abstract}
```

### 5단계: 단락 및 줄바꿈

LaTeX에서 단락은 **한 줄 이상의 공백**으로 구분됩니다.

#### 단락 생성

```latex
첫 번째 단락입니다.
계속 첫 번째 단락...

두 번째 단락입니다.
```

#### 줄바꿈

```latex
첫 번째 줄\\                % 또는 \newline
두 번째 줄
```

### 6단계: 리스트 (Lists)

#### 순서 없는 리스트

```latex
\begin{itemize}
  \item 첫 번째 항목
  \item 두 번째 항목
  \item 세 번째 항목
\end{itemize}
```

#### 순서 있는 리스트

```latex
\begin{enumerate}
  \item 첫 번째
  \item 두 번째
  \item 세 번째
\end{enumerate}
```

#### 중첩된 리스트

```latex
\begin{enumerate}
  \item 첫 번째 항목
  \begin{itemize}
    \item 부-항목 A
    \item 부-항목 B
  \end{itemize}
  \item 두 번째 항목
\end{enumerate}
```

### 7단계: 수학 (Mathematics) 심화

#### 행렬 (Matrices)

```latex
\usepackage{amsmath}

% 괄호 행렬
\begin{pmatrix}
  1 & 2 \\
  3 & 4
\end{pmatrix}

% 대괄호 행렬
\begin{bmatrix}
  1 & 2 \\
  3 & 4
\end{bmatrix}

% 수직 막대 행렬
\begin{vmatrix}
  1 & 2 \\
  3 & 4
\end{vmatrix}
```

#### 공백 제어 (Spacing in Math Mode)

```latex
\quad        % 표준 공백 (18 mu)
\qquad       % 두 배 공백 (36 mu)
;            % 미세 공백 (5 mu)
!           % 음수 공백 (-3 mu)
(space)      % 일반 텍스트의 공간
```

### 8단계: 표 (Tables)

#### 기본 표

```latex
\begin{tabular}{ccc}
\hline
아이템 1 & 아이템 2 & 아이템 3 \\
\hline
데이터 1 & 데이터 2 & 데이터 3 \\
데이터 4 & 데이터 5 & 데이터 6 \\
\hline
\end{tabular}
```

#### 표 열 정렬

`{ccc}` 부분에서:
- `l` = 왼쪽 정렬
- `c` = 중앙 정렬
- `r` = 오른쪽 정렬
- `|` = 수직선

```latex
\begin{tabular}{|l|c|r|}
\hline
왼쪽 & 중앙 & 오른쪽 \\
\hline
A & B & C \\
\hline
\end{tabular}
```

#### 표 캡션 및 라벨

```latex
\begin{table}[h]
  \centering
  \begin{tabular}{|c|c|}
    \hline
    헤더 1 & 헤더 2 \\
    \hline
    데이터 1 & 데이터 2 \\
    \hline
  \end{tabular}
  \caption{표 설명}
  \label{tab:example}
\end{table}

표~\ref{tab:example}를 보세요.
```

### 9단계: 이미지 및 그림

#### 이미지 삽입

```latex
\usepackage{graphicx}

\begin{figure}[h]
  \centering
  \includegraphics[width=0.5\textwidth]{image_name}
  \caption{그림 설명}
  \label{fig:example}
\end{figure}

그림~\ref{fig:example}을 참조하세요.
```

#### 이미지 크기 조정

```latex
\includegraphics[width=10cm]{image}         % 너비 지정
\includegraphics[scale=0.5]{image}          % 배율 지정 (50%)
\includegraphics[width=\textwidth]{image}   % 텍스트 너비의 100%
```

### 10단계: 참고 문헌 및 인용 (Bibliography and Citations)

#### BibTeX 파일 생성 (references.bib)

```bibtex
@article{einstein1905,
  author = {Albert Einstein},
  title = {On the Electrodynamics of Moving Bodies},
  journal = {Annalen der Physik},
  year = {1905},
  volume = {17},
  pages = {891-921}
}

@book{knuth1984,
  author = {Donald E. Knuth},
  title = {The TeXbook},
  publisher = {Addison-Wesley},
  year = {1984}
}
```

#### LaTeX 문서에서 참고 문헌 설정

```latex
\documentclass{article}
\usepackage[backend=biber, style=numeric, citestyle=authoryear]{biblatex}
\addbibresource{references.bib}

\begin{document}

Einstein의 연구~\cite{einstein1905}에 따르면...

\printbibliography[title={참고 문헌}]

\end{document}
```

#### 인용 명령어

```latex
\cite{key}                 % [1] 형식의 참조
\textcite{key}             % Einstein (1905)
\parencite{key}            % (Einstein 1905)
```

### 11단계: 특수 문자 및 기호

#### 문자 그대로 출력

```latex
\$         % $ 기호
\%         % % 기호
\_         % _ 기호
&         % & 기호
#         % # 기호
{         % { 기호
}         % } 기호
```

#### 수학 기호

```latex
\leq, \geq         % ≤, ≥
\neq               % ≠
\approx            % ≈
\equiv             % ≡
\pm                % ±
\infty             % ∞
\forall            % ∀
\exists            % ∃
\in, \notin        % ∈, ∉
```

#### 악센트 및 특수 문자

```latex
\'e                % é
`a                 % à
^o                % ô
~n                % ñ
\H{o}              % ő
```

### 12단계: 주요 패키지

#### 필수 패키지

| 패키지 | 용도 |
|--------|------|
| **amsmath** | 고급 수학 환경 |
| **graphicx** | 이미지 삽입 |
| **geometry** | 페이지 레이아웃 |
| **biblatex** | 참고 문헌 관리 |
| **hyperref** | 하이퍼링크 및 북마크 |

#### 패키지 로드

```latex
\usepackage{package_name}
\usepackage[options]{package_name}
```

#### 옵션이 있는 패키지 로드

```latex
\usepackage[utf8]{inputenc}
\usepackage[backend=biber, style=numeric]{biblatex}
```

### 13단계: 행렬 (Matrices)

```latex
\usepackage{amsmath}

% 괄호 행렬
\begin{pmatrix}
  1 & 2 \\
  3 & 4
\end{pmatrix}

% 대괄호 행렬
\begin{bmatrix}
  1 & 2 \\
  3 & 4
\end{bmatrix}

% 수직 막대 행렬
\begin{vmatrix}
  1 & 2 \\
  3 & 4
\end{vmatrix}
```

### 14단계: 완전한 학술 논문 예제

```latex
\documentclass[12pt, a4paper]{article}

\usepackage[utf8]{inputenc}
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage[backend=biber, style=numeric]{biblatex}
\usepackage{geometry}

\geometry{margin=1in}
\addbibresource{references.bib}

\title{LaTeX를 사용한 문서 작성}
\author{홍길동 \\ 대학교}
\date{\today}

\begin{document}

\maketitle

\begin{abstract}
이 논문은 LaTeX 사용 방법을 설명합니다.
서론, 본론, 결론을 포함합니다.
\end{abstract}

\tableofcontents

\section{서론}
LaTeX는 강력한 문서 작성 도구입니다.

\section{수식 작성}
이차방정식의 해는 다음과 같습니다:
\begin{equation}
x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
\end{equation}

\section{결론}
LaTeX는 학술 문서 작성에 최적화되어 있습니다.

\printbibliography

\end{document}
```

### 15단계: 온라인 도구 활용

#### Overleaf

- **웹 기반 LaTeX 에디터**: 설치 불필요
- **주소**: https://www.overleaf.com
- **장점**: 협업, 템플릿, 실시간 컴파일

#### 로컬 설치

- **Windows**: MiKTeX, TeX Live
- **macOS**: MacTeX
- **Linux**: TeX Live

완벽한 LaTeX 가이드 문서를 다운로드 링크로 제공합니다. 이 문서는 LaTeX의 모든 기본 문법과 실무 예제를 포함하고 있으며, 처음부터 전문 수준까지 학습할 수 있도록 구성되어 있습니다.

출처:
- Getting Started In LaTeX - IT Help Desk https://www.rice.edu/it/help/LaTeX/intro.html
- Learn LaTeX in 30 minutes https://www.overleaf.com/learn/LaTeX/Learn_LaTeX_in_30_minutes
- A Beginner's Guide to LaTeX - Document Structure https://www-users.york.ac.uk/~pjh503/LaTeX/first_latex.html
- LaTeX Document Structure https://admin.kuleuven.be/icts/english/research/dissemation/latex/latex-doc-structure
- The document environment https://en.wikibooks.org/wiki/LaTeX/Document_Structure
- [PDF] LATEX for Beginners - University of Colorado Boulder https://www.colorado.edu/aps/sites/default/files/attached-files/latex_primer.pdf