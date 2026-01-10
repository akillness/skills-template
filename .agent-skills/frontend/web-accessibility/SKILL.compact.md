# web-accessibility

> Implement web accessibility (a11y) standards following WCAG 2.1 guidelines. Use when building accessible UIs, fixing accessibility issues, or ensur...

## When to use this skill
• **새 UI 컴포넌트 개발**: 접근 가능한 컴포넌트 설계
• **접근성 감사**: 기존 사이트의 접근성 문제 식별 및 수정
• **폼 구현**: 스크린 리더 친화적인 폼 작성
• **모달/드롭다운**: 포커스 관리 및 키보드 트랩 방지
• **WCAG 준수**: 법적 요구사항 또는 표준 준수

## Instructions
▶ S1: Semantic HTML 사용
의미있는 HTML 요소를 사용하여 구조를 명확히 합니다.
**작업 내용**:
• `<button>`, `<nav>`, `<main>`, `<header>`, `<footer>` 등 시맨틱 태그 사용
• `<div>`, `<span>` 남용 지양
• 제목 계층 구조 (`<h1>` ~ `<h6>`) 올바르게 사용
• `<label>`과 `<input>` 연결
**예시** (❌ 나쁜 예 vs ✅ 좋은 예):
**폼 예시**:
▶ S2: 키보드 네비게이션 구현
마우스 없이도 모든 기능 사용 가능하도록 합니다.
**작업 내용**:
• Tab, Shift+Tab으로 포커스 이동
• Enter/Space로 버튼 활성화
• 화살표 키로 리스트/메뉴 탐색
• ESC로 모달/드롭다운 닫기
• `tabindex` 적절히 사용
**판단 기준**:
• 인터랙티브 요소 → `tabindex="0"` (포커스 가능)
• 포커스 제외 → `tabindex="-1"` (프로그래밍 방식 포커스만)
• 포커스 순서 변경 금지 → `tabindex="1+"` 사용 지양
**예시** (React 드롭다운):
▶ S3: ARIA 속성 추가
스크린 리더에게 추가 컨텍스트를 제공합니다.
**작업 내용**:
• `aria-label`: 요소의 이름 정의
• `aria-labelledby`: 다른 요소를 라벨로 참조
• `aria-describedby`: 추가 설명 제공
• `aria-live`: 동적 콘텐츠 변경 알림
• `aria-hidden`: 스크린 리더에서 숨기기
**확인 사항**:
• [x] 모든 인터랙티브 요소에 명확한 라벨
• [x] 버튼 목적이 명확 (예: "Submit form" not "Click")
• [x] 상태 변화 알림 (aria-live)
• [x] 장식용 이미지는 alt="" 또는 aria-hidden="true"
**예시** (모달):
**aria-live 예시** (알림):
▶ S4: 색상 대비 및 시각적 접근성
시각 장애인을 위한 충분한 대비율을 보장합니다.
**작업 내용**:
• WCAG AA: 텍스트 4.5:1, 큰 텍스트 3:1
• WCAG AAA: 텍스트 7:1, 큰 텍스트 4.5:1
• 색상만으로 정보 전달 금지 (아이콘, 패턴 병행)
• 포커스 표시 명확히 (outline)
**예시** (CSS):
▶ S5: 접근성 테스트
자동 및 수동 테스트로 접근성을 검증합니다.
**작업 내용**:
• axe DevTools로 자동 스캔
• Lighthouse Accessibility 점수 확인
• 키보드만으로 전체 기능 테스트
• 스크린 리더 테스트 (NVDA, VoiceOver)
**예시** (Jest + axe-core):

## Best practices
1. 시맨틱 HTML 우선
2. 포커스 관리
3. 에러 메시지
