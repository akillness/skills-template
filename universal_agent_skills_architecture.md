# Universal Agent Skills Architecture

범용 AI 에이전트를 위한 Agent Skills 아키텍처 가이드 (Claude, ChatGPT, Gemini 호환)

## 목차

1. [Agent Skills 오픈 표준 개요](#agent-skills-오픈-표준-개요)
2. [범용 폴더 구조](#범용-폴더-구조)
3. [카테고리별 Skills 설계](#카테고리별-skills-설계)
4. [플랫폼별 적용 방법](#플랫폼별-적용-방법)
5. [실전 Skills 템플릿](#실전-skills-템플릿)
6. [구현 가이드](#구현-가이드)

---

## Agent Skills 오픈 표준 개요

Agent Skills는 Anthropic이 주도하고 커뮤니티가 기여하는 **오픈 포맷**입니다. 이는 AI 에이전트의 기능을 확장하기 위한 경량화된 표준입니다.

### 핵심 개념

**Agent Skills란?**
- `SKILL.md` 파일을 포함하는 폴더
- 최소한 `name`과 `description` 메타데이터 포함
- 특정 작업 수행 방법을 에이전트에게 알려주는 지침
- 스크립트, 템플릿, 참고 자료를 번들로 제공 가능

**기본 구조**:
```
my-skill/
├── SKILL.md          # Required: instructions + metadata
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
└── assets/           # Optional: templates, resources
```

### Progressive Disclosure (점진적 공개)

Agent Skills는 컨텍스트를 효율적으로 관리하기 위해 점진적 공개 방식을 사용합니다:

1. **Discovery (발견)**: 시작 시 각 스킬의 `name`과 `description`만 로드
2. **Activation (활성화)**: 작업이 스킬 설명과 일치하면 전체 `SKILL.md` 지침을 컨텍스트에 로드
3. **Execution (실행)**: 에이전트가 지침을 따르고, 필요시 참조 파일을 로드하거나 번들된 코드를 실행

### 오픈 표준의 장점

- **자체 문서화**: `SKILL.md`를 읽으면 무엇을 하는지 이해 가능
- **확장 가능**: 텍스트 지침부터 실행 코드, 에셋, 템플릿까지 복잡도 조절 가능
- **이식성**: 파일 기반이므로 편집, 버전 관리, 공유가 쉬움
- **플랫폼 독립적**: Claude, ChatGPT, Gemini 등 모든 AI 에이전트에서 사용 가능

**참고 자료**:
- [Agent Skills 공식 사이트](https://agentskills.io/)
- [Agent Skills GitHub](https://github.com/agentskills/agentskills)
- [Skills 통합 가이드](https://agentskills.io/integrate-skills)

---

## 범용 폴더 구조

다양한 AI 에이전트와 개발 환경에서 사용 가능한 범용 Skills 폴더 구조입니다.

### 기본 구조

```
.agent-skills/
├── README.md                          # Skills 저장소 개요
├── CONTRIBUTING.md                    # Skills 기여 가이드
├── templates/                         # Skills 작성 템플릿
│   ├── basic-skill-template/
│   │   └── SKILL.md
│   ├── advanced-skill-template/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── scripts/
│   └── multi-platform-template/
│       └── SKILL.md
├── infrastructure/                    # 인프라 관련 Skills
│   ├── system-setup/
│   ├── deployment/
│   ├── monitoring/
│   └── security/
├── backend/                           # 백엔드 개발 Skills
│   ├── api-design/
│   ├── database/
│   ├── authentication/
│   └── testing/
├── frontend/                          # 프론트엔드 개발 Skills
│   ├── ui-components/
│   ├── state-management/
│   ├── responsive-design/
│   └── accessibility/
├── documentation/                     # 문서 작성 Skills
│   ├── technical-writing/
│   ├── api-documentation/
│   ├── user-guides/
│   └── changelog/
├── code-quality/                      # 코드 품질 Skills
│   ├── code-review/
│   ├── refactoring/
│   ├── testing-strategies/
│   └── performance-optimization/
├── search-analysis/                   # 검색 및 분석 Skills
│   ├── codebase-search/
│   ├── log-analysis/
│   ├── data-analysis/
│   └── pattern-detection/
├── project-management/                # 프로젝트 관리 Skills
│   ├── task-planning/
│   ├── estimation/
│   ├── retrospective/
│   └── standup-helper/
└── utilities/                         # 유틸리티 Skills
    ├── git-workflow/
    ├── environment-setup/
    ├── file-organization/
    └── automation/
```

### 폴더 명명 규칙

- **카테고리 폴더**: `kebab-case`, 복수형 사용 (예: `infrastructure`, `backend`)
- **Skill 폴더**: `kebab-case`, 명확하고 설명적인 이름 (예: `api-design`, `code-review`)
- **지원 파일 폴더**: `kebab-case` 또는 `snake_case` (예: `scripts`, `references`, `assets`)

### 파일 명명 규칙

- **필수 파일**: `SKILL.md` (대문자, 각 Skill 폴더에 필수)
- **참고 문서**: `REFERENCE.md`, `EXAMPLES.md`, `TROUBLESHOOTING.md`
- **스크립트**: `setup.py`, `validate.sh`, `helper.js`
- **템플릿**: `template.txt`, `config.yaml`, `example.json`

---

## 카테고리별 Skills 설계

### 1. Infrastructure (인프라)

시스템 구축, 배포, 모니터링 관련 Skills

```
infrastructure/
├── system-setup/
│   ├── SKILL.md
│   ├── scripts/
│   │   ├── install_dependencies.sh
│   │   └── configure_environment.py
│   └── templates/
│       ├── docker-compose.yml
│       └── nginx.conf
├── deployment/
│   ├── SKILL.md
│   ├── CICD.md
│   └── scripts/
│       ├── deploy.sh
│       └── rollback.sh
├── monitoring/
│   ├── SKILL.md
│   ├── references/
│   │   ├── metrics.md
│   │   └── alerts.md
│   └── templates/
│       └── prometheus.yml
└── security/
    ├── SKILL.md
    ├── CHECKLIST.md
    └── scripts/
        └── security_audit.py
```

**예제 SKILL.md (system-setup)**:
```markdown
---
name: system-setup
description: Set up development and production environments. Use when initializing new systems, configuring servers, or setting up CI/CD pipelines. Handles Docker, Kubernetes, cloud platforms.
---

# System Setup

## When to use this skill
- Setting up new development environments
- Configuring production servers
- Initializing container orchestration
- Cloud infrastructure setup (AWS, GCP, Azure)

## Instructions

### 1. Assess current environment
- Check OS version and architecture
- Verify system resources (CPU, RAM, disk)
- Identify required dependencies

### 2. Install dependencies
```bash
./scripts/install_dependencies.sh
```

### 3. Configure environment
```bash
python scripts/configure_environment.py --env production
```

### 4. Verify installation
- Run health checks
- Test connectivity
- Validate configurations

## Templates
- Docker Compose: [templates/docker-compose.yml](templates/docker-compose.yml)
- Nginx Config: [templates/nginx.conf](templates/nginx.conf)

## Best practices
- Use Infrastructure as Code (IaC)
- Document all configurations
- Implement monitoring from the start
- Follow security best practices
```

### 2. Backend (백엔드)

API 설계, 데이터베이스, 인증 등 백엔드 개발 Skills

```
backend/
├── api-design/
│   ├── SKILL.md
│   ├── REST_GUIDELINES.md
│   ├── GRAPHQL_GUIDELINES.md
│   └── templates/
│       ├── openapi.yaml
│       └── api_schema.json
├── database/
│   ├── SKILL.md
│   ├── SCHEMA_DESIGN.md
│   ├── MIGRATION.md
│   └── scripts/
│       ├── migrate.py
│       └── seed.sql
├── authentication/
│   ├── SKILL.md
│   ├── JWT_GUIDE.md
│   ├── OAUTH_GUIDE.md
│   └── scripts/
│       └── generate_keys.py
└── testing/
    ├── SKILL.md
    ├── UNIT_TESTING.md
    ├── INTEGRATION_TESTING.md
    └── templates/
        ├── test_template.py
        └── pytest.ini
```

**예제 SKILL.md (api-design)**:
```markdown
---
name: api-design
description: Design RESTful and GraphQL APIs following best practices. Use when creating new APIs, refactoring existing endpoints, or documenting API specifications. Handles OpenAPI, REST, GraphQL, versioning.
---

# API Design

## When to use this skill
- Designing new REST APIs
- Creating GraphQL schemas
- Refactoring API endpoints
- Documenting API specifications
- API versioning strategies

## Instructions

### 1. Define API requirements
- Identify resources and entities
- Define relationships
- Specify operations (CRUD, custom actions)
- Plan authentication/authorization

### 2. Design REST API
**Resource naming**:
- Use nouns, not verbs: `/users` not `/getUsers`
- Use plural names: `/users/{id}`
- Nest resources logically: `/users/{id}/posts`

**HTTP methods**:
- GET: Retrieve resources
- POST: Create new resources
- PUT/PATCH: Update resources
- DELETE: Remove resources

**Response codes**:
- 200: Success
- 201: Created
- 400: Bad request
- 401: Unauthorized
- 404: Not found
- 500: Server error

### 3. Create OpenAPI specification
Use template: [templates/openapi.yaml](templates/openapi.yaml)

```yaml
openapi: 3.0.0
info:
  title: API Name
  version: 1.0.0
paths:
  /users:
    get:
      summary: List users
      responses:
        '200':
          description: Successful response
```

### 4. Design GraphQL schema (if applicable)
See [GRAPHQL_GUIDELINES.md](GRAPHQL_GUIDELINES.md)

## Best practices
- Version your APIs (v1, v2)
- Use consistent naming conventions
- Implement rate limiting
- Document all endpoints
- Include examples in documentation
- Use HATEOAS for discoverability

## References
- REST Guidelines: [REST_GUIDELINES.md](REST_GUIDELINES.md)
- GraphQL Guidelines: [GRAPHQL_GUIDELINES.md](GRAPHQL_GUIDELINES.md)
```

### 3. Frontend (프론트엔드)

UI 컴포넌트, 상태 관리, 반응형 디자인 Skills

```
frontend/
├── ui-components/
│   ├── SKILL.md
│   ├── DESIGN_SYSTEM.md
│   ├── templates/
│   │   ├── button.tsx
│   │   ├── form.tsx
│   │   └── modal.tsx
│   └── assets/
│       └── component-library.css
├── state-management/
│   ├── SKILL.md
│   ├── REDUX_GUIDE.md
│   ├── CONTEXT_API.md
│   └── examples/
│       └── store_setup.ts
├── responsive-design/
│   ├── SKILL.md
│   ├── BREAKPOINTS.md
│   └── templates/
│       └── responsive.css
└── accessibility/
    ├── SKILL.md
    ├── WCAG_CHECKLIST.md
    ├── ARIA_GUIDE.md
    └── scripts/
        └── accessibility_audit.js
```

**예제 SKILL.md (ui-components)**:
```markdown
---
name: ui-components
description: Create reusable, accessible UI components following modern design patterns. Use when building component libraries, design systems, or frontend interfaces. Handles React, Vue, Angular, Web Components.
---

# UI Components

## When to use this skill
- Creating new UI components
- Building design systems
- Refactoring existing components
- Implementing accessible interfaces
- Styling with modern CSS

## Instructions

### 1. Component planning
- Define component purpose
- Identify props/inputs
- Plan component variants
- Consider accessibility

### 2. Component structure (React example)
```tsx
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'medium',
  disabled = false,
  onClick,
  children
}) => {
  return (
    <button
      className={`btn btn-${variant} btn-${size}`}
      disabled={disabled}
      onClick={onClick}
      aria-disabled={disabled}
    >
      {children}
    </button>
  );
};
```

### 3. Accessibility checklist
- [ ] Keyboard navigation support
- [ ] Screen reader compatibility
- [ ] ARIA attributes
- [ ] Color contrast ratios
- [ ] Focus indicators

### 4. Component documentation
Document:
- Props/API
- Usage examples
- Accessibility features
- Browser support

## Templates
- Button: [templates/button.tsx](templates/button.tsx)
- Form: [templates/form.tsx](templates/form.tsx)
- Modal: [templates/modal.tsx](templates/modal.tsx)

## Design system reference
See [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) for:
- Color palette
- Typography scale
- Spacing system
- Component variants

## Best practices
- Keep components small and focused
- Make components reusable
- Document props and usage
- Test across browsers
- Ensure accessibility
- Use semantic HTML
```

### 4. Documentation (문서)

기술 문서, API 문서, 사용자 가이드 작성 Skills

```
documentation/
├── technical-writing/
│   ├── SKILL.md
│   ├── STYLE_GUIDE.md
│   ├── templates/
│   │   ├── technical_spec.md
│   │   ├── architecture_doc.md
│   │   └── runbook.md
│   └── references/
│       └── writing_best_practices.md
├── api-documentation/
│   ├── SKILL.md
│   ├── templates/
│   │   ├── api_reference.md
│   │   └── endpoint_template.md
│   └── scripts/
│       └── generate_docs.py
├── user-guides/
│   ├── SKILL.md
│   ├── templates/
│   │   ├── getting_started.md
│   │   ├── tutorial.md
│   │   └── faq.md
│   └── assets/
│       └── screenshots/
└── changelog/
    ├── SKILL.md
    ├── CHANGELOG_FORMAT.md
    └── templates/
        └── changelog_entry.md
```

**예제 SKILL.md (technical-writing)**:
```markdown
---
name: technical-writing
description: Write clear, comprehensive technical documentation. Use when creating specs, architecture docs, runbooks, or any technical documentation. Follows industry best practices for clarity and structure.
---

# Technical Writing

## When to use this skill
- Writing technical specifications
- Creating architecture documentation
- Documenting system designs
- Writing runbooks and operational guides
- Creating developer documentation

## Instructions

### 1. Understand the audience
- **Developers**: Focus on implementation details
- **DevOps**: Focus on deployment and operations
- **Managers**: Focus on high-level overview
- **End users**: Focus on functionality and usage

### 2. Document structure
```markdown
# Document Title

## Overview
Brief description of what this document covers

## Problem Statement
What problem are we solving?

## Solution Approach
How are we solving it?

## Technical Details
### Architecture
### Components
### Data Flow

## Implementation
### Requirements
### Steps
### Configuration

## Testing
### Test Cases
### Validation

## Deployment
### Prerequisites
### Steps
### Rollback Plan

## Monitoring & Maintenance
### Metrics to track
### Common issues
### Troubleshooting

## References
Links to related documents
```

### 3. Writing guidelines
**Clarity**:
- Use simple, direct language
- Avoid jargon when possible
- Define technical terms

**Structure**:
- Use hierarchical headings
- Break content into sections
- Use lists for multiple items

**Examples**:
- Include code examples
- Provide diagrams
- Show before/after comparisons

**Completeness**:
- Cover prerequisites
- Include error handling
- Document edge cases

### 4. Visual aids
- Architecture diagrams (Mermaid, PlantUML)
- Flow charts for processes
- Screenshots for UI
- Code snippets with syntax highlighting

## Templates
- Technical Spec: [templates/technical_spec.md](templates/technical_spec.md)
- Architecture Doc: [templates/architecture_doc.md](templates/architecture_doc.md)
- Runbook: [templates/runbook.md](templates/runbook.md)

## Style guide
See [STYLE_GUIDE.md](STYLE_GUIDE.md) for:
- Writing conventions
- Formatting rules
- Terminology standards
- Example patterns

## Best practices
- Write for your audience
- Use active voice
- Be concise but complete
- Update documentation with code changes
- Version your documentation
- Include a table of contents
- Add a last updated date
```

### 5. Code Quality (코드 품질)

코드 리뷰, 리팩토링, 테스팅 전략 Skills

```
code-quality/
├── code-review/
│   ├── SKILL.md
│   ├── CHECKLIST.md
│   └── references/
│       ├── review_guidelines.md
│       └── common_issues.md
├── refactoring/
│   ├── SKILL.md
│   ├── PATTERNS.md
│   ├── ANTI_PATTERNS.md
│   └── examples/
│       ├── extract_method.md
│       └── simplify_conditional.md
├── testing-strategies/
│   ├── SKILL.md
│   ├── UNIT_TESTING.md
│   ├── INTEGRATION_TESTING.md
│   ├── E2E_TESTING.md
│   └── templates/
│       └── test_plan.md
└── performance-optimization/
    ├── SKILL.md
    ├── PROFILING.md
    ├── OPTIMIZATION_TECHNIQUES.md
    └── scripts/
        └── benchmark.py
```

**예제 SKILL.md (code-review)**:
```markdown
---
name: code-review
description: Conduct thorough, constructive code reviews. Use when reviewing pull requests, checking code quality, or providing feedback on code. Covers best practices, common issues, and review patterns.
allowed-tools: Read, Grep, Glob
---

# Code Review

## When to use this skill
- Reviewing pull requests
- Checking code quality
- Providing feedback on implementations
- Identifying potential bugs
- Suggesting improvements

## Instructions

### 1. Review checklist

#### Code Organization
- [ ] Clear, descriptive naming
- [ ] Appropriate file/folder structure
- [ ] Logical code organization
- [ ] Separation of concerns

#### Functionality
- [ ] Code does what it's supposed to
- [ ] Edge cases handled
- [ ] Error handling implemented
- [ ] No obvious bugs

#### Code Quality
- [ ] DRY principle followed
- [ ] SOLID principles applied
- [ ] No code smells
- [ ] Appropriate abstractions

#### Testing
- [ ] Unit tests included
- [ ] Integration tests if needed
- [ ] Tests cover edge cases
- [ ] Tests are maintainable

#### Security
- [ ] Input validation
- [ ] No hardcoded secrets
- [ ] Authentication/authorization
- [ ] SQL injection prevention

#### Performance
- [ ] No obvious bottlenecks
- [ ] Efficient algorithms
- [ ] Appropriate data structures
- [ ] Resource management

#### Documentation
- [ ] Code comments where needed
- [ ] Function/class documentation
- [ ] README updated
- [ ] API docs if applicable

### 2. Review process

**Step 1: Understand the context**
- Read PR description
- Check linked issues
- Understand the goal

**Step 2: High-level review**
- Review architecture changes
- Check overall approach
- Verify design decisions

**Step 3: Detailed review**
- Read code line by line
- Check logic and algorithms
- Verify error handling

**Step 4: Test review**
- Check test coverage
- Verify test quality
- Run tests locally

**Step 5: Provide feedback**
- Be constructive and specific
- Explain reasoning
- Suggest improvements
- Acknowledge good work

### 3. Feedback guidelines

**Good feedback**:
```
"Consider extracting this logic into a separate function 
for better testability. For example:

function validateUser(user) {
  // validation logic here
}

This would make it easier to test and reuse."
```

**Avoid**:
```
"This is wrong."
"Bad code."
"Rewrite this."
```

### 4. Common issues to check

See [references/common_issues.md](references/common_issues.md) for:
- Null pointer exceptions
- Race conditions
- Memory leaks
- Security vulnerabilities
- Performance anti-patterns

## Review checklist
Full checklist: [CHECKLIST.md](CHECKLIST.md)

## Best practices
- Review promptly
- Be respectful and constructive
- Focus on code, not the person
- Explain the "why" behind suggestions
- Acknowledge good work
- Use automated tools for basic checks
- Review your own code first
```

### 6. Search & Analysis (검색 및 분석)

코드베이스 검색, 로그 분석, 패턴 감지 Skills

```
search-analysis/
├── codebase-search/
│   ├── SKILL.md
│   ├── SEARCH_PATTERNS.md
│   └── scripts/
│       └── semantic_search.py
├── log-analysis/
│   ├── SKILL.md
│   ├── LOG_PATTERNS.md
│   └── scripts/
│       ├── parse_logs.py
│       └── analyze_errors.py
├── data-analysis/
│   ├── SKILL.md
│   ├── references/
│   │   ├── statistics.md
│   │   └── visualization.md
│   └── scripts/
│       └── analyze.py
└── pattern-detection/
    ├── SKILL.md
    └── scripts/
        └── detect_patterns.py
```

**예제 SKILL.md (codebase-search)**:
```markdown
---
name: codebase-search
description: Search and navigate large codebases efficiently. Use when finding specific code patterns, tracing function calls, or understanding code structure. Handles semantic search, grep patterns, AST analysis.
allowed-tools: Read, Grep, Glob, Codebase_Search
---

# Codebase Search

## When to use this skill
- Finding specific functions or classes
- Tracing function calls
- Understanding code structure
- Finding usage examples
- Identifying code patterns
- Locating bugs or issues

## Instructions

### 1. Search strategies

**Semantic search** (understanding intent):
```
Query: "How do we handle user authentication?"
Target: Look in auth/, middleware/, or security/ directories
```

**Exact text search** (grep):
```
Pattern: "function authenticate"
Use when you know exact text
```

**File pattern search** (glob):
```
Pattern: "**/*.test.js"
Find all test files
```

### 2. Search workflow

**Step 1: Understand what you're looking for**
- Feature implementation
- Bug location
- API usage
- Configuration

**Step 2: Choose search method**
- Semantic: For conceptual searches
- Grep: For exact text/patterns
- Glob: For file discovery

**Step 3: Refine search**
- Start broad, narrow down
- Use directory filters
- Combine multiple searches

**Step 4: Analyze results**
- Read relevant files
- Understand context
- Trace dependencies

### 3. Common search patterns

**Find function definition**:
```bash
grep -n "function functionName" --type js
grep -n "def function_name" --type py
```

**Find class usage**:
```bash
grep -n "new ClassName" --type js
grep -n "ClassName()" --type py
```

**Find imports/requires**:
```bash
grep -n "import.*ModuleName" --type js
grep -n "from.*import" --type py
```

**Find configuration**:
```bash
glob "**/*config*.{json,yaml,yml}"
```

### 4. Advanced techniques

**Find all files calling a function**:
1. Grep for function name
2. Filter by file type
3. Check import statements

**Trace data flow**:
1. Find where data is created
2. Search for variable usage
3. Follow through transformations
4. Find where it's consumed

**Find related code**:
1. Start with known file
2. Check imports/exports
3. Find files importing this module
4. Build dependency graph

## Search patterns reference
See [SEARCH_PATTERNS.md](SEARCH_PATTERNS.md) for:
- Regex patterns
- Language-specific searches
- Common code patterns

## Best practices
- Start with semantic search for unfamiliar code
- Use grep for exact matches
- Combine searches for complex queries
- Read surrounding context
- Check file history (git blame)
- Document search findings
```

---

## 플랫폼별 적용 방법

### Claude (Cursor, Claude.ai, Claude Code)

**위치**:
- Personal Skills: `~/.claude/skills/`
- Project Skills: `.claude/skills/`

**자동 발견**:
Claude는 자동으로 위 위치의 Skills를 발견하고 로드합니다.

**사용 방법**:
1. Skills 폴더에 SKILL.md 생성
2. Claude에게 작업 요청
3. Claude가 자동으로 관련 Skill 활성화

**프롬프트 예시**:
```
"API 엔드포인트를 설계해줘" 
→ Claude가 자동으로 api-design Skill 활성화
```

**장점**:
- 완전 자동화된 Skill 발견
- 컨텍스트 최적화
- Git 통합 (프로젝트 Skills)

### ChatGPT (Custom GPTs, GPT-4)

**적용 방법**:
ChatGPT는 Agent Skills를 네이티브로 지원하지 않으므로 수동 통합이 필요합니다.

**방법 1: Knowledge Base 업로드**
1. Skills 폴더를 zip으로 압축
2. Custom GPT의 Knowledge에 업로드
3. Instructions에 Skill 사용 방법 명시

**Instructions 예시**:
```
You have access to Agent Skills in your knowledge base.
Each skill is in a folder with SKILL.md file.

When a task matches a skill's description:
1. Read the SKILL.md file
2. Follow the instructions
3. Use referenced files as needed

Available skills include:
- api-design: For REST/GraphQL API design
- code-review: For reviewing code quality
- technical-writing: For documentation
[... list other skills ...]
```

**방법 2: Prompt 직접 포함**
```
I'm using Agent Skills format. Here's the skill I want you to follow:

[Paste SKILL.md content]

Please follow these instructions for my task: [your request]
```

**장점**:
- Custom GPT로 팀과 공유 가능
- Knowledge Base로 일관성 유지

**단점**:
- 자동 발견 없음
- 수동 업데이트 필요

### Gemini (Gemini Advanced, API)

**적용 방법**:
Gemini 역시 네이티브 지원이 없으므로 프롬프트 통합이 필요합니다.

**방법 1: System Instruction 활용**
```python
import google.generativeai as genai

# Skill 내용 로드
with open('.agent-skills/backend/api-design/SKILL.md') as f:
    skill_content = f.read()

model = genai.GenerativeModel(
    model_name='gemini-pro',
    system_instruction=f"""
    You are an AI assistant with specialized skills.
    
    When designing APIs, follow this skill:
    
    {skill_content}
    """
)

response = model.generate_content("Design a REST API for user management")
```

**방법 2: Few-Shot Examples**
Skills를 few-shot 예시로 변환:

```python
skill_example = """
User: Design a REST API for products
Assistant: Following API design best practices...
[Include skill instructions as example]
"""

prompt = f"""
{skill_example}

Now help me: Design a REST API for user management
```

**장점**:
- API 통합으로 자동화 가능
- 프로그래밍 방식 제어

**단점**:
- 스크립트 작성 필요
- Skill 로더 구현 필요

### 범용 통합 스크립트

모든 플랫폼에서 사용할 수 있는 Python 스크립트:

```python
# skill_loader.py
import os
import yaml
from pathlib import Path

class SkillLoader:
    def __init__(self, skills_dir='.agent-skills'):
        self.skills_dir = Path(skills_dir)
        self.skills = {}
        self.load_all_skills()
    
    def load_all_skills(self):
        """모든 Skills 발견 및 메타데이터 로드"""
        for skill_md in self.skills_dir.rglob('SKILL.md'):
            skill = self.parse_skill(skill_md)
            if skill:
                self.skills[skill['name']] = skill
    
    def parse_skill(self, skill_path):
        """SKILL.md 파싱"""
        with open(skill_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # YAML frontmatter 추출
        if content.startswith('---'):
            parts = content.split('---', 2)
            if len(parts) >= 3:
                frontmatter = yaml.safe_load(parts[1])
                body = parts[2].strip()
                
                return {
                    'name': frontmatter.get('name'),
                    'description': frontmatter.get('description'),
                    'path': skill_path.parent,
                    'body': body,
                    'allowed_tools': frontmatter.get('allowed-tools', [])
                }
        return None
    
    def get_skill(self, name):
        """특정 Skill 가져오기"""
        return self.skills.get(name)
    
    def search_skills(self, query):
        """쿼리로 관련 Skills 검색"""
        results = []
        query_lower = query.lower()
        
        for skill in self.skills.values():
            if (query_lower in skill['name'].lower() or 
                query_lower in skill['description'].lower()):
                results.append(skill)
        
        return results
    
    def format_for_prompt(self, skill_names=None):
        """AI 프롬프트용 포맷"""
        if skill_names is None:
            skill_names = self.skills.keys()
        
        prompt = "Available Skills:\n\n"
        for name in skill_names:
            skill = self.skills[name]
            prompt += f"## {skill['name']}\n"
            prompt += f"{skill['description']}\n\n"
            prompt += f"Instructions:\n{skill['body']}\n\n"
            prompt += "---\n\n"
        
        return prompt

# 사용 예시
if __name__ == '__main__':
    loader = SkillLoader()
    
    # 모든 Skills 목록
    print("Available Skills:")
    for name in loader.skills.keys():
        print(f"- {name}")
    
    # 특정 Skill 가져오기
    api_skill = loader.get_skill('api-design')
    print(f"\nSkill: {api_skill['name']}")
    print(api_skill['description'])
    
    # 프롬프트 생성
    prompt = loader.format_for_prompt(['api-design', 'code-review'])
    print("\nPrompt for AI:")
    print(prompt)
```

**사용 방법**:
```bash
# Skills 목록 보기
python skill_loader.py

# 특정 Skill을 프롬프트로 변환
python skill_loader.py --skill api-design --output prompt.txt
```

---

## 실전 Skills 템플릿

### 템플릿 1: 기본 Skill

```markdown
---
name: skill-name
description: Brief description. Use when [trigger scenarios]. Handles [technologies/contexts].
---

# Skill Name

## When to use this skill
- Scenario 1
- Scenario 2
- Scenario 3

## Instructions

### Step 1: [Action]
Description and details

### Step 2: [Action]
Description and details

### Step 3: [Action]
Description and details

## Examples

### Example 1: [Scenario]
```language
code example
```

### Example 2: [Scenario]
```language
code example
```

## Best practices
- Practice 1
- Practice 2
- Practice 3

## References
- [Link to related resources]
```

### 템플릿 2: 도구 제한 Skill

```markdown
---
name: safe-operation-name
description: Description emphasizing safety/read-only nature. Use when [scenarios].
allowed-tools: Read, Grep, Glob
---

# Safe Operation Name

## When to use this skill
- Read-only operations
- Analysis without modification
- Information gathering

## Allowed tools
This skill restricts Claude to:
- **Read**: View file contents
- **Grep**: Search within files
- **Glob**: Find files by pattern

## Instructions
[Instructions using only allowed tools]

## Safety notes
- This skill prevents accidental modifications
- Use for [specific safe scenarios]
```

### 템플릿 3: 복잡한 Multi-file Skill

```markdown
---
name: complex-skill-name
description: Comprehensive description. Use when [scenarios]. Requires [dependencies].
---

# Complex Skill Name

## Overview
Detailed overview of what this skill provides

## Prerequisites
- Dependency 1
- Dependency 2
- Environment setup

## Quick Start
```bash
# Installation
pip install required-package

# Basic usage
command --help
```

## Instructions

### Basic usage
See [BASIC_USAGE.md](BASIC_USAGE.md)

### Advanced usage
See [ADVANCED_USAGE.md](ADVANCED_USAGE.md)

### Troubleshooting
See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## Scripts

### Setup script
```bash
./scripts/setup.sh
```

### Main script
```bash
python scripts/main.py --config config.yaml
```

## Templates
- Template 1: [templates/template1.txt](templates/template1.txt)
- Template 2: [templates/template2.yaml](templates/template2.yaml)

## Examples
See [examples/](examples/) directory for:
- Example 1: Basic scenario
- Example 2: Advanced scenario
- Example 3: Edge cases

## References
- External docs: [link]
- Related skills: [skill-name]
- Project wiki: [link]
```

---

## 구현 가이드

### 1단계: 폴더 구조 생성

```bash
#!/bin/bash
# setup_agent_skills.sh

# 기본 디렉토리 생성
mkdir -p .agent-skills/{infrastructure,backend,frontend,documentation,code-quality,search-analysis,project-management,utilities,templates}

# Infrastructure
mkdir -p .agent-skills/infrastructure/{system-setup,deployment,monitoring,security}

# Backend
mkdir -p .agent-skills/backend/{api-design,database,authentication,testing}

# Frontend
mkdir -p .agent-skills/frontend/{ui-components,state-management,responsive-design,accessibility}

# Documentation
mkdir -p .agent-skills/documentation/{technical-writing,api-documentation,user-guides,changelog}

# Code Quality
mkdir -p .agent-skills/code-quality/{code-review,refactoring,testing-strategies,performance-optimization}

# Search & Analysis
mkdir -p .agent-skills/search-analysis/{codebase-search,log-analysis,data-analysis,pattern-detection}

# Project Management
mkdir -p .agent-skills/project-management/{task-planning,estimation,retrospective,standup-helper}

# Utilities
mkdir -p .agent-skills/utilities/{git-workflow,environment-setup,file-organization,automation}

echo "Agent Skills 폴더 구조 생성 완료!"
```

### 2단계: README 작성

```markdown
# Agent Skills Repository

이 저장소는 AI 에이전트를 위한 Agent Skills 모음입니다.

## 구조

- `infrastructure/`: 인프라 및 시스템 구축
- `backend/`: 백엔드 개발
- `frontend/`: 프론트엔드 개발
- `documentation/`: 문서 작성
- `code-quality/`: 코드 품질
- `search-analysis/`: 검색 및 분석
- `project-management/`: 프로젝트 관리
- `utilities/`: 유틸리티

## 사용 방법

### Claude
Skills가 자동으로 발견됩니다. 작업을 요청하면 Claude가 관련 Skill을 활성화합니다.

### ChatGPT
Custom GPT의 Knowledge에 업로드하거나, 프롬프트에 직접 포함하세요.

### Gemini
System Instruction에 Skill 내용을 포함하거나, API로 통합하세요.

## Skills 추가

1. 카테고리 폴더에서 새 폴더 생성
2. `SKILL.md` 파일 작성
3. 필요시 지원 파일 추가 (scripts/, references/, assets/)
4. Git에 커밋

## 기여 가이드

[CONTRIBUTING.md](CONTRIBUTING.md) 참조
```

### 3단계: 첫 번째 Skill 생성

```bash
# API Design Skill 생성 예시
mkdir -p .agent-skills/backend/api-design
cat > .agent-skills/backend/api-design/SKILL.md << 'EOF'
---
name: api-design
description: Design RESTful and GraphQL APIs following best practices. Use when creating new APIs, refactoring existing endpoints, or documenting API specifications.
---

# API Design

## When to use this skill
- Designing new REST APIs
- Creating GraphQL schemas
- Refactoring API endpoints
- Documenting API specifications

## Instructions

### 1. Define resources
Identify the main entities in your system.

### 2. Design endpoints
Use RESTful conventions:
- GET /resources - List all
- GET /resources/{id} - Get one
- POST /resources - Create
- PUT /resources/{id} - Update
- DELETE /resources/{id} - Delete

### 3. Document with OpenAPI
Create OpenAPI 3.0 specification.

## Best practices
- Use nouns, not verbs in URLs
- Version your API (/v1/, /v2/)
- Use proper HTTP status codes
- Implement pagination for lists
- Provide filtering and sorting
EOF

echo "API Design Skill 생성 완료!"
```

### 4단계: Git 설정

```bash
# .gitignore에 추가하지 않을 것
# Skills는 버전 관리에 포함되어야 함

# Git에 추가
git add .agent-skills/
git commit -m "Add Agent Skills infrastructure"
git push
```

### 5단계: 팀과 공유

```markdown
# Team Onboarding

## Claude 사용자
1. 저장소를 클론하세요
2. Skills가 `.agent-skills/`에 있습니다
3. Claude가 자동으로 인식합니다

## ChatGPT 사용자
1. `.agent-skills/` 폴더를 zip으로 압축
2. Custom GPT Knowledge에 업로드
3. Instructions에 Skill 사용 가이드 추가

## Gemini 사용자
1. `skill_loader.py` 스크립트 사용
2. System Instruction에 Skills 포함
3. API로 통합
```

---

## 모범 사례

### 1. Skill 설계 원칙

- **단일 책임**: 각 Skill은 하나의 명확한 목적
- **재사용 가능**: 다양한 프로젝트에서 사용 가능
- **플랫폼 독립적**: Claude, ChatGPT, Gemini 모두에서 작동
- **자체 문서화**: SKILL.md만 읽어도 이해 가능

### 2. 설명(Description) 작성 팁

**좋은 설명**:
```yaml
description: Analyze sales data in Excel files and CRM exports. Use for sales reports, pipeline analysis, revenue tracking. Handles .xlsx, .csv, Salesforce exports.
```

**나쁜 설명**:
```yaml
description: For data analysis
```

**포함할 내용**:
- 무엇을 하는가
- 언제 사용하는가
- 어떤 기술/파일 타입을 다루는가

### 3. 폴더 조직

```
skill-name/
├── SKILL.md              # 필수
├── README.md             # 선택: 추가 설명
├── REFERENCE.md          # 선택: 상세 레퍼런스
├── EXAMPLES.md           # 선택: 예제 모음
├── TROUBLESHOOTING.md    # 선택: 문제 해결
├── scripts/              # 선택: 실행 스크립트
│   ├── setup.sh
│   └── main.py
├── templates/            # 선택: 템플릿 파일
│   ├── config.yaml
│   └── template.txt
├── references/           # 선택: 참고 문서
│   └── external_docs.md
└── assets/               # 선택: 기타 자산
    └── diagram.png
```

### 4. 버전 관리

```markdown
## Version History

### v1.2.0 (2024-01-15)
- Added GraphQL support
- Updated REST guidelines
- Fixed example code

### v1.1.0 (2023-12-01)
- Added OpenAPI template
- Improved error handling examples

### v1.0.0 (2023-11-01)
- Initial release
```

### 5. 테스트

각 Skill을 작성한 후:
1. Claude, ChatGPT, Gemini에서 테스트
2. 다양한 시나리오로 검증
3. 팀 멤버 피드백 수집
4. 개선 사항 반영

---

## 참고 자료

### 공식 문서
- [Agent Skills 공식 사이트](https://agentskills.io/)
- [Agent Skills 사양](https://agentskills.io/specification)
- [Agent Skills GitHub](https://github.com/agentskills/agentskills)
- [Skills 통합 가이드](https://agentskills.io/integrate-skills)

### Claude Code 문서
- [Claude Code Skills](https://code.claude.com/docs/ko/skills)
- [Claude Code Plugins](https://code.claude.com/docs/ko/plugins)

### 커뮤니티 리소스
- [Agent Skills 예제](https://github.com/agentskills/agentskills/tree/main/.claude/skills)
- [Skills Reference Library](https://github.com/agentskills/agentskills/tree/main/skills-ref)

---

## 요약

1. **Agent Skills는 오픈 표준**: Anthropic 주도, 커뮤니티 기여
2. **플랫폼 독립적**: Claude, ChatGPT, Gemini 모두 사용 가능
3. **폴더 기반**: SKILL.md + 지원 파일
4. **점진적 공개**: 효율적인 컨텍스트 관리
5. **카테고리화**: Infrastructure, Backend, Frontend, Documentation 등
6. **쉬운 공유**: Git으로 버전 관리 및 팀 공유

이 아키텍처를 따르면 모든 AI 에이전트에서 일관되게 사용 가능한 Skills 시스템을 구축할 수 있습니다.

