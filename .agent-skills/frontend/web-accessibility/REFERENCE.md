# Web Accessibility Reference

## 베스트 프랙티스 (Best Practices)

1. **WCAG 2.1 AA 준수**: 법적 요구사항 충족
   - 색상 대비 최소 4.5:1 (텍스트)
   - 키보드 접근 가능
   - 스크린 리더 지원

2. **Focus Indicators**: 포커스 표시 제공
   - `:focus-visible` 사용
   - 충분한 대비 제공

3. **Alt Text 작성**: 의미 있는 대체 텍스트
   - 장식용 이미지는 `alt=""`
   - 정보 전달 이미지는 상세한 설명

## 자주 발생하는 문제 (Common Issues)

### 문제 1: "버튼을 div로 만들어서 키보드 접근 불가"

**해결**: `<button>` 요소 사용 또는 `tabIndex={0}` + `role="button"` 추가

### 문제 2: "모달이 열려도 배경 요소에 포커스 가능"

**해결**: 포커스 트랩 구현 (예제 참조)

## 참고 자료 (References)

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [axe-core](https://github.com/dequelabs/axe-core)
- [eslint-plugin-jsx-a11y](https://github.com/jsx-eslint/eslint-plugin-jsx-a11y)
