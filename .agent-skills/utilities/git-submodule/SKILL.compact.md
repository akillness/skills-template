# git-submodule

> Manage Git submodules for including external repositories within a main repository. Use when working with external libraries, shared modules, or ma...

## When to use this skill
• Including external Git repositories within your main project
• Managing shared libraries or modules across multiple projects
• Locking external dependencies to specific versions
• Working with monorepo-style architectures with independent components
• Cloning repositories that contain submodules
• Updating submodules to newer versions
• Removing submodules from a project

## Instructions
▶ S1: Understanding submodules
Git submodule은 메인 Git 저장소 내에 다른 Git 저장소를 포함시키는 기능입니다.
**Key concepts**:
• 서브모듈은 특정 커밋을 참조하여 버전을 고정합니다
• `.gitmodules` 파일에 서브모듈 경로와 URL이 기록됩니다
• 서브모듈 내 변경은 별도 커밋으로 관리됩니다
▶ S2: Adding submodules
**기본 추가**:
**특정 브랜치 추적**:
**추가 후 커밋**:
▶ S3: Cloning with submodules
**신규 클론 시**:
**한 줄로 초기화 및 업데이트**:
▶ S4: Updating submodules
**원격 최신 버전으로 업데이트**:
**서브모듈 참조 커밋으로 체크아웃**:
▶ S5: Working inside submodules
**서브모듈 내에서 작업**:
**메인 저장소에서 서브모듈 변경 반영**:
▶ S6: Batch operations
**모든 서브모듈에 명령 실행**:
▶ S7: Removing submodules
**서브모듈 완전 제거**:
**예시: libs/lib 제거**:
▶ S8: Checking submodule status
**상태 확인**:
**출력 해석**:

## Best practices
1. 버전 고정
2. 문서화
3. CI 설정
4. 정기 업데이트
5. 브랜치 추적
