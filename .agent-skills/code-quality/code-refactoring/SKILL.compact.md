# code-refactoring

> Simplify and refactor code while preserving behavior, improving clarity, and reducing complexity. Use when simplifying complex code, removing dupli...

## When to use this skill
• **코드 리뷰**: 복잡하거나 중복된 코드 발견
• **새 기능 추가 전**: 기존 코드 정리
• **버그 수정 후**: 근본 원인 제거
• **기술 부채 해소**: 정기적인 리팩토링

## Instructions
▶ S1: Extract Method (메서드 추출)
**Before (긴 함수)**:
**After (메서드 추출)**:
▶ S2: Remove Duplication (중복 제거)
**Before (중복)**:
**After (공통 로직 추출)**:
▶ S3: Replace Conditional with Polymorphism
**Before (긴 if-else)**:
**After (다형성)**:
▶ S4: Introduce Parameter Object
**Before (많은 파라미터)**:
**After (객체로 그룹화)**:
▶ S5: SOLID 원칙 적용
**Single Responsibility (단일 책임)**:

## Best practices
1. Boy Scout Rule
2. 리팩토링 타이밍
3. 점진적 개선
4. 행동 보존
5. 작은 커밋
