# Web Accessibility Examples

## 1단계: 시맨틱 HTML 사용

```html
<!-- ❌ 나쁜 예 -->
<div onClick={handleClick}>Click me</div>

<!-- ✅ 좋은 예 -->
<button onClick={handleClick}>Click me</button>

<!-- Form with proper labels -->
<form>
  <label htmlFor="email">Email</label>
  <input id="email" type="email" name="email" required />
  
  <label htmlFor="password">Password</label>
  <input id="password" type="password" name="password" required />
</form>
```

## 2단계: ARIA 속성 적용

```tsx
// React Dropdown with ARIA
function Dropdown() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div>
      <button
        aria-expanded={isOpen}
        aria-haspopup="true"
        onClick={() => setIsOpen(!isOpen)}
      >
        Menu
      </button>
      {isOpen && (
        <ul role="menu">
          <li role="menuitem"><a href="/home">Home</a></li>
          <li role="menuitem"><a href="/about">About</a></li>
        </ul>
      )}
    </div>
  );
}
```

## 3단계: 키보드 네비게이션

```tsx
function AccessibleModal({ isOpen, onClose, children }) {
  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    
    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
      return () => document.removeEventListener('keydown', handleEscape);
    }
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  return (
    <div
      role="dialog"
      aria-modal="true"
      onClick={onClose}
    >
      <div onClick={(e) => e.stopPropagation()}>
        {children}
      </div>
    </div>
  );
}
```

## 4단계: 포커스 관리

```tsx
import { useRef, useEffect } from 'react';

function FocusTrap({ children }) {
  const firstFocusableRef = useRef<HTMLElement>(null);
  const lastFocusableRef = useRef<HTMLElement>(null);

  useEffect(() => {
    firstFocusableRef.current?.focus();
  }, []);

  const handleTabKey = (e: KeyboardEvent) => {
    if (e.key === 'Tab') {
      if (e.shiftKey && document.activeElement === firstFocusableRef.current) {
        e.preventDefault();
        lastFocusableRef.current?.focus();
      } else if (!e.shiftKey && document.activeElement === lastFocusableRef.current) {
        e.preventDefault();
        firstFocusableRef.current?.focus();
      }
    }
  };

  return <div onKeyDown={handleTabKey}>{children}</div>;
}
```

## 5단계: 접근성 테스트

```typescript
// Jest + axe-core
import { render } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

test('Button has no accessibility violations', async () => {
  const { container } = render(<button>Click me</button>);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```
