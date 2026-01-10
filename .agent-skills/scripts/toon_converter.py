#!/usr/bin/env python3
"""
TOON (Token-Oriented Object Notation) Converter
LLM 토큰 사용량 최적화를 위한 직렬화 포맷 변환기

Features:
- JSON ↔ TOON 양방향 변환
- SKILL.md → SKILL.toon 변환
- 30-60% 토큰 절감
- CLI 인터페이스

Usage:
    python toon_converter.py encode skills.json -o skills.toon
    python toon_converter.py decode skills.toon -o skills.json
    python toon_converter.py convert-skill backend/api-design
    python toon_converter.py convert-all
    python toon_converter.py stats skills.json
"""

import os
import re
import json
import argparse
from pathlib import Path
from typing import Dict, List, Optional, Any
from dataclasses import dataclass

SCRIPT_DIR = Path(__file__).parent
SKILLS_DIR = SCRIPT_DIR.parent


@dataclass
class TOONStats:
    """TOON 변환 통계"""
    original_chars: int
    toon_chars: int
    original_tokens: int  # 추정치
    toon_tokens: int  # 추정치

    @property
    def char_reduction(self) -> float:
        if self.original_chars == 0:
            return 0
        return (1 - self.toon_chars / self.original_chars) * 100

    @property
    def token_reduction(self) -> float:
        if self.original_tokens == 0:
            return 0
        return (1 - self.toon_tokens / self.original_tokens) * 100


class TOONConverter:
    """TOON 포맷 변환기"""

    # TOON 키 매핑
    KEY_MAP = {
        'name': 'N',
        'category': 'C',
        'description': 'D',
        'allowed_tools': 'T',
        'allowed-tools': 'T',
        'path': 'P',
        'tags': 'G',
        'platforms': 'F',
        'commands': 'X'
    }

    REVERSE_KEY_MAP = {v: k for k, v in KEY_MAP.items()}

    def __init__(self, delimiter: str = ',', list_sep: str = '|'):
        self.delimiter = delimiter
        self.list_sep = list_sep

    def estimate_tokens(self, text: str) -> int:
        """토큰 수 추정 (약 4자 = 1토큰)"""
        return len(text) // 4 + 1

    def encode_value(self, value: Any) -> str:
        """값을 TOON 문자열로 인코딩"""
        if isinstance(value, list):
            return self.list_sep.join(str(v) for v in value)
        elif isinstance(value, bool):
            return 'T' if value else 'F'
        elif isinstance(value, (int, float)):
            return str(value)
        elif value is None:
            return ''
        else:
            # 문자열: 구분자 포함시 인용
            s = str(value)
            if self.delimiter in s or self.list_sep in s or ' ' in s:
                return f'"{s}"'
            return s

    def decode_value(self, value: str, expected_type: str = 'str') -> Any:
        """TOON 문자열을 값으로 디코딩"""
        value = value.strip()

        # 인용 제거
        if value.startswith('"') and value.endswith('"'):
            value = value[1:-1]

        # 빈 값
        if not value:
            return None if expected_type != 'list' else []

        # 타입별 변환
        if expected_type == 'list':
            return value.split(self.list_sep)
        elif expected_type == 'bool':
            return value.upper() == 'T'
        elif expected_type == 'int':
            return int(value)
        elif expected_type == 'float':
            return float(value)
        else:
            return value

    def encode_skill(self, skill: Dict) -> str:
        """스킬 딕셔너리를 TOON 한 줄로 인코딩"""
        parts = []
        for key, short_key in self.KEY_MAP.items():
            if key in skill:
                value = self.encode_value(skill[key])
                parts.append(f"{short_key}:{value}")
        return ' '.join(parts)

    def decode_skill(self, line: str) -> Dict:
        """TOON 한 줄을 스킬 딕셔너리로 디코딩"""
        skill = {}
        # 패턴: KEY:VALUE (공백으로 구분, 인용 처리)
        pattern = r'([A-Z]):("(?:[^"\\]|\\.)*"|[^\s]+)'
        matches = re.findall(pattern, line)

        for short_key, value in matches:
            if short_key in self.REVERSE_KEY_MAP:
                full_key = self.REVERSE_KEY_MAP[short_key]
                # allowed_tools는 리스트
                if full_key in ('allowed_tools', 'allowed-tools', 'tags', 'platforms'):
                    skill[full_key] = self.decode_value(value, 'list')
                else:
                    skill[full_key] = self.decode_value(value, 'str')

        return skill

    def encode_skills_array(self, skills: List[Dict]) -> str:
        """스킬 배열을 TOON 포맷으로 인코딩"""
        lines = [
            f"# Skills Manifest (TOON Format)",
            f"# Count: {len(skills)}",
            f"# Fields: N=name, C=category, D=description, T=tools, P=path",
            ""
        ]

        for skill in skills:
            lines.append(self.encode_skill(skill))

        return '\n'.join(lines)

    def decode_skills_array(self, toon_str: str) -> List[Dict]:
        """TOON 포맷을 스킬 배열로 디코딩"""
        skills = []
        for line in toon_str.split('\n'):
            line = line.strip()
            # 주석과 빈 줄 스킵
            if not line or line.startswith('#'):
                continue
            skill = self.decode_skill(line)
            if skill:
                skills.append(skill)
        return skills

    def encode_manifest(self, manifest: Dict) -> str:
        """전체 매니페스트를 TOON으로 인코딩"""
        lines = [
            "# Skills Manifest (TOON Format)",
            f"# Version: {manifest.get('version', '1.0.0')}",
            f"# Generated: True",
            f"# Skill Count: {manifest.get('skill_count', len(manifest.get('skills', [])))}",
            ""
        ]

        # 카테고리 정보
        if 'categories' in manifest:
            lines.append("# Categories")
            for cat, skills in manifest['categories'].items():
                lines.append(f"#   {cat}: {len(skills)}")
            lines.append("")

        # 스킬 목록
        lines.append("# Skills")
        for skill in manifest.get('skills', []):
            lines.append(self.encode_skill(skill))

        return '\n'.join(lines)

    def get_stats(self, original: str, toon: str) -> TOONStats:
        """변환 통계 계산"""
        return TOONStats(
            original_chars=len(original),
            toon_chars=len(toon),
            original_tokens=self.estimate_tokens(original),
            toon_tokens=self.estimate_tokens(toon)
        )

    def convert_skill_file(self, skill_path: Path) -> str:
        """SKILL.md 파일을 TOON 형식으로 변환"""
        content = skill_path.read_text(encoding='utf-8')

        # YAML frontmatter 파싱
        frontmatter = self._parse_frontmatter(content)

        if not frontmatter:
            return ""

        return self.encode_skill(frontmatter)

    def _parse_frontmatter(self, content: str) -> Dict:
        """SKILL.md에서 YAML frontmatter 파싱"""
        lines = content.split('\n')

        if not lines or lines[0].strip() != '---':
            return {}

        end_idx = -1
        for i in range(1, len(lines)):
            if lines[i].strip() == '---':
                end_idx = i
                break

        if end_idx == -1:
            return {}

        result = {}
        for line in lines[1:end_idx]:
            if not line.strip() or line.startswith(' ') or line.startswith('\t'):
                continue
            if ':' in line:
                key, value = line.split(':', 1)
                key = key.strip()
                value = value.strip()

                # 리스트 처리
                if value.startswith('[') and value.endswith(']'):
                    value = [v.strip().strip('"\'') for v in value[1:-1].split(',')]
                elif value.startswith('"') or value.startswith("'"):
                    value = value.strip('"\'')

                if value:
                    result[key] = value

        return result


def main():
    parser = argparse.ArgumentParser(
        description='TOON (Token-Oriented Object Notation) Converter'
    )
    subparsers = parser.add_subparsers(dest='command', help='Commands')

    # encode command
    encode_parser = subparsers.add_parser('encode', help='JSON → TOON')
    encode_parser.add_argument('input', help='Input JSON file')
    encode_parser.add_argument('-o', '--output', help='Output TOON file')

    # decode command
    decode_parser = subparsers.add_parser('decode', help='TOON → JSON')
    decode_parser.add_argument('input', help='Input TOON file')
    decode_parser.add_argument('-o', '--output', help='Output JSON file')

    # convert-skill command
    convert_parser = subparsers.add_parser('convert-skill', help='Convert SKILL.md to TOON')
    convert_parser.add_argument('skill_path', help='Skill path (e.g., backend/api-design)')

    # convert-all command
    subparsers.add_parser('convert-all', help='Convert all skills to TOON manifest')

    # stats command
    stats_parser = subparsers.add_parser('stats', help='Show conversion statistics')
    stats_parser.add_argument('input', help='Input JSON file')

    args = parser.parse_args()
    converter = TOONConverter()

    if args.command == 'encode':
        with open(args.input, 'r', encoding='utf-8') as f:
            data = json.load(f)

        if 'skills' in data:
            toon = converter.encode_manifest(data)
        elif isinstance(data, list):
            toon = converter.encode_skills_array(data)
        else:
            toon = converter.encode_skill(data)

        if args.output:
            with open(args.output, 'w', encoding='utf-8') as f:
                f.write(toon)
            print(f"Encoded to: {args.output}")
        else:
            print(toon)

    elif args.command == 'decode':
        with open(args.input, 'r', encoding='utf-8') as f:
            toon = f.read()

        skills = converter.decode_skills_array(toon)
        result = json.dumps(skills, indent=2, ensure_ascii=False)

        if args.output:
            with open(args.output, 'w', encoding='utf-8') as f:
                f.write(result)
            print(f"Decoded to: {args.output}")
        else:
            print(result)

    elif args.command == 'convert-skill':
        skill_md = SKILLS_DIR / args.skill_path / 'SKILL.md'
        if skill_md.exists():
            toon = converter.convert_skill_file(skill_md)
            print(toon)
        else:
            print(f"Error: {skill_md} not found")

    elif args.command == 'convert-all':
        skills = []
        for skill_md in SKILLS_DIR.rglob('SKILL.md'):
            if 'templates' in str(skill_md):
                continue
            frontmatter = converter._parse_frontmatter(skill_md.read_text())
            if frontmatter:
                rel_path = skill_md.relative_to(SKILLS_DIR)
                frontmatter['path'] = str(rel_path.parent)
                skills.append(frontmatter)

        toon = converter.encode_skills_array(skills)
        output_path = SKILLS_DIR / 'skills.toon'
        output_path.write_text(toon, encoding='utf-8')
        print(f"Converted {len(skills)} skills to: {output_path}")

        # 통계
        json_str = json.dumps(skills, ensure_ascii=False)
        stats = converter.get_stats(json_str, toon)
        print(f"\nStatistics:")
        print(f"  Original: {stats.original_chars} chars ({stats.original_tokens} tokens est.)")
        print(f"  TOON: {stats.toon_chars} chars ({stats.toon_tokens} tokens est.)")
        print(f"  Reduction: {stats.char_reduction:.1f}% chars, {stats.token_reduction:.1f}% tokens")

    elif args.command == 'stats':
        with open(args.input, 'r', encoding='utf-8') as f:
            original = f.read()

        data = json.loads(original)
        if 'skills' in data:
            toon = converter.encode_manifest(data)
        elif isinstance(data, list):
            toon = converter.encode_skills_array(data)
        else:
            toon = converter.encode_skill(data)

        stats = converter.get_stats(original, toon)
        print(f"Token Reduction Statistics")
        print(f"==========================")
        print(f"Original: {stats.original_chars:,} chars ({stats.original_tokens:,} tokens est.)")
        print(f"TOON:     {stats.toon_chars:,} chars ({stats.toon_tokens:,} tokens est.)")
        print(f"Reduction: {stats.char_reduction:.1f}% chars, {stats.token_reduction:.1f}% tokens")

    else:
        parser.print_help()


if __name__ == '__main__':
    main()
