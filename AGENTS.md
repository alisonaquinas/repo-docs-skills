# AGENTS.md — Guide for AI Agents Working in this Repository

Claude Code plugin providing skills, hooks, commands, and agents for
well-structured software project documentation. The repository dog-foods
its own conventions: `docs/` is the live reference wiki.

## Layout

```text
repo-docs-skills/
├── README.md                    # terse project description
├── AGENTS.md                    # this file
├── CLAUDE.md                    # stub → AGENTS.md
├── .markdownlint-cli2.jsonc     # vanilla markdownlint (excludes docs/)
├── .obsidian/                   # Obsidian vault config (vault root = repo root)
└── docs/
    ├── AGENTS.md                # docs-layer agent rules
    ├── index.md                 # llm-wiki entry point
    ├── roadmap.md               # phased delivery roadmap
    ├── log.md                   # append-only wiki-update log
    ├── .obsidian-linter.jsonc   # OFM lint config (scoped to docs/**)
    ├── research/                # IMMUTABLE — raw research drops
    ├── raw/                     # IMMUTABLE — future unprocessed sources
    ├── adr/                     # Architecture Decision Records
    ├── plans/                   # phase-by-phase implementation plans
    └── superpowers/
        ├── specs/               # brainstorm design docs
        └── plans/               # writing-plans output
```

## Linting Split

| Scope | Config | Tool |
|---|---|---|
| `**/*.md` outside `docs/` | `.markdownlint-cli2.jsonc` | vanilla markdownlint |
| `docs/**/*.md` | `docs/.obsidian-linter.jsonc` | markdownlint-obsidian (OFM) |

These regimes must not overlap. `.markdownlint-cli2.jsonc` ignores `docs/**`.

## Obsidian Vault

`.obsidian/` sits at the repo root, making the entire repository the Obsidian
vault. OFM linting is scoped to `docs/**` only; the vault boundary and the
linting boundary are intentionally different.

## Source Boundary — Immutability Rule

Everything outside `docs/` is an **immutable input** from this wiki's
perspective. `docs/` describes those artifacts — it never replaces or alters
them. `docs/research/` and `docs/raw/` are also immutable inputs.

## Branching

This repository follows git-flow.

| Branch | Purpose |
|---|---|
| `main` | stable, released |
| `develop` | integration branch — day-to-day work |
| `feature/*` | feature branches off `develop` |

## Invariants — Do Not Violate

- Every `.md` file in `docs/` (except `research/` and `raw/`) must have YAML
  frontmatter with `title`, `tags`, and `aliases`.
- All cross-references inside `docs/` use `[[wikilink]]` syntax — no relative
  Markdown links.
- `docs/log.md` is append-only. Never edit existing entries.
- Do not add content to `docs/research/` or `docs/raw/` unless dropping a new
  immutable source. Never author wiki content there.
- Do not edit files outside `docs/` from within a wiki-maintenance workflow.

## Workflows

### Adding a docs page

1. Create the file in the appropriate `docs/<section>/` directory.
2. Add YAML frontmatter (`title`, `tags`, `aliases`).
3. Link to it from `docs/index.md` navigation table.
4. Add an entry to `docs/log.md`.

### Adding an ADR

1. Create `docs/adr/ADR<NNN>-<kebab-title>.md` (sequential, zero-padded).
2. Add YAML frontmatter and full ADR content.
3. Link from `docs/index.md` ADR section.

## See Also

- [docs/AGENTS.md](docs/AGENTS.md)
- [docs/index.md](docs/index.md)
