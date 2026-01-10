#!/usr/bin/env python3
"""
Skill Manifest Builder for Claude + Codex-CLI Integration

This script scans all skills and generates a unified manifest
that can be used by Claude to dispatch commands to codex-cli.

Usage:
    python skill_manifest_builder.py [--output skills.json]
"""

import os
import glob
import json
import re
from pathlib import Path
from typing import Dict, List, Optional
from dataclasses import dataclass, asdict

SCRIPT_DIR = Path(__file__).parent
SKILL_ROOT_DIR = SCRIPT_DIR.parent  # .agent-skills directory
MANIFEST_PATH = SKILL_ROOT_DIR / "skills.json"



@dataclass
class SkillMetadata:
    """Skill metadata extracted from SKILL.md"""
    name: str
    description: str
    category: str
    path: str
    tags: List[str]
    platforms: List[str]
    allowed_tools: List[str]
    commands: List[Dict[str, str]]  # Executable commands for codex-cli


def parse_yaml_frontmatter(content: str) -> Dict:
    """Parse YAML frontmatter from SKILL.md content"""
    lines = content.split('\n')

    # Check if starts with ---
    if not lines or lines[0].strip() != '---':
        return {}

    # Find closing ---
    end_idx = -1
    for i in range(1, len(lines)):
        if lines[i].strip() == '---':
            end_idx = i
            break

    if end_idx == -1:
        return {}

    # Parse frontmatter lines
    frontmatter_lines = lines[1:end_idx]
    result = {}

    for line in frontmatter_lines:
        # Skip empty lines and indented lines (nested YAML)
        if not line.strip() or line.startswith(' ') or line.startswith('\t'):
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

            if value:  # Only add if value is not empty
                result[key] = value

    return result


def extract_commands_from_skill(content: str, skill_path: str) -> List[Dict[str, str]]:
    """Extract executable commands from SKILL.md"""
    commands = []

    # Extract bash code blocks
    bash_pattern = r'```(?:bash|shell|sh)\n(.*?)```'
    matches = re.findall(bash_pattern, content, re.DOTALL)

    for match in matches:
        for line in match.split('\n'):
            line = line.strip()
            # Skip comments and empty lines
            if line and not line.startswith('#') and not line.startswith('$'):
                # Clean up the command
                if line.startswith('$ '):
                    line = line[2:]
                commands.append({
                    "command": line,
                    "source": skill_path
                })

    return commands[:10]  # Limit to first 10 commands


def parse_skill_file(file_path: Path) -> Optional[SkillMetadata]:
    """Parse a SKILL.md file and extract metadata"""
    try:
        content = file_path.read_text(encoding='utf-8')
        frontmatter = parse_yaml_frontmatter(content)

        if not frontmatter:
            # Try alternative parsing - just extract name from first lines
            lines = content.split('\n')[:20]
            for line in lines:
                if line.startswith('name:'):
                    name = line.split(':', 1)[1].strip()
                    frontmatter = {'name': name}
                    break

        if not frontmatter:
            return None

        # Extract category from path
        rel_path = file_path.relative_to(SKILL_ROOT_DIR)
        parts = list(rel_path.parts)
        category = parts[0] if parts else "unknown"
        skill_name = parts[1] if len(parts) > 1 else frontmatter.get('name', 'unknown')

        # Extract commands
        commands = extract_commands_from_skill(content, str(rel_path))

        return SkillMetadata(
            name=frontmatter.get('name', skill_name),
            description=frontmatter.get('description', ''),
            category=category,
            path=str(rel_path),
            tags=frontmatter.get('tags', []),
            platforms=frontmatter.get('platforms', ['Claude']),
            allowed_tools=frontmatter.get('allowed-tools', []),
            commands=commands
        )
    except Exception as e:
        print(f"Error parsing {file_path}: {e}")
        return None


def build_skill_manifest() -> Dict:
    """Build complete skill manifest from all SKILL.md files"""
    skills = []
    categories = {}

    # Find all SKILL.md files
    skill_files = list(SKILL_ROOT_DIR.rglob("SKILL.md"))
    print(f"Found {len(skill_files)} skill files")

    for skill_file in skill_files:
        # Skip templates folder only (not skills-template project name)
        rel_path = skill_file.relative_to(SKILL_ROOT_DIR)
        if 'templates' in rel_path.parts:
            continue

        skill = parse_skill_file(skill_file)
        if skill:
            skills.append(asdict(skill))

            # Group by category
            if skill.category not in categories:
                categories[skill.category] = []
            categories[skill.category].append(skill.name)

    manifest = {
        "version": "1.0.0",
        "generated": True,
        "skill_count": len(skills),
        "categories": categories,
        "skills": skills,
        "codex_integration": {
            "description": "Use Claude to interpret skills, then execute commands via codex-cli",
            "workflow": [
                "1. Claude reads skill from manifest",
                "2. Claude generates execution plan",
                "3. codex-cli executes shell commands",
                "4. Claude analyzes results"
            ],
            "example_usage": "mcp__codex-cli__shell with command from skill"
        }
    }

    return manifest


def generate_claude_prompt(manifest: Dict) -> str:
    """Generate a Claude prompt template for skill-based execution"""
    skills_list = []
    for skill in manifest['skills']:
        skills_list.append(f"- **{skill['name']}** ({skill['category']}): {skill['description']}")

    prompt = f"""# Available Skills for Codex-CLI Integration

You have access to {manifest['skill_count']} skills that can be executed via codex-cli.

## Skills List
{chr(10).join(skills_list)}

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
"""
    return prompt


def main():
    """Main entry point"""
    print("Building skill manifest...")

    manifest = build_skill_manifest()

    # Save manifest
    with open(MANIFEST_PATH, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)

    print(f"Manifest saved to: {MANIFEST_PATH}")
    print(f"Total skills: {manifest['skill_count']}")
    print(f"Categories: {list(manifest['categories'].keys())}")

    # Generate Claude prompt
    prompt_path = SKILL_ROOT_DIR / "CLAUDE_CODEX_PROMPT.md"
    prompt = generate_claude_prompt(manifest)
    prompt_path.write_text(prompt, encoding='utf-8')
    print(f"Claude prompt saved to: {prompt_path}")

    return manifest


if __name__ == "__main__":
    main()
