# state-management

> Implement state management patterns for frontend applications. Use when managing global state, handling complex data flows, or coordinating state a...

## When to use this skill
• **전역 상태 필요**: 여러 컴포넌트가 같은 데이터 공유
• **Props Drilling 문제**: 5단계 이상 props 전달
• **복잡한 상태 로직**: 인증, 장바구니, 테마 등
• **상태 동기화**: 서버 데이터와 클라이언트 상태 동기화

## Instructions
▶ S1: 상태 범위 결정
로컬 vs 전역 상태를 구분합니다.
**판단 기준**:
• **로컬 상태**: 단일 컴포넌트에서만 사용
• 폼 입력값, 토글 상태, 드롭다운 열림/닫힘
• `useState`, `useReducer` 사용
• **전역 상태**: 여러 컴포넌트에서 공유
• 사용자 인증, 장바구니, 테마, 언어 설정
• Context API, Redux, Zustand 사용
**예시**:
▶ S2: React Context API (간단한 전역 상태)
가벼운 전역 상태 관리에 적합합니다.
**예시** (인증 Context):
**사용**:
▶ S3: Zustand (현대적이고 간결한 상태 관리)
Redux보다 간단하고 보일러플레이트가 적습니다.
**설치**:
**예시** (장바구니):
**사용**:
▶ S4: Redux Toolkit (대규모 앱)
복잡한 상태 로직과 미들웨어가 필요한 경우 사용합니다.
**설치**:
**예시** (Todo):
**사용**:
▶ S5: 서버 상태 관리 (React Query / TanStack Query)
API 데이터 fetching 및 캐싱에 특화되어 있습니다.

## Best practices
1. 선택적 구독
2. 액션 이름 명확히
3. TypeScript 사용
