#!/usr/bin/env python3
"""
Remove duplicate sections from SKILL.md files.
Keeps the first occurrence of each section if it has content,
otherwise keeps the template version.
"""

import re
from pathlib import Path


def remove_duplicate_sections(content: str) -> str:
    """Remove duplicate Examples, Best practices, and References sections."""

    # Pattern to find sections and their content
    section_pattern = r'^(##\s+(Examples|Best practices|References|베스트 프랙티스|참고 자료))\s*\n((?:(?!^##\s).*\n)*)'

    # Track which sections we've seen
    seen_sections = {}

    def replace_duplicate(match):
        full_match = match.group(0)
        section_name = match.group(2).lower()
        section_content = match.group(3).strip()

        # Normalize section names
        if section_name in ['베스트 프랙티스']:
            section_name = 'best practices'
        elif section_name in ['참고 자료']:
            section_name = 'references'

        # Check if this is a template section (has placeholder comments)
        is_template = '<!-- Add' in section_content or section_content.count('\n') < 3

        if section_name in seen_sections:
            # We've seen this section before
            prev_is_template = seen_sections[section_name]['is_template']

            if prev_is_template and not is_template:
                # Current one has content, previous was template - keep current
                seen_sections[section_name] = {
                    'content': full_match,
                    'is_template': is_template
                }
                return ''  # Remove previous (already processed)
            else:
                # Keep the previous one, remove this one
                return ''
        else:
            # First occurrence
            seen_sections[section_name] = {
                'content': full_match,
                'is_template': is_template
            }
            return full_match

    # Process content - we need a different approach since regex doesn't handle this well
    lines = content.split('\n')
    result_lines = []
    current_section = None
    current_section_name = None
    current_section_lines = []
    section_contents = {}  # name -> (start_line_content, content_lines, is_template)

    i = 0
    while i < len(lines):
        line = lines[i]

        # Check if this is a section header
        section_match = re.match(r'^##\s+(Examples|Best practices|References|베스트 프랙티스|참고 자료)\s*$', line, re.IGNORECASE)

        if section_match:
            section_name = section_match.group(1).lower()

            # Normalize names
            if section_name == '베스트 프랙티스':
                section_name = 'best practices'
            elif section_name == '참고 자료':
                section_name = 'references'

            # Collect section content
            section_start = i
            section_lines = [line]
            i += 1

            while i < len(lines) and not re.match(r'^##\s+', lines[i]):
                section_lines.append(lines[i])
                i += 1

            section_content = '\n'.join(section_lines[1:]).strip()
            is_template = '<!-- Add' in section_content or '<!-- TODO' in section_content

            if section_name not in section_contents:
                # First occurrence - keep it
                section_contents[section_name] = True
                result_lines.extend(section_lines)
            else:
                # Duplicate - skip if template, otherwise skip if previous had content
                if not is_template:
                    # This one has content but we already have one - skip
                    pass
                # Either way, skip this duplicate
        else:
            result_lines.append(line)
            i += 1

    return '\n'.join(result_lines)


def clean_file(filepath: Path) -> dict:
    """Clean a single file."""
    result = {'path': str(filepath), 'status': 'success', 'changes': []}

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            original = f.read()

        cleaned = remove_duplicate_sections(original)

        # Also remove extra blank lines
        cleaned = re.sub(r'\n{4,}', '\n\n\n', cleaned)

        # Remove trailing whitespace on lines
        cleaned = '\n'.join(line.rstrip() for line in cleaned.split('\n'))

        if cleaned != original:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(cleaned)
            result['changes'].append('Removed duplicate sections')
        else:
            result['changes'].append('No duplicates found')

    except Exception as e:
        result['status'] = 'error'
        result['error'] = str(e)

    return result


def main():
    root_dir = Path('/Users/supercent/Documents/Github/skills-template/.agent-skills')

    print("=" * 60)
    print("Duplicate Section Removal Script")
    print("=" * 60)

    # Find all SKILL.md files
    skill_files = sorted(root_dir.rglob('SKILL.md'))
    skill_files = [f for f in skill_files if '.backup' not in str(f)]

    print(f"\nProcessing {len(skill_files)} files...\n")

    for filepath in skill_files:
        result = clean_file(filepath)
        rel_path = filepath.relative_to(root_dir)
        print(f"{rel_path}: {', '.join(result['changes'])}")

    print("\nDone!")


if __name__ == '__main__':
    main()
