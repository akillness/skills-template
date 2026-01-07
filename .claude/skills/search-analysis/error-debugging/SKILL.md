---
name: error-debugging
description: 코드 에러와 버그를 체계적으로 디버깅하고 근본 원인을 찾아 해결하는 스킬
---

# Error Debugging

## When to use this skill
- 런타임 에러: 프로그램 실행 중 예기치 않은 종료나 예외(Exception)가 발생했을 때
- 논리적 버그: 프로그램이 중단되지 않고 실행되지만, 예상과 다른 결과가 나올 때
- 성능 이슈 발생 시: 응답 시간이 느리거나 메모리/CPU 사용량이 비정상적으로 높을 때

## Instructions

### Step 1: 에러 재현 (Reproduce Error)
디버깅의 첫 단계는 문제를 일관되게 재현하는 것입니다. 에러가 발생하는 구체적인 입력값, 환경, 순서를 파악해야 합니다.

필요 조건:
- 에러 로그 및 스택 트레이스 확보
- 문제가 발생하는 최소한의 코드 또는 입력값 식별

```python
# 재현 코드 예시 (Minimal Reproducible Example)
def reproduce_issue():
    # 문제가 발생하는 상황을 코드로 격리
    data = {"valid": False}
    process_data(data) # 이 함수 호출 시 에러 발생 확인
```

### Step 2: 스택 트레이스 분석 (Analyze Stack Trace)
에러 메시지를 주의 깊게 읽고 에러가 발생한 정확한 위치(파일, 라인)를 찾습니다. "가장 안쪽"의 원인부터 확인하며, 사용자 코드와 라이브러리 코드를 구분합니다.

### Step 3: 디버깅 도구 활용 및 가설 검증
문제의 원인을 찾기 위해 도구를 사용하고 가설을 검증합니다.

1. **브레이크포인트 설정 (Set Breakpoints)**: 의심되는 코드 라인에 중단점을 걸어 변수의 상태를 확인합니다.
2. **로깅 추가 (Add Logging)**: 실행 흐름을 추적하기 위해 `print`나 로깅 라이브러리를 사용하여 중간 값을 출력합니다.
3. **이분 탐색 디버깅 (Binary Search Debugging)**: 문제의 원인이 되는 범위를 절반씩 줄여가며 탐색합니다.

## Examples

### Example 1: Python Traceback 분석
Python 스크립트 실행 중 발생하는 `IndexError`를 분석합니다.

```python
def process_items(items):
    # 의도치 않게 인덱스 범위를 벗어나는 경우
    for i in range(len(items) + 1):
        print(items[i])

# 실행 시 IndexError: list index out of range 발생
# 스택 트레이스를 통해 i가 len(items)와 같아지는 시점 파악
```

**Expected output**:
```
Traceback (most recent call last):
  File "example.py", line 4, in process_items
    print(items[i])
IndexError: list index out of range
```

### Example 2: JavaScript 디버거 사용
브라우저 또는 Node.js 환경에서 `debugger` 키워드를 사용합니다.

```javascript
function calculateSum(numbers) {
    let total = 0;
    debugger; // 개발자 도구에서 이 라인에서 실행이 멈춤
    numbers.forEach(n => {
        total += n;
    });
    return total;
}
```

### Example 3: 메모리 누수 탐지
장시간 실행 시 메모리가 계속 증가하는 이슈를 분석합니다.

```python
import tracemalloc

def check_memory_leak():
    tracemalloc.start()
    # 메모리 누수가 의심되는 작업 반복 수행
    run_heavy_task()

    snapshot = tracemalloc.take_snapshot()
    top_stats = snapshot.statistics('lineno')

    print("[ Top 10 memory consuming lines ]")
    for stat in top_stats[:10]:
        print(stat)
```

## Best practices

1. **가설 검증 (Hypothesis Verification)**: 무작위로 코드를 수정하지 말고, "이것이 문제일 것이다"라는 가설을 세운 뒤 이를 확인하는 테스트를 수행하세요.
2. **작은 단위로 테스트 (Test in Small Units)**: 전체 시스템을 실행하기보다, 문제가 되는 함수나 모듈만 분리하여 단위 테스트(Unit Test)를 작성하고 디버깅하세요.
3. **Git bisect 활용**: 언제 버그가 발생했는지 모를 때, Git의 이분 탐색 도구(`git bisect`)를 사용하여 문제가 처음 시작된 커밋을 효율적으로 찾으세요.

## Common pitfalls

- **증상 치료 (Symptomatic Fix)**: 근본 원인(Root Cause)을 해결하지 않고, 단순히 에러 메시지만 피하기 위해 `try-except`로 감싸거나 `if` 문을 추가하는 것은 피해야 합니다. 이는 문제를 숨길 뿐입니다.
- **동시 다발적 변경**: 한 번에 여러 가지 수정을 적용하면, 어떤 변경이 문제를 해결했는지(혹은 새로운 문제를 만들었는지) 알 수 없습니다. 한 번에 하나씩 변경하고 확인하세요.

## Troubleshooting

### Issue 1: 하이젠버그 (Heisenbug)
**Symptoms**: 디버깅을 시도(로그 추가, 디버거 연결)하면 버그가 사라지거나 동작이 달라짐.
**Cause**: 메모리 초기화 문제, Race Condition 등이 관찰 행위에 의해 타이밍이 변하며 발생.
**Solution**: 로깅을 최소화하거나, 시스템 상태를 변경하지 않는 분석 도구 사용. 동시성 문제라면 Thread Sanitizer 같은 도구 활용.

### Issue 2: 환경 차이로 인한 재현 실패
**Symptoms**: 내 로컬 개발 환경에서는 잘 되는데, 동료의 컴퓨터나 배포 서버에서만 에러가 발생함.
**Cause**: OS 차이, 설치된 라이브러리 버전 불일치, 환경 변수 차이, 파일 경로 문제 등.
**Solution**: Docker와 같은 컨테이너 기술을 사용하여 환경을 통일하거나, 문제가 발생하는 환경의 상세 로그 및 설정을 비교 분석.

## References

- [Chrome DevTools Debugging Guide](https://developer.chrome.com/docs/devtools/)
- [Python pdb Documentation](https://docs.python.org/3/library/pdb.html)
- [Git Bisect Documentation](https://git-scm.com/docs/git-bisect)
- [Debug Your Code (Visual Studio Code)](https://code.visualstudio.com/docs/editor/debugging)
