# cs-tool-dashboard

> Supercent CS Tool 대시보드 개발 - FAQ 시스템, 티켓 관리, Firebase 기반 인프라

## Instructions
▶ When developing FAQ page:
1. gameId로 FAQ 필터링 구현
2. 검색은 keywords 배열 + question 필드 대상
3. 카테고리 탭은 동적으로 Firestore에서 로드
4. 모바일 우선 반응형 디자인
▶ When developing Contact form:
1. react-hook-form + zod로 유효성 검증
2. 카테고리 선택시 하위 카테고리 동적 렌더링
3. 파일 업로드는 Firebase Storage, 5MB 제한
4. 제출 시 Cloud Function 호출 → Firestore 저장
▶ When developing Admin dashboard:
1. Firebase Auth로 관리자 인증 (role: 'admin')
2. onSnapshot으로 실시간 티켓 리스트 동기화
3. 답변 전송 시 SendGrid로 이메일 발송
4. 티켓 상태 변경 시 history 배열에 기록
