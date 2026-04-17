---
title: Agent Guidance — repo-docs-skills docs
tags: [meta, agents, guidelines]
aliases: [agent instructions, docs agent guide]
---

# Agent Guidance — repo-docs-skills docs

This file governs how AI agents navigate, read, and extend the `docs/`
directory. Read this before touching any file in `docs/`.

> [!IMPORTANT]
> `docs/` is the llm-wiki for this repository. Its purpose is to reflect
> what exists in the repo (skills, hooks, commands, agents) and what is
> planned. Do not invent content — document what is real or what has been
> explicitly planned.

## docs/ as an llm-wiki

The pattern follows Karpathy's llm-wiki (2024): sources are immutable inputs;
the wiki is a persistent, compounding artifact maintained by LLM sessions.

| Directory | Purpose |
|---|---|
| `research/` | IMMUTABLE — raw research reports; not authored by wiki workflow |
| `raw/` | IMMUTABLE — unprocessed source drops; not authored by wiki workflow |
| `adr/` | Architecture Decision Records |
| `plans/` | Phase-by-phase implementation plans |
| `superpowers/specs/` | Brainstorm / design docs |
| `superpowers/plans/` | writing-plans output |

Top-level files: `index.md` (entry point), `roadmap.md` (delivery roadmap),
`log.md` (append-only update log).

## OFM Frontmatter Requirements

Every `.md` file in `docs/` (except `research/` and `raw/`) must begin with:

```yaml
---
title: <human-readable title>
tags: [<at least one tag>]
aliases: [<at least one alias>]
---
```

## Tag Prefix Conventions

| Prefix | Used for |
|---|---|
| `meta` | Root docs files (`index.md`, `roadmap.md`, `log.md`, `AGENTS.md`) |
| `adr` | ADR files (add the ADR number as a second tag, e.g. `adr001`) |
| `plans` | Phase plan files |
| `superpowers` | Design specs and plan files under `superpowers/` |

## Wikilink Format

All cross-references inside `docs/` use `[[wikilink]]` syntax.
The link target is the file stem relative to `docs/` — no full paths,
no `.md` extension.

Examples:
- Correct: `[[index]]`
- Correct: `[[adr/ADR001-foo]]`
- Incorrect: `[index](./index.md)`
- Incorrect: `[[docs/index.md]]`

## log.md Protocol

`docs/log.md` is **append-only**. Each entry:

```
## YYYY-MM-DD — <one-line summary>

- <bullet describing what changed in the wiki>
```

Never edit or delete a past entry.

## Immutability of research/ and raw/

Do not add YAML frontmatter to files in `research/` or `raw/`.
Do not add wikilinks from inside those directories pointing into the wiki.
The wiki may link *to* research files but not the reverse.

## Quality Gates

Before adding a new docs page:
- [ ] YAML frontmatter present with all three fields
- [ ] All cross-references use `[[wikilink]]` syntax
- [ ] New page linked from `[[index]]` navigation table
- [ ] Entry added to `[[log]]`

## Parallel Agent Guidelines

- Agents must not modify `docs/index.md` or `docs/log.md` simultaneously.
- ADR numbers are sequential; coordinate to avoid numbering conflicts.
- `docs/AGENTS.md` (this file) is stable — coordinate before changing it.

## Related

- [[index]]
- [[roadmap]]
- [[log]]
