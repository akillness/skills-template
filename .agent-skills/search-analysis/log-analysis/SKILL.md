---
name: log-analysis
description: 애플리케이션 로그 파일을 분석하여 에러, 성능 병목, 패턴을 발견하고 인사이트를 도출하는 스킬
---

# Log Analysis

## When to use this skill
- 에러 추적 (Error Tracking): 애플리케이션 장애 발생 시 원인 분석
- 성능 문제 파악 (Performance Issue Identification): 응답 지연 및 병목 구간 식별
- 로그 패턴 분석 (Log Pattern Analysis): 비정상적인 접근이나 시스템 이상 징후 탐지

## Instructions

### Step 1: 로그 파일 수집 및 준비
분석 대상 로그 파일의 위치를 확인하고 읽기 권한을 확보합니다. 대용량 파일의 경우 필요한 부분만 샘플링하거나 필터링합니다.

필요 조건:
- 로그 파일 경로 확인 (예: `/var/log/nginx/access.log`)
- 읽기 권한 (`read`)

```bash
# 로그 파일 크기 및 권한 확인
ls -lh /var/log/syslog
# 파일의 처음 10줄 확인
head -n 10 /var/log/syslog
```

### Step 2: 기본 패턴 검색 (Grep/Awk)
`grep`으로 특정 에러 키워드를 검색하거나 `awk`로 특정 필드(예: 상태 코드, 응답 시간)를 추출합니다.

```bash
# 'Error' 또는 'Exception'이 포함된 로그 검색 (대소문자 무시)
grep -iE "error|exception" application.log

# Nginx 로그에서 500 에러만 추출 (9번째 필드가 상태 코드인 경우)
awk '$9 == 500' access.log
```

### Step 3: 고급 분석 및 통계 (Jq/Sort/Uniq)
JSON 로그는 `jq`로 파싱하고, 일반 텍스트 로그는 파이프라인을 통해 집계합니다. 빈도수를 계산하여 주요 이슈를 파악합니다.

```bash
# JSON 로그에서 에러 레벨만 필터링
cat app.log | jq 'select(.level == "error")'

# 가장 많이 발생한 에러 메시지 Top 5 (빈도수 포함)
grep "Error" app.log | cut -d ':' -f 2- | sort | uniq -c | sort -nr | head -n 5
```

### Step 4: 시각화 (Visualization)
텍스트 기반의 간단한 시각화를 통해 시간대별 발생 빈도 등을 파악합니다.

```bash
# 시간대별(시간 단위) 에러 발생 횟수 히스토그램
grep "Error" app.log | awk '{print substr($1, 1, 13)}' | sort | uniq -c | awk '{printf("%s %s\n", $2, $1)}'
```

## Examples

### Example 1: Nginx Log Analysis
Nginx 접근 로그에서 비정상적인 요청(404)을 많이 보낸 상위 IP를 식별합니다.

```bash
# 404 에러를 유발한 IP 주소 Top 5 추출
awk '$9 == 404 {print $1}' access.log | sort | uniq -c | sort -nr | head -n 5
```

**Expected output**:
```
 120 192.168.1.105
  85 10.0.0.50
  ...
```

### Example 2: Application Error Trace
애플리케이션 로그에서 특정 에러 발생 시점의 전후 로그를 함께 확인합니다.

```bash
# 'NullPointerException' 발생 시점의 앞뒤 5줄 포함 검색
grep -C 5 "NullPointerException" app.log
```

### Example 3: System Log Monitoring
시스템 로그에서 인증 실패 시도를 분석합니다.

```bash
grep "authentication failure" /var/log/auth.log | awk '{print $1, $2, $3, $NF}' | tail -n 10
```

## Best practices

1. **로그 레벨 활용**: `grep` 검색 시 `[ERROR]`, `[WARN]` 등 로그 레벨을 명확히 지정하여 노이즈를 줄입니다.
2. **타임스탬프 정규화**: 분석 전 로그의 시간대가 서버 시간(KST/UTC)과 일치하는지 확인합니다.
3. **리소스 관리**: 수 기가바이트의 로그를 `cat`으로 출력하지 말고 `less`나 `tail -f`를 사용하거나 `grep`으로 범위를 좁힙니다.

## Common pitfalls

- **메모리 부족(OOM)**: `sort`나 `uniq`를 대용량 파일 전체에 대해 실행할 때 메모리가 부족할 수 있습니다. 먼저 `grep`으로 필터링하세요.
- **타임존(Timezone) 혼동**: 여러 서버의 로그를 취합할 때 서버 간 시간 설정이 다르면 인과 관계 분석이 틀릴 수 있습니다.
- **멀티라인 로그 누락**: 스택 트레이스처럼 여러 줄로 나뉘는 로그를 단순 `grep`하면 첫 줄만 나오고 나머지 정보는 누락될 수 있습니다.

## Troubleshooting

### Issue 1: 로그 포맷 불일치
**Symptoms**: `awk` 명령어가 엉뚱한 필드를 출력함.
**Cause**: 로그 설정 변경으로 필드 순서가 바뀌거나 구분자(공백, 콤마)가 다름.
**Solution**: `head`로 로그 샘플을 확인하고 `awk -F` 옵션으로 구분자를 명시하거나 필드 번호를 조정합니다.

### Issue 2: 바이너리 파일 경고
**Symptoms**: grep 실행 시 "Binary file matches" 메시지가 뜸.
**Cause**: 로그 파일에 null 문자가 포함되어 있거나 압축된 파일(.gz)임.
**Solution**: `zgrep`을 사용하거나 `grep -a` (text 모드) 옵션을 사용합니다.

## References

- [Grep Manual](https://man7.org/linux/man-pages/man1/grep.1.html)
- [Awk User's Guide](https://www.gnu.org/software/gawk/manual/)
- [Jq Tutorial](https://stedolan.github.io/jq/tutorial/)
