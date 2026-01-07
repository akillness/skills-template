# Git Workflow Examples

## Conventional Commits

```bash
# Feature
git commit -m "feat: add user authentication"

# Bug fix
git commit -m "fix: resolve login error"

# Documentation
git commit -m "docs: update README"
```

## GitHub Flow

```bash
# 1. 브랜치 생성
git checkout -b feature/new-feature

# 2. 작업 및 커밋
git add .
git commit -m "feat: implement new feature"

# 3. Push
git push origin feature/new-feature

# 4. PR 생성 후 리뷰
# 5. Merge
```
