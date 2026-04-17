# Design: repo-docs-skills Repository Skeleton

**Date:** 2026-04-17
**Status:** Approved
**Author:** Claude (brainstorming session)

---

## Context

`repo-docs-skills` is a Claude Code plugin that provides skills, hooks, commands, and
agents for maintaining well-structured software project documentation. The plugin
dog-foods its own documentation conventions: the repository itself is the reference
implementation of the pattern it teaches.

The repository currently contains one file: `docs/research/Obsidian CLI Deep Research
Report.md`. Everything else must be scaffolded.

---

## Goals

1. Establish the root scaffolding (`README.md`, `AGENTS.md`, `CLAUDE.md`, linting config).
2. Create the `docs/` wiki skeleton following the llm-wiki pattern (Karpathy, 2024) and
   the `flavor-grenade-lsp` / `obsidian-linter` conventions used across this superproject.
3. Wire up vanilla markdownlint for everything outside `docs/` and OFM-aware linting
   inside `docs/`.
4. Open the `docs/` tree as an Obsidian vault via `.obsidian/` config.

---

## Non-Goals

- No skill files are authored in this pass.
- No CI/CD workflows.
- No full DDD / requirements / BDD layers (out of scope for bones-only pass).

---

## File Tree

```
repo-docs-skills/
├── README.md                        # terse project description; "start at docs/index"
├── AGENTS.md                        # root LLM guidance: layout, invariants, workflows
├── CLAUDE.md                        # stub → AGENTS.md
├── .markdownlint-cli2.jsonc         # vanilla markdownlint; ignores docs/**
├── .obsidian/                       # vault config so docs tree opens in Obsidian
│   ├── app.json
│   ├── appearance.json
│   └── core-plugins.json
└── docs/
    ├── AGENTS.md                    # docs-layer agent rules: OFM, frontmatter, wikilinks
    ├── index.md                     # llm-wiki entry point: overview + navigation table
    ├── roadmap.md                   # phased delivery roadmap (stub)
    ├── log.md                       # append-only chronological wiki-update log
    ├── .obsidian-linter.jsonc       # OFM lint config scoped to docs/**
    ├── research/                    # IMMUTABLE — raw research drops (existing CLI report lives here)
    ├── raw/                         # IMMUTABLE — future unprocessed source material
    │   └── .gitkeep
    ├── adr/                         # Architecture Decision Records
    │   └── .gitkeep
    ├── plans/                       # phase-by-phase implementation plans
    │   └── .gitkeep
    └── superpowers/
        ├── specs/                   # brainstorm / design docs (this file lives here)
        └── plans/                   # writing-plans output
            └── .gitkeep
```

---

## Key Invariants

### Source boundary

Everything outside `docs/` is an **immutable input**. `docs/` describes those artifacts;
it does not replace or alter them. `docs/research/` and `docs/raw/` are also immutable
inputs — they receive content, they are not authored by the wiki workflow.

### Linting split

| Scope | Tool | Config |
|---|---|---|
| `**/*.md` outside `docs/` | vanilla markdownlint | `.markdownlint-cli2.jsonc` |
| `docs/**/*.md` | markdownlint-obsidian (OFM-aware) | `docs/.obsidian-linter.jsonc` |

`.markdownlint-cli2.jsonc` must include `{ "ignorePatterns": ["docs/**"] }` so the two
linting regimes do not overlap.

### OFM conventions (docs/ only)

Every file under `docs/` (excluding `docs/raw/` and `docs/research/`) must:

- Begin with YAML frontmatter containing `title`, `tags`, and `aliases`.
- Use `[[wikilink]]` syntax for all internal cross-references (no relative Markdown links).
- Use tag prefix conventions matching the directory name (e.g., `adr`, `plans`, `meta`).

### log.md

`docs/log.md` is **append-only**. Each entry uses the format:

```
## YYYY-MM-DD — <one-line summary>

- <bullet describing what changed in the wiki>
```

Entries are never edited after the session ends.

---

## AGENTS.md Content Summary

### Root AGENTS.md

Covers: repo purpose, file layout table, linting split, docs/ immutability rules,
branching (git-flow: `main` / `develop`), invariants, see-also links.

### docs/AGENTS.md

Covers: docs purpose and llm-wiki pattern reference, directory layout, OFM frontmatter
requirements, wikilink format rules, tag prefix conventions, immutability of
`research/` and `raw/`, log.md protocol, quality gates, parallel agent guidelines.

---

## Implementation Sequence

1. Create root files: `README.md`, `AGENTS.md`, `CLAUDE.md`, `.markdownlint-cli2.jsonc`
2. Create `.obsidian/` vault config files
3. Create `docs/AGENTS.md`
4. Create `docs/index.md` (OFM, with frontmatter + navigation table)
5. Create `docs/roadmap.md` (OFM stub)
6. Create `docs/log.md` (OFM, first entry for this scaffolding session)
7. Create `docs/.obsidian-linter.jsonc`
8. Create placeholder `.gitkeep` files for `raw/`, `adr/`, `plans/`, `superpowers/plans/`
9. Commit all scaffolding on `develop`
