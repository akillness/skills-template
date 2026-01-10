# debugging

> Systematically debug code issues using proven methodologies. Use when encountering errors, unexpected behavior, or performance problems. Handles er...

## When to use this skill
• Encountering runtime errors or exceptions
• Code produces unexpected output or behavior
• Performance degradation or memory issues
• Intermittent or hard-to-reproduce bugs
• Understanding unfamiliar error messages
• Post-incident analysis and prevention

## Instructions
▶ S1: Gather Information
Collect all relevant context about the issue:
**Error details**:
• Full error message and stack trace
• Error type (syntax, runtime, logic, etc.)
• When did it start occurring?
• Is it reproducible?
**Environment**:
• Language and version
• Framework and dependencies
• OS and runtime environment
• Recent changes to code or config
▶ S2: Reproduce the Issue
Create a minimal, reproducible example:
▶ S3: Isolate the Problem
Use binary search debugging to narrow down the issue:
**Print/Log debugging**:
**Divide and conquer**:
▶ S4: Analyze Root Cause
Common bug patterns and solutions:
| Pattern | Symptom | Solution |
|---------|---------|----------|
| Off-by-one | Index out of bounds | Check loop bounds |
| Null reference | NullPointerException | Add null checks |
| Race condition | Intermittent failures | Add synchronization |
| Memory leak | Gradual slowdown | Check resource cleanup |
| Type mismatch | Unexpected behavior | Validate types |
**Questions to ask**:
1. What changed recently?
2. Does it fail with specific inputs?
3. Is it environment-specific?
4. Are there any patterns in failures?
▶ S5: Implement Fix
Apply the fix with proper verification:
**Fix checklist**:
• [ ] Addresses root cause, not just symptom
• [ ] Doesn't break existing functionality
• [ ] Handles edge cases
• [ ] Includes appropriate error handling
• [ ] Has test coverage
▶ S6: Verify and Prevent
Ensure the fix works and prevent regression:

## Best practices
1. Reproduce first
2. One change at a time
3. Read the error
4. Check assumptions
5. Use version control
