#!/usr/bin/env python3
"""
Final cleanup script to convert remaining Korean section headings to English.
"""

import re
from pathlib import Path

# Direct replacements for remaining Korean headings
REPLACEMENTS = [
    ('## 베스트 프랙티스', '## Best practices'),
    ('## 참고 자료', '## References'),
    ('## 목적 (Purpose)', '## Purpose'),
    ('## 사용 시점 (When to Use)', '## When to use this skill'),
    ('## 작업 절차 (Procedure)', '## Instructions'),
    ('## 작업 예시 (Examples)', '## Examples'),
    ('## 출력 포맷 (Output Format)', '## Output format'),
    ('## 제약사항 (Constraints)', '## Constraints'),
    ('## 메타데이터', '## Metadata'),
]


def clean_file(filepath: Path) -> bool:
    """Clean a single file. Returns True if changes were made."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content

    # Apply all replacements
    for korean, english in REPLACEMENTS:
        content = content.replace(korean, english)

    # Convert step headings
    content = re.sub(r'### (\d+)단계:', r'### Step \1:', content)

    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False


def main():
    root_dir = Path('/Users/supercent/Documents/Github/skills-template/.agent-skills')

    print("=" * 60)
    print("Final Cleanup Script")
    print("=" * 60)

    # Find all SKILL.md files
    skill_files = sorted(root_dir.rglob('SKILL.md'))
    skill_files = [f for f in skill_files if '.backup' not in str(f)]

    print(f"\nProcessing {len(skill_files)} files...\n")

    changed_count = 0
    for filepath in skill_files:
        rel_path = filepath.relative_to(root_dir)
        if clean_file(filepath):
            print(f"Updated: {rel_path}")
            changed_count += 1

    print(f"\n{changed_count} files updated.")


if __name__ == '__main__':
    main()
