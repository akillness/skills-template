# Skill: Multi-Agent Workflow

## Purpose
Orchestrate complex tasks by coordinating multiple AI models (Claude, Gemini, Codex) through MCP (Model Context Protocol), leveraging each model's unique strengths for optimal results.

## When to Use This Skill
- Large codebase analysis requiring 1M+ token context
- Complex projects needing multiple perspectives
- Tasks requiring specialized expertise (analysis + design + implementation)
- Code review with cross-validation
- Architectural decisions requiring comprehensive research

## Prerequisites
- Claude Code CLI installed
- MCP servers configured:
  - `gemini-cli`: For large context analysis
  - `codex-cli`: For code generation and refactoring
- Verify with: `claude mcp list`

## Model Selection Matrix

| Task Type | Primary Model | Secondary Model | Reasoning |
|-----------|---------------|-----------------|-----------|
| **Large Codebase Analysis** | Gemini 2.5 Pro | Claude Opus | 1M+ token context window |
| **Fast Code Generation** | Codex | Claude Sonnet | Speed and accuracy |
| **Complex Reasoning** | Claude Opus | Gemini Pro | Deep analytical capability |
| **Code Review** | Claude + Gemini | - | Cross-validation |
| **UI/UX Ideation** | Gemini | Claude | Creative exploration |
| **Bug Fixes** | Codex | Claude | Fast diff generation |
| **Test Writing** | Codex | Claude | Automation |
| **Documentation** | Claude Opus | Gemini | Structured writing |
| **API Design** | Claude | Gemini | Architecture design |
| **Performance Optimization** | Claude | Codex | Analysis then implementation |

## Workflow Patterns

### Pattern 1: Router Pass
```
User Request → Claude (Analyze & Route) → Select Best Model → Execute
```

**Example**:
```
Request: "로그인 기능 구현"
→ Claude analyzes: "API design + Code + Tests"
→ Claude (API design) → Codex (implementation) → Codex (tests)
```

### Pattern 2: Specialist-Then-Finisher
```
Gemini (Explore) → Claude (Refine) → Codex (Implement)
```

**Example**:
```
"새로운 결제 시스템 설계"
→ Gemini: Brainstorm payment options
→ Claude: Design optimal architecture
→ Codex: Implement code
```

### Pattern 3: Risk-Based Routing
```
High-Risk Task → Model 1 Execute → Model 2 Validate → Merge
```

**Example**:
```
"보안 인증 모듈 수정"
→ Codex: Code modification
→ Claude: Security review & vulnerability analysis
→ Approve and merge
```

### Pattern 4: Modality-Based Routing
- **Ideas/UI**: Gemini
- **Analysis/Design**: Claude
- **Implementation/Tests**: Codex

## Step-by-Step Procedure

### Step 1: Task Analysis
```
Claude analyzes the request:
- Identify task complexity
- Determine required expertise
- Break down into subtasks
- Select appropriate models
```

**Prompt Pattern**:
```
"작업을 시작하기 전에:
1. 이 작업의 복잡도를 평가해줘
2. 필요한 전문성을 나열해줘
3. 하위 작업으로 분해해줘
4. 각 하위 작업에 최적의 모델을 제안해줘"
```

### Step 2: Context Preparation
```
Prepare shared context for all models:
- Technical stack
- Constraints
- Definitions
- Acceptance criteria
```

**Template**:
```markdown
## Task Brief

**Goal**: [Clear objective]
**Constraints**: [Tech stack, libraries, performance requirements]
**Definitions**: [Key terms]
**Acceptance Criteria**: [Completion conditions]

## Context
- Current State: [Current code/system state]
- Scope of Change: [Affected files/modules]
```

### Step 3: Model Orchestration
```
Execute tasks in sequence or parallel:
- Sequential: When tasks depend on each other
- Parallel: When tasks are independent
```

**Sequential Example**:
```
1. [Claude] "API 설계를 작성해줘"
   → Review API design
2. [Codex] "codex-cli로 위 설계를 구현해줘"
   → Implement based on design
3. [Codex] "codex-cli로 테스트를 작성해줘"
   → Add tests
4. [Claude] "전체 변경사항을 검토해줘"
   → Final review
```

**Parallel Example**:
```
1. [Gemini] "gemini-cli로 프로젝트 구조 분석해줘"
   [Claude] "보안 취약점을 검토해줘"
   → Run both simultaneously
2. Merge insights and proceed
```

### Step 4: Cross-Validation
```
For critical tasks, validate with multiple models:
1. Primary model executes
2. Secondary model reviews
3. Reconcile differences
4. Apply final changes
```

**Example**:
```
1. [Codex] "codex-cli로 코드 작성"
2. [Claude] "이 코드의 잠재적 위험을 분석해줘"
3. [Gemini] "gemini-cli로 성능 이슈를 검토해줘"
4. Integrate feedback and finalize
```

### Step 5: Integration & Documentation
```
1. Merge all outputs
2. Run tests
3. Update documentation
4. Create decision log
```

**Decision Log Template**:
```markdown
## Decision Log

- [Claude] API uses RESTful design, JWT tokens
- [Gemini] Selected Option B UI (better accessibility)
- [Codex] Used bcrypt library for implementation
```

## Precision Techniques

### 1. Require Explicit Assumptions
```
"작업 시작 전:
1. 현재 코드에 대한 가정을 나열해줘
2. 확인이 필요한 엣지 케이스 3가지 제시해줘
3. 가정이 틀릴 경우 대안을 제시해줘"
```

### 2. Verifiable Output Format
```
"변경사항을 git diff 형식으로 제공해줘"
"실행 가능한 테스트 케이스를 포함해줘"
"변경사항 체크리스트를 마크다운으로 작성해줘"
```

### 3. Scope Constraints
```
"다음 조건을 엄격히 준수해줘:
- auth.ts 파일만 수정
- 새로운 의존성 추가 금지
- 테스트 포함 필수
- 기존 API 시그니처 유지"
```

### 4. Stepwise Verification
```
1단계: "현재 코드를 읽고 이해한 내용을 요약해줘"
→ Verify understanding
2단계: "변경 계획을 3단계로 나눠 설명해줘"
→ Verify plan
3단계: "1단계 변경만 구현해줘"
→ Test and proceed to next step
```

## Real-World Examples

### Example 1: Bug Fix Workflow
```
Scenario: Login API returns 500 error in specific cases

1. [Claude] Analyze error logs
   "로그인 API 에러 로그를 분석하고 근본 원인을 파악해줘"
   → Result: "bcrypt throws exception when password is null"

2. [Gemini] Propose solutions
   "gemini-cli로 이 문제의 3가지 해결 방안을 제시해줘"
   → Options: A) null check, B) Pydantic validation, C) middleware validation

3. [User] Select option
   "옵션 B로 진행 (Pydantic validation)"

4. [Codex] Implement fix
   "codex-cli로 Pydantic 모델을 강화하고 테스트 작성해줘"

5. [Claude] Review impact
   "이 변경사항이 다른 부분에 영향을 주는지 검토해줘"

6. Deploy
   "테스트 실행하고 통과하면 스테이징 배포해줘"
```

### Example 2: New Feature Development
```
Scenario: Add payment system to e-commerce site

1. [Gemini] UI/UX brainstorm
   "gemini-cli로 결제 UI의 3가지 레이아웃 옵션 제안해줘"

2. [Claude] API & data model design
   "결제 시스템의 API 엔드포인트와 DB 스키마를 설계해줘"

3. [Codex] Backend implementation
   "codex-cli로 결제 API를 구현하고 테스트 작성해줘"

4. [Codex] Frontend integration
   "codex-cli로 결제 UI 컴포넌트를 구현해줘"

5. [Gemini] Release notes
   "gemini-cli로 이 기능의 릴리스 노트를 작성해줘"
```

### Example 3: Large-Scale Refactoring
```
Scenario: Convert monolith to microservices

1. [Gemini] Full codebase analysis
   "gemini-cli로 전체 프로젝트 구조와 의존성을 분석해줘"
   (Uses 1M+ token context)

2. [Claude] Safe refactoring plan
   "마이크로서비스 전환을 위한 단계별 계획 수립해줘"

3. [Codex] Incremental execution
   "codex-cli로 인증 모듈을 별도 서비스로 분리해줘"
   (Small commits)

4. [Claude] Regression testing & docs
   "변경사항이 기존 기능에 영향 주는지 확인하고 문서 업데이트해줘"
```

### Example 4: Security Vulnerability Fix
```
Scenario: SQL Injection vulnerability detected

1. [Claude] Deep analysis
   "이 보안 리포트를 분석하고 영향 범위 파악해줘"

2. [Gemini] Attack scenarios
   "gemini-cli로 가능한 공격 시나리오 3가지 제시해줘"

3. [Codex] Implementation
   "codex-cli로 prepared statement로 변경하고 입력 검증 추가해줘"

4. [Claude + Codex] Cross-validation
   "이 수정사항에 다른 취약점 있는지 Claude가 검토해줘"
   "codex-cli로 보안 테스트 케이스 작성해줘"

5. [Claude] Security guide update
   "이 사례를 바탕으로 팀 보안 가이드 업데이트해줘"
```

## Constraints and Best Practices

### DO ✅
- Start with task analysis and model selection
- Prepare shared context for all models
- Use cross-validation for critical tasks
- Maintain decision logs
- Verify each step before proceeding
- Use git diff format for changes
- Include tests with code changes

### DON'T ❌
- Don't use single model for all tasks
- Don't skip context preparation
- Don't ignore model recommendations
- Don't proceed without verification
- Don't forget to document decisions
- Don't add features not requested
- Don't skip error handling

## Output Format

### Task Summary
```markdown
## Multi-Agent Workflow Summary

**Original Request**: [User's original request]

**Model Assignments**:
- Gemini: [Tasks assigned to Gemini]
- Claude: [Tasks assigned to Claude]
- Codex: [Tasks assigned to Codex]

**Workflow Steps**:
1. [Model] [Task description] → [Result]
2. [Model] [Task description] → [Result]
...

**Decision Log**:
- [Decision 1]
- [Decision 2]
...

**Final Deliverables**:
- [Deliverable 1]
- [Deliverable 2]
...

**Verification Status**:
- [ ] Tests passing
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] Security checked
```

## Integration with Other Skills

- **API Design**: Use for designing endpoints before implementation
- **Code Review**: Apply cross-validation pattern
- **Database Schema Design**: Use Gemini for exploration, Claude for design
- **Performance Optimization**: Use Claude for analysis, Codex for implementation
- **Security Best Practices**: Apply risk-based routing pattern

## Troubleshooting

### MCP Server Connection Issues
```bash
# Check server status
claude mcp list

# Restart server
claude mcp remove gemini-cli
claude mcp add gemini-cli -s user -- npx -y gemini-mcp-tool

# Clear npx cache
npx clear-npx-cache
```

### Model Disagreement
```
1. Identify the point of disagreement
2. Consult actual code/types/runtime behavior
3. Use third model for tie-breaking
4. Document final decision
```

### Context Drift
```
Signs:
- "Maybe...", "Probably..." expressions
- Adding unrequested features
- Ignoring project rules

Response:
"잠깐, 다시 정리해줘.
요구사항: [Clear scope]
제약사항: [Clear limits]"
```

## References

- Multi-Model Workflow Guide: `prompt/CLAUDE_MULTI_MODEL_WORKFLOW_GUIDE.md`
- MCP Setup Guide: `prompt/CLAUDE_MCP_GEMINI_CODEX_SETUP.md`
- Claude Code MCP Docs: https://code.claude.com/docs/mcp

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-01-06 | 1.0.0 | Initial skill creation |

---

**Platform**: Claude Code
**Skill Type**: Orchestration
**Complexity**: Advanced
**Estimated Time**: Varies by task complexity
