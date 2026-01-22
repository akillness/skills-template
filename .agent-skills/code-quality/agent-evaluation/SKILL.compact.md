# agent-evaluation

> Design and implement comprehensive evaluation systems for AI agents. Use when building evals for coding agents, conversational agents, research age...

## When to use this skill
• Designing evaluation systems for AI agents
• Building benchmarks for coding, conversational, or research agents
• Creating graders (code-based, model-based, human)
• Implementing production monitoring for AI systems
• Setting up CI/CD pipelines with automated evals
• Debugging agent performance issues
• Measuring agent improvement over time

## Instructions
▶ S1: Understand Grader Types
#▶ Code-based Graders (Recommended for Coding Agents)
• **Pros**: Fast, objective, reproducible
• **Cons**: Requires clear success criteria
• **Best for**: Coding agents, structured outputs
#▶ Model-based Graders (LLM-as-Judge)
• **Pros**: Flexible, handles nuance
• **Cons**: Requires calibration, can be inconsistent
• **Best for**: Conversational agents, open-ended tasks
#▶ Human Graders
• **Pros**: Highest accuracy, catches edge cases
• **Cons**: Expensive, slow, not scalable
• **Best for**: Final validation, ambiguous cases
▶ S2: Choose Strategy by Agent Type
#▶ 2.1 Coding Agents
**Benchmarks**:
• SWE-bench Verified: Real GitHub issues (40% → 80%+ achievable)
• Terminal-Bench: Complex terminal tasks
• Custom test suites with your codebase
**Grading Strategy**:
**Key Metrics**:
• Test passage rate
• Build success
• Lint/style compliance
• Diff size (smaller is better)
#▶ 2.2 Conversational Agents
**Benchmarks**:
• τ2-Bench: Multi-domain conversation
• Custom domain-specific suites
**Grading Strategy** (Multi-dimensional):
**Key Metrics**:
• Task resolution rate
• Customer satisfaction proxy
• Turn efficiency
• Escalation rate
#▶ 2.3 Research Agents
**Grading Dimensions**:
1. **Grounding**: Claims backed by sources
2. **Coverage**: All aspects addressed
3. **Source Quality**: Authoritative sources used
#▶ 2.4 Computer Use Agents
**Benchmarks**:
• WebArena: Web navigation tasks
• OSWorld: Desktop environment tasks
**Grading Strategy**:
▶ S3: Follow the 8-SRoadmap
#▶ S0: Start Early (20-50 Tasks)
#▶ S1: Convert Manual Tests
#▶ S2: Ensure Clarity + Reference Solutions
#▶ S3: Balance Positive/Negative Cases
#▶ S4: Isolate Environments
#▶ S5: Focus on Outcomes, Not Paths
#▶ S6: Always Read Transcripts
#▶ S7: Monitor Eval Saturation
#▶ S8: Long-term Maintenance
▶ S4: Integrate with Production
#▶ CI/CD Integration
#▶ Production Monitoring
#▶ A/B Testing
