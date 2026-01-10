# Available Skills for Codex-CLI Integration

You have access to 34 skills that can be executed via codex-cli.

## Skills List
- **technical-writing** (documentation): Write clear, comprehensive technical documentation. Use when creating specs, architecture docs, runbooks, API docs, or any technical documentation. Follows industry best practices for clarity and structure.
- **changelog-maintenance** (documentation): Maintain a clear and informative changelog for software releases. Use when documenting version changes, tracking features, or communicating updates to users. Handles semantic versioning, changelog formats, and release notes.
- **user-guide-writing** (documentation): Write clear and helpful user guides and tutorials for end users. Use when creating onboarding docs, how-to guides, or FAQ pages. Handles user-focused documentation, screenshots, step-by-step instructions.
- **api-documentation** (documentation): Create comprehensive API documentation for developers. Use when documenting REST APIs, GraphQL schemas, or SDK methods. Handles OpenAPI/Swagger, interactive docs, examples, and API reference guides.
- **responsive-design** (frontend): Create responsive web designs that work across all devices and screen sizes. Use when building mobile-first layouts, implementing breakpoints, or optimizing for different viewports. Handles CSS Grid, Flexbox, media queries, viewport units, and responsive images.
- **ui-component-patterns** (frontend): Build reusable, maintainable UI components following modern design patterns. Use when creating component libraries, implementing design systems, or building scalable frontend architectures. Handles React patterns, composition, prop design, TypeScript, and component best practices.
- **web-accessibility** (frontend): Implement web accessibility (a11y) standards following WCAG 2.1 guidelines. Use when building accessible UIs, fixing accessibility issues, or ensuring compliance with disability standards. Handles ARIA attributes, keyboard navigation, screen readers, semantic HTML, and accessibility testing.
- **state-management** (frontend): Implement state management patterns for frontend applications. Use when managing global state, handling complex data flows, or coordinating state across components. Handles React Context, Redux, Zustand, Recoil, and state management best practices.
- **sprint-retrospective** (project-management): Facilitate effective sprint retrospectives for continuous team improvement. Use when conducting team retrospectives, identifying improvements, or fostering team collaboration. Handles retrospective formats, action items, and facilitation techniques.
- **standup-meeting** (project-management): Conduct effective daily standup meetings for agile teams. Use when facilitating standups, tracking blockers, or improving team synchronization. Handles standup format, time management, and blocker resolution.
- **task-planning** (project-management): Plan and organize software development tasks effectively. Use when breaking down features, creating user stories, or planning sprints. Handles task breakdown, user stories, acceptance criteria, and backlog management.
- **task-estimation** (project-management): Estimate software development tasks accurately using various techniques. Use when planning sprints, roadmaps, or project timelines. Handles story points, t-shirt sizing, planning poker, and estimation best practices.
- **authentication-setup** (backend): Design and implement authentication and authorization systems. Use when setting up user login, JWT tokens, OAuth, session management, or role-based access control. Handles password security, token management, SSO integration.
- **backend-testing** (backend): Write comprehensive backend tests including unit tests, integration tests, and API tests. Use when testing REST APIs, database operations, authentication flows, or business logic. Handles Jest, Pytest, Mocha, testing strategies, mocking, and test coverage.
- **database-schema-design** (backend): Design and optimize database schemas for SQL and NoSQL databases. Use when creating new databases, designing tables, defining relationships, indexing strategies, or database migrations. Handles PostgreSQL, MySQL, MongoDB, normalization, and performance optimization.
- **api-design** (backend): Design RESTful and GraphQL APIs following best practices. Use when creating new APIs, refactoring existing endpoints, or documenting API specifications. Handles OpenAPI, REST, GraphQL, versioning.
- **mcp-codex-integration** (utilities): Integrate and use codex-cli MCP server effectively with Claude Code. Use when executing shell commands, running builds, or performing file operations through the codex-cli MCP tool. Handles skill loading, command execution, and result processing.
- **environment-configuration** (utilities): Configure and manage development, staging, and production environments. Use when setting up environment variables, managing configurations, or separating environments. Handles .env files, config management, and environment-specific settings.
- **git-workflow** (utilities): Manage Git workflows including commits, branches, merges, and collaboration. Use when working with Git repositories, creating commits, managing branches, or resolving conflicts.
- **workflow-automation** (utilities): Automate repetitive development tasks and workflows. Use when creating build scripts, automating deployments, or setting up development workflows. Handles npm scripts, Makefile, GitHub Actions workflows, and task automation.
- **project-file-organization** (utilities): Organize project files and folders for maintainability and scalability. Use when structuring new projects, refactoring folder structure, or establishing conventions. Handles project structure, naming conventions, and file organization best practices.
- **testing-strategies** (code-quality): Design comprehensive testing strategies for software quality assurance. Use when planning test coverage, implementing test pyramids, or setting up testing infrastructure. Handles unit testing, integration testing, E2E testing, TDD, and testing best practices.
- **code-review** (code-quality): Conduct thorough, constructive code reviews. Use when reviewing pull requests, checking code quality, or providing feedback on code. Covers best practices, common issues, security, performance, and testing.
- **code-refactoring** (code-quality): Improve code structure, readability, and maintainability without changing functionality. Use when simplifying complex code, removing duplication, or applying design patterns. Handles Extract Method, DRY principle, SOLID principles, and refactoring patterns.
- **performance-optimization** (code-quality): Optimize application performance for speed, efficiency, and scalability. Use when improving page load times, reducing bundle size, optimizing database queries, or fixing performance bottlenecks. Handles React optimization, lazy loading, caching, code splitting, and profiling.
- **log-analysis** (search-analysis): Analyze application logs to identify errors, performance issues, and security anomalies. Use when debugging issues, monitoring system health, or investigating incidents. Handles various log formats including Apache, Nginx, application logs, and JSON logs.
- **data-analysis** (search-analysis): Analyze datasets to extract insights, identify patterns, and generate reports. Use when exploring data, creating visualizations, or performing statistical analysis. Handles CSV, JSON, SQL queries, and Python pandas operations.
- **codebase-search** (search-analysis): Search and navigate large codebases efficiently. Use when finding specific code patterns, tracing function calls, understanding code structure, or locating bugs. Handles semantic search, grep patterns, AST analysis.
- **pattern-detection** (search-analysis): Detect patterns, anomalies, and trends in code and data. Use when identifying code smells, finding security vulnerabilities, or discovering recurring patterns. Handles regex patterns, AST analysis, and statistical anomaly detection.
- **deployment-automation** (infrastructure): Automate application deployment to cloud platforms and servers. Use when setting up CI/CD pipelines, deploying to Docker/Kubernetes, or configuring cloud infrastructure. Handles GitHub Actions, Docker, Kubernetes, AWS, Vercel, and deployment best practices.
- **firebase-ai-logic** (infrastructure): Integrate Firebase AI Logic (Gemini in Firebase) for intelligent app features. Use when adding AI capabilities to Firebase apps, implementing generative AI features, or setting up Firebase AI SDK. Handles Firebase AI SDK setup, prompt engineering, and AI-powered features.
- **security-best-practices** (infrastructure): Implement security best practices for web applications and infrastructure. Use when securing APIs, preventing common vulnerabilities, or implementing security policies. Handles HTTPS, CORS, XSS, SQL Injection, CSRF, rate limiting, and OWASP Top 10.
- **system-environment-setup** (infrastructure): Configure development and production environments for consistent and reproducible setups. Use when setting up new projects, Docker environments, or development tooling. Handles Docker Compose, .env configuration, dev containers, and infrastructure as code.
- **monitoring-observability** (infrastructure): Set up monitoring, logging, and observability for applications and infrastructure. Use when implementing health checks, metrics collection, log aggregation, or alerting systems. Handles Prometheus, Grafana, ELK Stack, Datadog, and monitoring best practices.

## Execution Pattern
1. Read the relevant skill using: Read tool with skill path
2. Analyze the skill content and extract appropriate commands
3. Execute commands using: mcp__codex-cli__shell
4. Analyze results and report to user

## Example
User: "Docker 환경 설정해줘"
1. Load skill: infrastructure/system-environment-setup/SKILL.md
2. Extract command: docker-compose up -d
3. Execute via codex-cli
4. Report results
