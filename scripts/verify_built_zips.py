#!/usr/bin/env python3
"""Verify built skill ZIPs exist and open cleanly."""

from __future__ import annotations

import argparse
import zipfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
REQUIRED_FILES = ["SKILL.md", "agents/claude.yaml", "agents/openai.yaml"]


def discover_skills(skills_root: Path) -> list[str]:
    return sorted(path.parent.name for path in skills_root.glob("*/SKILL.md"))


def expected_zip_paths(build_dir: Path, skills_root: Path) -> list[Path]:
    return [build_dir / f"{skill}-skill.zip" for skill in discover_skills(skills_root)]


def verify_zip(path: Path) -> tuple[bool, str]:
    if not path.exists():
        return False, 'missing'
    try:
        with zipfile.ZipFile(path, 'r') as zf:
            bad_member = zf.testzip()
            names = {name.replace("\\", "/") for name in zf.namelist()}
    except zipfile.BadZipFile:
        return False, 'invalid zip'
    if bad_member is not None:
        return False, f'corrupt member: {bad_member}'
    if not names:
        return False, 'empty zip'

    repo_name = path.parent.parent.name
    skill_name = path.stem.replace("-skill", "")
    missing = []
    for rel_path in REQUIRED_FILES:
        expected = f"{repo_name}/skills/{skill_name}/{rel_path}"
        if expected not in names:
            missing.append(expected)
    if missing:
        return False, 'missing members: ' + ', '.join(sorted(missing))
    return True, 'valid'


def run(build_dir: Path, skills_root: Path) -> int:
    if not build_dir.exists():
        print(f"Error: {build_dir} does not exist. Run 'make build' first.")
        return 1

    print('Verifying ZIP files...')
    failures = 0
    for zip_path in expected_zip_paths(build_dir, skills_root):
        ok, detail = verify_zip(zip_path)
        if ok:
            print(f"  [OK] {zip_path.as_posix()}")
            print('      Valid ZIP')
        else:
            print(f"  [MISSING] {zip_path.as_posix()} ({detail})")
            failures += 1
    return 1 if failures else 0


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Verify plugin ZIP artifacts.")
    parser.add_argument("--build-dir", default="built", help="Build directory containing *-skill.zip files")
    parser.add_argument("--skills-dir", default="skills", help="Directory containing skill folders")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    build_dir = (REPO_ROOT / args.build_dir).resolve()
    skills_root = (REPO_ROOT / args.skills_dir).resolve()
    return run(build_dir, skills_root)


if __name__ == '__main__':
    raise SystemExit(main())
