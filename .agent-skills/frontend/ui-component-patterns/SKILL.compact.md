# ui-component-patterns

> Build reusable, maintainable UI components following modern design patterns. Use when creating component libraries, implementing design systems, or...

## When to use this skill
• **컴포넌트 라이브러리 구축**: 재사용 가능한 UI 컴포넌트 제작
• **디자인 시스템 구현**: 일관된 UI 패턴 적용
• **복잡한 UI**: 여러 변형이 필요한 컴포넌트 (Button, Modal, Dropdown)
• **리팩토링**: 중복 코드를 컴포넌트로 추출

## Instructions
▶ S1: Props API 설계
사용하기 쉽고 확장 가능한 Props를 설계합니다.
**원칙**:
• 명확한 이름
• 합리적인 기본값
• TypeScript로 타입 정의
• 선택적 Props는 optional (?)
**예시** (Button):
▶ S2: Composition Pattern (합성 패턴)
작은 컴포넌트를 조합하여 복잡한 UI를 만듭니다.
**예시** (Card):
▶ S3: Render Props / Children as Function
유연한 커스터마이징을 위한 패턴입니다.
**예시** (Dropdown):
▶ S4: Custom Hooks로 로직 분리
UI와 비즈니스 로직을 분리합니다.
**예시** (Modal):
▶ S5: 성능 최적화
불필요한 리렌더링을 방지합니다.
**React.memo**:
**useMemo & useCallback**:

## Best practices
1. Composition over Props
2. Controlled vs Uncontrolled
3. Default Props
4. Storybook
