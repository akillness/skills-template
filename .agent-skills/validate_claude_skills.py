#!/usr/bin/env python3
"""
Claude Code Skills Validator

이 스크립트는 .claude/skills/ 디렉토리의 모든 SKILL.md 파일이
Claude Code 공식 스펙을 따르는지 검증합니다.

공식 문서: https://code.claude.com/docs/en/skills.md
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple
import yaml


class SkillValidator:
    """Claude Code 스킬 검증기"""

    REQUIRED_FIELDS = ['name', 'description']
    OPTIONAL_FIELDS = ['allowed-tools', 'model', 'license', 'compatibility', 'metadata']
    MAX_NAME_LENGTH = 64
    MAX_DESCRIPTION_LENGTH = 1024
    VALID_NAME_PATTERN = r'^[a-z0-9-]+$'

    def __init__(self, skills_dir: str):
        self.skills_dir = Path(skills_dir)
        self.errors = []
        self.warnings = []
        self.validated_count = 0

    def validate_all(self) -> bool:
        """모든 스킬 파일 검증"""
        print(f"\n🔍 Claude Code 스킬 검증 시작...")
        print(f"📂 검증 디렉토리: {self.skills_dir}\n")

        skill_files = list(self.skills_dir.rglob("SKILL.md"))

        if not skill_files:
            print(f"❌ 스킬 파일을 찾을 수 없습니다: {self.skills_dir}")
            return False

        print(f"📝 발견된 스킬 파일: {len(skill_files)}개\n")

        for skill_file in sorted(skill_files):
            self.validate_skill_file(skill_file)

        self.print_summary()
        return len(self.errors) == 0

    def validate_skill_file(self, file_path: Path):
        """개별 스킬 파일 검증"""
        relative_path = file_path.relative_to(self.skills_dir.parent)
        skill_name = file_path.parent.name

        print(f"  ├─ {relative_path}")

        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            # YAML frontmatter 추출
            frontmatter, markdown = self.extract_frontmatter(content, file_path)

            if frontmatter is None:
                return

            # YAML 파싱
            try:
                metadata = yaml.safe_load(frontmatter)
            except yaml.YAMLError as e:
                self.add_error(file_path, f"YAML 파싱 실패: {e}")
                return

            # 필수 필드 검증
            self.validate_required_fields(metadata, file_path)

            # name 필드 검증
            if 'name' in metadata:
                self.validate_name(metadata['name'], skill_name, file_path)

            # description 필드 검증
            if 'description' in metadata:
                self.validate_description(metadata['description'], file_path)

            # allowed-tools 검증
            if 'allowed-tools' in metadata:
                self.validate_allowed_tools(metadata['allowed-tools'], file_path)

            # Markdown 내용 검증
            self.validate_markdown_content(markdown, file_path)

            self.validated_count += 1
            print(f"    ✅ 검증 완료")

        except Exception as e:
            self.add_error(file_path, f"파일 읽기 실패: {e}")

    def extract_frontmatter(self, content: str, file_path: Path) -> Tuple[str, str]:
        """YAML frontmatter와 markdown 분리"""
        # frontmatter는 반드시 첫 줄부터 시작
        if not content.startswith('---'):
            self.add_error(file_path, "YAML frontmatter가 없습니다. 파일은 반드시 '---'로 시작해야 합니다.")
            return None, content

        # 첫 번째 ---를 제거하고 내용 시작
        content_without_first = content[3:]  # '---' 제거

        # 두 번째 --- 찾기 (줄 시작 부분에 있어야 함)
        lines = content_without_first.split('\n')
        frontmatter_lines = []
        markdown_lines = []
        found_end = False

        for line in lines:
            if not found_end:
                if line.strip() == '---':
                    found_end = True
                else:
                    frontmatter_lines.append(line)
            else:
                markdown_lines.append(line)

        if not found_end:
            self.add_error(file_path, "YAML frontmatter가 제대로 닫히지 않았습니다. '---'로 끝나야 합니다.")
            return None, content

        frontmatter = '\n'.join(frontmatter_lines).strip()
        markdown = '\n'.join(markdown_lines).strip()

        return frontmatter, markdown

    def validate_required_fields(self, metadata: Dict, file_path: Path):
        """필수 필드 검증"""
        for field in self.REQUIRED_FIELDS:
            if field not in metadata:
                self.add_error(file_path, f"필수 필드 '{field}'가 없습니다.")
            elif not metadata[field]:
                self.add_error(file_path, f"필수 필드 '{field}'가 비어있습니다.")

    def validate_name(self, name: str, dir_name: str, file_path: Path):
        """name 필드 검증"""
        # 길이 검증
        if len(name) > self.MAX_NAME_LENGTH:
            self.add_error(file_path, f"name이 너무 깁니다 (최대 {self.MAX_NAME_LENGTH}자): {len(name)}자")

        # 패턴 검증 (소문자, 숫자, 하이픈만)
        if not re.match(self.VALID_NAME_PATTERN, name):
            self.add_error(file_path, f"name은 소문자, 숫자, 하이픈만 사용 가능합니다: '{name}'")

        # 디렉토리 이름과 일치 여부 확인
        if name != dir_name:
            self.add_warning(file_path, f"name '{name}'이 디렉토리 이름 '{dir_name}'과 다릅니다. 일치시키는 것을 권장합니다.")

    def validate_description(self, description: str, file_path: Path):
        """description 필드 검증"""
        if len(description) > self.MAX_DESCRIPTION_LENGTH:
            self.add_error(file_path, f"description이 너무 깁니다 (최대 {self.MAX_DESCRIPTION_LENGTH}자): {len(description)}자")

        # description이 충분히 설명적인지 확인
        if len(description) < 20:
            self.add_warning(file_path, "description이 너무 짧습니다. 더 상세한 설명을 권장합니다.")

        # 트리거 키워드 포함 여부 확인
        trigger_keywords = ['use when', 'use for', 'handles', 'covers']
        has_trigger = any(keyword in description.lower() for keyword in trigger_keywords)

        if not has_trigger:
            self.add_warning(file_path,
                f"description에 트리거 키워드({', '.join(trigger_keywords)})를 포함하면 "
                "Claude가 스킬을 더 정확하게 활성화할 수 있습니다.")

    def validate_allowed_tools(self, tools, file_path: Path):
        """allowed-tools 필드 검증"""
        if not isinstance(tools, list):
            self.add_error(file_path, "allowed-tools는 배열이어야 합니다.")
            return

        # 일반적인 도구 목록
        common_tools = [
            'Read', 'Write', 'Edit', 'Grep', 'Glob', 'Bash',
            'WebFetch', 'WebSearch', 'python', 'node'
        ]

        for tool in tools:
            if tool not in common_tools:
                self.add_warning(file_path, f"'{tool}'은 일반적이지 않은 도구입니다. 의도한 것이 맞는지 확인하세요.")

    def validate_markdown_content(self, markdown: str, file_path: Path):
        """Markdown 내용 검증"""
        if not markdown:
            self.add_warning(file_path, "Markdown 내용이 비어있습니다.")
            return

        # 최소 길이 확인
        if len(markdown) < 100:
            self.add_warning(file_path, "Markdown 내용이 너무 짧습니다. 더 상세한 지침을 추가하세요.")

        # 500줄 이상이면 경고
        lines = markdown.split('\n')
        if len(lines) > 500:
            self.add_warning(file_path,
                f"Markdown 내용이 {len(lines)}줄로 너무 깁니다. "
                "공식 문서는 500줄 이하를 권장합니다. "
                "상세 내용은 별도 파일(reference.md, examples.md)로 분리하세요.")

        # 일반적인 섹션 확인
        recommended_sections = [
            ('# ', 'H1 제목'),
            ('## ', 'H2 섹션'),
        ]

        for pattern, name in recommended_sections:
            if pattern not in markdown:
                self.add_warning(file_path, f"{name}이 없습니다. 구조화된 내용을 권장합니다.")

    def add_error(self, file_path: Path, message: str):
        """에러 추가"""
        self.errors.append((file_path, message))
        print(f"    ❌ 에러: {message}")

    def add_warning(self, file_path: Path, message: str):
        """경고 추가"""
        self.warnings.append((file_path, message))
        print(f"    ⚠️  경고: {message}")

    def print_summary(self):
        """검증 결과 요약 출력"""
        print("\n" + "="*80)
        print("📊 검증 결과 요약")
        print("="*80)

        print(f"\n✅ 검증 완료: {self.validated_count}개")
        print(f"❌ 에러: {len(self.errors)}개")
        print(f"⚠️  경고: {len(self.warnings)}개")

        if self.errors:
            print("\n🔴 에러 상세:")
            for file_path, message in self.errors:
                print(f"  - {file_path.name}: {message}")

        if self.warnings:
            print("\n🟡 경고 상세:")
            for file_path, message in self.warnings:
                print(f"  - {file_path.name}: {message}")

        if not self.errors and not self.warnings:
            print("\n🎉 모든 스킬이 Claude Code 스펙을 완벽히 준수합니다!")
        elif not self.errors:
            print("\n✅ 모든 스킬이 필수 요구사항을 충족합니다. 경고는 개선 제안사항입니다.")
        else:
            print("\n❌ 일부 스킬에 수정이 필요합니다.")

        print("\n" + "="*80 + "\n")


def main():
    """메인 함수"""
    # 프로젝트 루트 찾기
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    claude_skills_dir = project_root / ".claude" / "skills"

    if not claude_skills_dir.exists():
        print(f"❌ .claude/skills 디렉토리를 찾을 수 없습니다: {claude_skills_dir}")
        print(f"   setup.sh를 먼저 실행하여 스킬을 설정하세요.")
        sys.exit(1)

    validator = SkillValidator(str(claude_skills_dir))
    success = validator.validate_all()

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
