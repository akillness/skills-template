#!/usr/bin/env python3
"""
Compact Skill Generator - Token Optimization Tool

Generates token-optimized versions of SKILL.md files:
- SKILL.compact.md: 60-70% token reduction
- SKILL.toon: 85% token reduction (extended TOON format)

Usage:
    python generate_compact_skills.py                    # Generate all
    python generate_compact_skills.py --skill backend/api-design
    python generate_compact_skills.py --stats           # Show statistics
    python generate_compact_skills.py --clean           # Remove generated files
"""

import os
import re
import sys
import argparse
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass

SCRIPT_DIR = Path(__file__).parent
SKILLS_DIR = SCRIPT_DIR.parent

# Sections to keep in compact format
ESSENTIAL_SECTIONS = [
    'When to use this skill',
    'Instructions',
]

# Sections to exclude
EXCLUDE_SECTIONS = [
    'References',
    'Additional Resources',
    'Version History',
    'Troubleshooting',
    'Common Issues',
]

# TOON key mappings for extended format
TOON_KEYS = {
    'name': 'N',
    'description': 'D',
    'tags': 'G',
    'platforms': 'F',
    'rules': 'R',
    'steps': 'S',
    'methods': 'M',
    'codes': 'C',
    'examples': 'E',
    'tools': 'T',
}


@dataclass
class SkillStats:
    """Statistics for skill conversion"""
    original_chars: int
    compact_chars: int
    toon_chars: int
    original_tokens: int
    compact_tokens: int
    toon_tokens: int

    @property
    def compact_reduction(self) -> float:
        return (1 - self.compact_tokens / self.original_tokens) * 100 if self.original_tokens else 0

    @property
    def toon_reduction(self) -> float:
        return (1 - self.toon_tokens / self.original_tokens) * 100 if self.original_tokens else 0


class CompactSkillGenerator:
    """Generate compact and TOON versions of skills"""

    def __init__(self, skills_dir: Path = SKILLS_DIR):
        self.skills_dir = skills_dir

    def estimate_tokens(self, text: str) -> int:
        """Estimate token count (~4 chars = 1 token for English/code)"""
        return max(1, len(text) // 4)

    def parse_frontmatter(self, content: str) -> Tuple[Dict, str]:
        """Parse YAML frontmatter and return (metadata, body)"""
        lines = content.split('\n')
        if not lines or lines[0].strip() != '---':
            return {}, content

        end_idx = -1
        for i in range(1, len(lines)):
            if lines[i].strip() == '---':
                end_idx = i
                break

        if end_idx == -1:
            return {}, content

        metadata = {}
        for line in lines[1:end_idx]:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            if ':' in line:
                key, value = line.split(':', 1)
                key = key.strip()
                value = value.strip()
                # Handle lists
                if value.startswith('[') and value.endswith(']'):
                    value = [v.strip().strip('"\'') for v in value[1:-1].split(',')]
                elif value.startswith('"') or value.startswith("'"):
                    value = value.strip('"\'')
                metadata[key] = value

        body = '\n'.join(lines[end_idx + 1:])
        return metadata, body

    def extract_sections(self, content: str) -> Dict[str, str]:
        """Extract markdown sections (## headers)"""
        sections = {}
        current_section = None
        current_content = []

        for line in content.split('\n'):
            if line.startswith('## '):
                if current_section:
                    sections[current_section] = '\n'.join(current_content).strip()
                current_section = line[3:].strip()
                current_content = []
            elif line.startswith('# ') and not current_section:
                # Skip main title
                continue
            else:
                current_content.append(line)

        if current_section:
            sections[current_section] = '\n'.join(current_content).strip()

        return sections

    def compress_instructions(self, content: str) -> str:
        """Compress instruction content while preserving meaning"""
        lines = []
        in_code_block = False

        for line in content.split('\n'):
            # Track code blocks
            if line.strip().startswith('```'):
                in_code_block = not in_code_block
                # Skip code blocks in compact mode
                if in_code_block:
                    continue
                else:
                    continue

            if in_code_block:
                continue

            # Skip empty lines
            if not line.strip():
                continue

            # Keep headers
            if line.startswith('###'):
                lines.append(line.replace('### ', '▶ ').replace('Step ', 'S'))
                continue

            # Compress bullet points
            if line.strip().startswith('- ') or line.strip().startswith('* '):
                compressed = line.strip()[2:].strip()
                # Remove verbose phrases
                compressed = re.sub(r'^(You should|Make sure to|Always|Consider|Remember to)\s+', '', compressed, flags=re.I)
                if compressed:
                    lines.append(f"• {compressed}")
                continue

            # Keep numbered items
            if re.match(r'^\d+\.', line.strip()):
                lines.append(line.strip())
                continue

            # Skip long explanatory paragraphs
            if len(line) > 100 and not line.startswith('#'):
                continue

            lines.append(line.strip())

        return '\n'.join(lines)

    def generate_compact(self, skill_path: Path) -> str:
        """Generate compact version of skill"""
        content = skill_path.read_text(encoding='utf-8')
        metadata, body = self.parse_frontmatter(content)
        sections = self.extract_sections(body)

        # Build compact content
        lines = [
            f"# {metadata.get('name', 'Skill')}",
            "",
        ]

        # Add minimal metadata
        if metadata.get('description'):
            desc = metadata['description']
            # Truncate long descriptions
            if len(desc) > 150:
                desc = desc[:147] + '...'
            lines.append(f"> {desc}")
            lines.append("")

        # Add essential sections only
        for section_name in ESSENTIAL_SECTIONS:
            if section_name in sections:
                content = sections[section_name]
                compressed = self.compress_instructions(content)
                if compressed:
                    lines.append(f"## {section_name}")
                    lines.append(compressed)
                    lines.append("")

        # Add Best practices if exists (compressed)
        if 'Best practices' in sections:
            content = sections['Best practices']
            # Extract just the numbered items
            practices = re.findall(r'\d+\.\s+\*\*([^*]+)\*\*', content)
            if practices:
                lines.append("## Best practices")
                for i, p in enumerate(practices[:5], 1):  # Max 5
                    lines.append(f"{i}. {p.strip()}")
                lines.append("")

        return '\n'.join(lines)

    def generate_toon_extended(self, skill_path: Path) -> str:
        """Generate extended TOON format for skill"""
        content = skill_path.read_text(encoding='utf-8')
        metadata, body = self.parse_frontmatter(content)
        sections = self.extract_sections(body)

        lines = []

        # Header
        lines.append(f"N:{metadata.get('name', 'skill')}")

        # Description (abbreviated)
        desc = metadata.get('description', '')
        if desc:
            if len(desc) > 100:
                desc = desc[:97] + '...'
            lines.append(f"D:{desc}")

        # Tags
        tags = metadata.get('tags', [])
        if isinstance(tags, list):
            lines.append(f"G:{' '.join(tags[:5])}")

        # Extract when to use
        when_section = sections.get('When to use this skill', '')
        if when_section:
            uses = re.findall(r'[-•]\s*(.+)', when_section)
            if uses:
                lines.append(f"U[{len(uses)}]:")
                for use in uses[:5]:
                    lines.append(f"  {use.strip()[:60]}")

        # Extract instructions as steps
        instructions = sections.get('Instructions', '')
        if instructions:
            steps = re.findall(r'###\s+(?:Step\s+)?(\d+)[:\s]+(.+)', instructions)
            if steps:
                lines.append(f"S[{len(steps)}]{{n,action}}:")
                for num, action in steps[:8]:
                    action_clean = action.strip()[:50]
                    lines.append(f"  {num},{action_clean}")

        # Extract key rules/patterns from content
        rules = []
        for line in instructions.split('\n'):
            if line.strip().startswith('- ') and ':' in line:
                rule = line.strip()[2:].split(':')[0].strip()
                if len(rule) < 40:
                    rules.append(rule)

        if rules:
            lines.append(f"R[{len(rules[:6])}]:")
            for rule in rules[:6]:
                lines.append(f"  {rule}")

        return '\n'.join(lines)

    def process_skill(self, skill_path: Path) -> SkillStats:
        """Process a single skill and generate compact versions"""
        original = skill_path.read_text(encoding='utf-8')
        compact = self.generate_compact(skill_path)
        toon = self.generate_toon_extended(skill_path)

        # Write compact version
        compact_path = skill_path.parent / 'SKILL.compact.md'
        compact_path.write_text(compact, encoding='utf-8')

        # Write TOON version
        toon_path = skill_path.parent / 'SKILL.toon'
        toon_path.write_text(toon, encoding='utf-8')

        return SkillStats(
            original_chars=len(original),
            compact_chars=len(compact),
            toon_chars=len(toon),
            original_tokens=self.estimate_tokens(original),
            compact_tokens=self.estimate_tokens(compact),
            toon_tokens=self.estimate_tokens(toon),
        )

    def process_all(self) -> Dict[str, SkillStats]:
        """Process all skills"""
        results = {}
        for skill_md in self.skills_dir.rglob('SKILL.md'):
            # Skip templates
            if 'templates' in str(skill_md):
                continue

            rel_path = skill_md.relative_to(self.skills_dir)
            skill_name = str(rel_path.parent)

            try:
                stats = self.process_skill(skill_md)
                results[skill_name] = stats
                print(f"✓ {skill_name}: {stats.compact_reduction:.0f}% compact, {stats.toon_reduction:.0f}% toon")
            except Exception as e:
                print(f"✗ {skill_name}: {e}")

        return results

    def clean_generated(self):
        """Remove all generated compact and toon files"""
        count = 0
        for pattern in ['SKILL.compact.md', 'SKILL.toon']:
            for f in self.skills_dir.rglob(pattern):
                if 'templates' not in str(f):
                    f.unlink()
                    count += 1
        return count

    def print_stats(self, results: Dict[str, SkillStats]):
        """Print summary statistics"""
        if not results:
            print("No skills processed")
            return

        total_original = sum(s.original_tokens for s in results.values())
        total_compact = sum(s.compact_tokens for s in results.values())
        total_toon = sum(s.toon_tokens for s in results.values())

        print("\n" + "=" * 60)
        print("TOKEN OPTIMIZATION SUMMARY")
        print("=" * 60)
        print(f"\nSkills processed: {len(results)}")
        print(f"\nOriginal total:  {total_original:,} tokens")
        print(f"Compact total:   {total_compact:,} tokens ({(1-total_compact/total_original)*100:.1f}% reduction)")
        print(f"TOON total:      {total_toon:,} tokens ({(1-total_toon/total_original)*100:.1f}% reduction)")
        print("\nPer-skill averages:")
        print(f"  Original: {total_original//len(results):,} tokens")
        print(f"  Compact:  {total_compact//len(results):,} tokens")
        print(f"  TOON:     {total_toon//len(results):,} tokens")


def main():
    parser = argparse.ArgumentParser(
        description='Generate token-optimized skill files',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python generate_compact_skills.py              # Generate all
  python generate_compact_skills.py --skill backend/api-design
  python generate_compact_skills.py --stats      # Show statistics only
  python generate_compact_skills.py --clean      # Remove generated files
        """
    )
    parser.add_argument('--skill', help='Process specific skill (e.g., backend/api-design)')
    parser.add_argument('--stats', action='store_true', help='Show statistics after processing')
    parser.add_argument('--clean', action='store_true', help='Remove generated files')
    parser.add_argument('--dry-run', action='store_true', help='Show what would be done')

    args = parser.parse_args()
    generator = CompactSkillGenerator()

    if args.clean:
        count = generator.clean_generated()
        print(f"Removed {count} generated files")
        return

    if args.skill:
        skill_path = SKILLS_DIR / args.skill / 'SKILL.md'
        if not skill_path.exists():
            print(f"Error: {skill_path} not found")
            sys.exit(1)

        if args.dry_run:
            print(f"Would process: {args.skill}")
            compact = generator.generate_compact(skill_path)
            toon = generator.generate_toon_extended(skill_path)
            print("\n--- COMPACT ---")
            print(compact[:500] + "..." if len(compact) > 500 else compact)
            print("\n--- TOON ---")
            print(toon)
        else:
            stats = generator.process_skill(skill_path)
            print(f"Generated compact ({stats.compact_reduction:.0f}% reduction)")
            print(f"Generated TOON ({stats.toon_reduction:.0f}% reduction)")
    else:
        print("Generating compact skills...")
        print("-" * 60)
        results = generator.process_all()

        if args.stats or True:  # Always show stats
            generator.print_stats(results)


if __name__ == '__main__':
    main()
