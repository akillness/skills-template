# code-review

> Conduct thorough, constructive code reviews for quality and security. Use when reviewing pull requests, checking code quality, identifying bugs, or...

## When to use this skill
• Reviewing pull requests
• Checking code quality
• Providing feedback on implementations
• Identifying potential bugs
• Suggesting improvements
• Security audits
• Performance analysis

## Instructions
▶ S1: Understand the context
**Read the PR description**:
• What is the goal of this change?
• Which issues does it address?
• Are there any special considerations?
**Check the scope**:
• How many files changed?
• What type of changes? (feature, bugfix, refactor)
• Are tests included?
▶ S2: High-level review
**Architecture and design**:
• Does the approach make sense?
• Is it consistent with existing patterns?
• Are there simpler alternatives?
• Is the code in the right place?
**Code organization**:
• Clear separation of concerns?
• Appropriate abstraction levels?
• Logical file/folder structure?
▶ S3: Detailed code review
**Naming**:
• [ ] Variables: descriptive, meaningful names
• [ ] Functions: verb-based, clear purpose
• [ ] Classes: noun-based, single responsibility
• [ ] Constants: UPPER_CASE for true constants
• [ ] Avoid abbreviations unless widely known
**Functions**:
• [ ] Single responsibility
• [ ] Reasonable length (< 50 lines ideally)
• [ ] Clear inputs and outputs
• [ ] Minimal side effects
• [ ] Proper error handling
**Classes and objects**:
• [ ] Single responsibility principle
• [ ] Open/closed principle
• [ ] Liskov substitution principle
• [ ] Interface segregation
• [ ] Dependency inversion
**Error handling**:
• [ ] All errors caught and handled
• [ ] Meaningful error messages
• [ ] Proper logging
• [ ] No silent failures
• [ ] User-friendly errors for UI
**Code quality**:
• [ ] No code duplication (DRY)
• [ ] No dead code
• [ ] No commented-out code
• [ ] No magic numbers
• [ ] Consistent formatting
▶ S4: Security review
**Input validation**:
• [ ] All user inputs validated
• [ ] Type checking
• [ ] Range checking
• [ ] Format validation
**Authentication & Authorization**:
• [ ] Proper authentication checks
• [ ] Authorization for sensitive operations
• [ ] Session management
• [ ] Password handling (hashing, salting)
**Data protection**:
• [ ] No hardcoded secrets
• [ ] Sensitive data encrypted
• [ ] SQL injection prevention
• [ ] XSS prevention
• [ ] CSRF protection
**Dependencies**:
• [ ] No vulnerable packages
• [ ] Dependencies up-to-date
• [ ] Minimal dependency usage
▶ S5: Performance review
**Algorithms**:
• [ ] Appropriate algorithm choice
• [ ] Reasonable time complexity
• [ ] Reasonable space complexity
• [ ] No unnecessary loops
**Database**:
• [ ] Efficient queries
• [ ] Proper indexing
• [ ] N+1 query prevention
• [ ] Connection pooling
**Caching**:
• [ ] Appropriate caching strategy
• [ ] Cache invalidation handled
• [ ] Memory usage reasonable
**Resource management**:
• [ ] Files properly closed
• [ ] Connections released
• [ ] Memory leaks prevented
▶ S6: Testing review
**Test coverage**:
• [ ] Unit tests for new code
• [ ] Integration tests if needed
• [ ] Edge cases covered
• [ ] Error cases tested
**Test quality**:
• [ ] Tests are readable
• [ ] Tests are maintainable
• [ ] Tests are deterministic
• [ ] No test interdependencies
• [ ] Proper test data setup/teardown
**Test naming**:
▶ S7: Documentation review
**Code comments**:
• [ ] Complex logic explained
• [ ] No obvious comments
• [ ] TODOs have tickets
• [ ] Comments are accurate
**Function documentation**:
**README/docs**:
• [ ] README updated if needed
• [ ] API docs updated
• [ ] Migration guide if breaking changes
▶ S8: Provide feedback
**Be constructive**:
**Be specific**:
**Prioritize issues**:
• 🔴 Critical: Security, data loss, major bugs
• 🟡 Important: Performance, maintainability
• 🟢 Nice-to-have: Style, minor improvements
**Acknowledge good work**:

## Best practices
1. Review promptly
2. Be respectful
3. Explain why
4. Suggest alternatives
5. Use examples
