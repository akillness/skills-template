#!/usr/bin/env python3
"""
SKILL.md Standardization Script

Converts SKILL.md files to the standard format following CONTRIBUTING.md guidelines.
"""

import os
import re
import shutil
from pathlib import Path
from datetime import datetime

# Section heading mappings (Korean to English)
SECTION_MAPPINGS = {
    r'## 목적 \(Purpose\)': '## Purpose',  # Will be handled specially
    r'## 사용 시점 \(When to Use\)': '## When to use this skill',
    r'## 작업 절차 \(Procedure\)': '## Instructions',
    r'## 작업 예시 \(Examples\)': '## Examples',
    r'## 베스트 프랙티스 \(Best Practices\)': '## Best practices',
    r'## 참고 자료 \(References\)': '## References',
    r'## 출력 포맷 \(Output Format\)': '## Output format',
    r'## 제약사항 \(Constraints\)': '## Constraints',
    r'## 메타데이터': '## Metadata',
}

# Step heading mappings
STEP_MAPPINGS = {
    r'### (\d+)단계:': r'### Step \1:',
}

# Required sections templates
REQUIRED_SECTIONS = {
    '## Examples': '''## Examples

### Example 1: Basic usage
<!-- Add example content here -->

### Example 2: Advanced usage
<!-- Add advanced example content here -->
''',
    '## Best practices': '''## Best practices

1. **Follow conventions**: Adhere to established patterns
2. **Keep it simple**: Avoid over-engineering
3. **Test thoroughly**: Verify all edge cases
4. **Document clearly**: Make code self-explanatory
''',
    '## References': '''## References

- [Official Documentation](https://example.com/docs)
- [Best Practices Guide](https://example.com/guide)
'''
}


def backup_file(filepath: Path) -> Path:
    """Create a backup of the file (skip if permission denied)."""
    try:
        backup_dir = filepath.parent / '.backup'
        backup_dir.mkdir(exist_ok=True)
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_path = backup_dir / f"{filepath.stem}_{timestamp}.md"
        shutil.copy2(filepath, backup_path)
        return backup_path
    except PermissionError:
        # Skip backup if permission denied
        return None


def parse_frontmatter(content: str) -> tuple:
    """Parse YAML frontmatter and body separately."""
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            return parts[1].strip(), parts[2].strip()
    return '', content


def standardize_frontmatter(frontmatter: str) -> str:
    """Standardize frontmatter fields."""
    lines = frontmatter.split('\n')
    has_tags = any('tags:' in line for line in lines)
    has_platforms = any('platforms:' in line for line in lines)

    result_lines = []
    for line in lines:
        result_lines.append(line)

    if not has_tags:
        result_lines.append('tags: []')

    if not has_platforms:
        result_lines.append('platforms: [Claude, ChatGPT, Gemini]')

    return '\n'.join(result_lines)


def convert_sections(body: str) -> str:
    """Convert Korean section headings to English."""
    result = body

    # Convert section headings
    for korean, english in SECTION_MAPPINGS.items():
        result = re.sub(korean, english, result, flags=re.IGNORECASE)

    # Convert step headings
    for korean, english in STEP_MAPPINGS.items():
        result = re.sub(korean, english, result)

    return result


def handle_purpose_section(body: str) -> str:
    """Remove Purpose section if When to use exists, otherwise convert it."""
    # Check if both Purpose and When to use exist
    has_purpose = '## Purpose' in body or '## 목적' in body
    has_when_to_use = '## When to use this skill' in body or '## 사용 시점' in body

    if has_purpose and has_when_to_use:
        # Remove Purpose section (keep content as comment or merge)
        # Find Purpose section and remove it
        pattern = r'## Purpose\n\n(.*?)(?=\n##|\Z)'
        body = re.sub(pattern, '', body, flags=re.DOTALL)
    elif has_purpose and not has_when_to_use:
        # Convert Purpose to When to use
        body = body.replace('## Purpose', '## When to use this skill')

    return body


def add_missing_sections(body: str) -> str:
    """Add missing required sections."""
    # Check for existing sections (case-insensitive partial match)
    sections_to_add = []

    if not re.search(r'##\s*Examples', body, re.IGNORECASE):
        sections_to_add.append(('## Examples', REQUIRED_SECTIONS['## Examples']))

    if not re.search(r'##\s*Best practices', body, re.IGNORECASE):
        sections_to_add.append(('## Best practices', REQUIRED_SECTIONS['## Best practices']))

    if not re.search(r'##\s*References', body, re.IGNORECASE):
        sections_to_add.append(('## References', REQUIRED_SECTIONS['## References']))

    # Add missing sections at the end
    for section_name, template in sections_to_add:
        body = body.rstrip() + '\n\n' + template

    return body


def process_skill_file(filepath: Path) -> dict:
    """Process a single SKILL.md file."""
    result = {
        'path': str(filepath),
        'status': 'success',
        'changes': []
    }

    try:
        # Read original content
        with open(filepath, 'r', encoding='utf-8') as f:
            original_content = f.read()

        # Create backup (optional)
        backup_path = backup_file(filepath)
        if backup_path:
            result['backup'] = str(backup_path)

        # Parse frontmatter and body
        frontmatter, body = parse_frontmatter(original_content)

        # Standardize frontmatter
        new_frontmatter = standardize_frontmatter(frontmatter)
        if new_frontmatter != frontmatter:
            result['changes'].append('Standardized frontmatter')

        # Convert sections
        new_body = convert_sections(body)
        if new_body != body:
            result['changes'].append('Converted section headings')

        # Handle Purpose section
        new_body = handle_purpose_section(new_body)

        # Add missing sections
        final_body = add_missing_sections(new_body)
        if final_body != new_body:
            result['changes'].append('Added missing sections')

        # Reconstruct content
        new_content = f"---\n{new_frontmatter}\n---\n\n{final_body}"

        # Write updated content
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)

        if not result['changes']:
            result['changes'].append('No changes needed')

    except Exception as e:
        result['status'] = 'error'
        result['error'] = str(e)

    return result


def find_skill_files(root_dir: Path) -> list:
    """Find all SKILL.md files."""
    skill_files = []
    for path in root_dir.rglob('SKILL.md'):
        # Skip backup directories and templates
        if '.backup' not in str(path):
            skill_files.append(path)
    return sorted(skill_files)


def main():
    """Main entry point."""
    root_dir = Path('/Users/supercent/Documents/Github/skills-template/.agent-skills')

    print("=" * 60)
    print("SKILL.md Standardization Script")
    print("=" * 60)
    print(f"\nRoot directory: {root_dir}")

    # Find all SKILL.md files
    skill_files = find_skill_files(root_dir)
    print(f"Found {len(skill_files)} SKILL.md files\n")

    # Process each file
    results = []
    for filepath in skill_files:
        print(f"Processing: {filepath.relative_to(root_dir)}")
        result = process_skill_file(filepath)
        results.append(result)

        if result['status'] == 'success':
            print(f"  Status: OK")
            print(f"  Changes: {', '.join(result['changes'])}")
        else:
            print(f"  Status: ERROR - {result.get('error', 'Unknown error')}")
        print()

    # Summary
    print("=" * 60)
    print("Summary")
    print("=" * 60)
    success_count = sum(1 for r in results if r['status'] == 'success')
    error_count = sum(1 for r in results if r['status'] == 'error')
    print(f"Processed: {len(results)} files")
    print(f"Success: {success_count}")
    print(f"Errors: {error_count}")


if __name__ == '__main__':
    main()
