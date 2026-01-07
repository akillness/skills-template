# Codebase Search Examples

## ripgrep 예제

```bash
# 함수 정의 찾기
rg "function\s+\w+" --type js

# import 문 찾기
rg "^import.*from" --type ts

# TODO 주석 찾기
rg "TODO|FIXME" --ignore-case
```
