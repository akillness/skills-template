# ultrathink-multiagent-workflow

> Ralph Wiggum 기법 기반 멀티 에이전트 워크플로우 설계 원칙. Opus/Sonnet/Gemini/Codex를 조율하여 자율 개발 작업 수행.

## When to use this skill
• **대규모 코드베이스 분석**: 500+ 파일 분석
• **복잡한 구현 작업**: 아키텍처 결정, 디버깅
• **자율 개발 루프**: 장시간 무인 실행
• **멀티 모델 협업**: Opus, Sonnet, Gemini, Codex 통합

## Instructions
▶ S1: Ralph Wiggum 기법 이해
**핵심**: "Ralph is a Bash loop" - 완료까지 반복
**원리**: 파일시스템=상태, Git=메모리
```bash
while true; do
  claude --prompt "작업 계속. 완료시 COMPLETE"
  if grep -q "COMPLETE" output.log; then break; fi
done
```

▶ S2: Ultrathink (Opus Subagent)
| 에이전트 | 모델 | 역할 | 병렬 |
|---------|------|------|------|
| Ultrathink | Opus | 분석, 종합, 의사결정 | 1 |
| Worker | Sonnet | 검색, 구현 | 최대 500 |
| Executor | Codex | 빌드, 테스트 | 1 |
| Analyst | Gemini | 대용량 분석 | 1 |

▶ S3: 워크플로우
```
[Sonnet x500] src/* 분석 → [Sonnet x500] specs 비교
    → [Opus] Ultrathink 종합 → IMPLEMENTATION_PLAN.md
    → [Sonnet] 구현 → [Codex] 테스트 → 반복
```

▶ S4: IMPLEMENTATION_PLAN.md
```markdown
## Priority 1: Critical
- [ ] Fix auth bug
## Priority 2: High
- [ ] Add caching
## Completed
- [x] Setup project
```

▶ S5: 14 에이전트 시스템
**Core (9)**: Orchestrator, Planner, Coder, Reviewer, Tester, Debugger, Documenter, Refactorer, Deployer
**Auxiliary (5)**: Security, Performance, Dependency, Config, Adversarial

▶ S6: Context Preservation
```
.ralph/
├── ledger.json       # 상태 기록
├── handoffs/         # 인수인계
└── checkpoints/      # Git 스냅샷
```

▶ S7: Escape Hatches (비용 제어)
```bash
ralph-loop --max-iterations 50 --task "..."
ralph-loop --max-cost $10 --task "..."
ralph-loop --timeout 2h --task "..."
```

## Best Practices
1. 항상 max-iterations 설정
2. IMPLEMENTATION_PLAN.md 사용
3. Git 체크포인트 활용
4. Handoff 문서화
5. 적절한 모델 선택:
   - Opus: 복잡한 추론
   - Sonnet: 병렬 작업
   - Codex: 명령 실행
   - Gemini: 대용량 분석

## Constraints
• **MUST**: 비용 제어, 상태 저장, 역할 분리, 검증 단계
• **MUST NOT**: 무제한 루프, 단일 에이전트 독점, 컨텍스트 낭비

## References
- [VentureBeat - Ralph Wiggum AI](https://venturebeat.com/technology/how-ralph-wiggum-went-from-the-simpsons-to-the-biggest-name-in-ai-right-now)
- [ghuntley/how-to-ralph-wiggum](https://github.com/ghuntley/how-to-ralph-wiggum)
- [mikeyobrien/ralph-orchestrator](https://github.com/mikeyobrien/ralph-orchestrator)
