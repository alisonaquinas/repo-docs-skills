# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-04-17

### Added

- Initial plugin scaffold: `README.md`, `AGENTS.md`, `CLAUDE.md`, `.markdownlint-cli2.jsonc`, `.obsidian/` vault config.
- `docs/` llm-wiki skeleton: `index.md`, `roadmap.md`, `log.md`, `AGENTS.md`, `.obsidian-linter.jsonc`, placeholder directories (`raw/`, `adr/`, `plans/`, `superpowers/plans/`).
- Design spec at `docs/superpowers/specs/2026-04-17-skeleton-design.md`.
- Implementation plan at `docs/superpowers/plans/2026-04-17-skeleton.md`.
- `tests/unit/README.md` — living catalog of planned/authored/implemented unit tests.
- `skills/obsidian-cli/` — full control surface skill for the official Obsidian CLI (requires Obsidian 1.12.7+); covers all 7 command families with references for command lookup, syntax rules, and troubleshooting.
- CI/CD: `.github/workflows/ci.yml` (markdown, YAML, Python, skill lint/validate), `.github/workflows/release.yml` (tag-triggered release with marketplace dispatch).
- Build system: `Makefile`, `scripts/` (lint\_skills, validate\_skills, check\_node\_version, verify\_built\_zips).
- Plugin manifest: `.claude-plugin/plugin.json`.
