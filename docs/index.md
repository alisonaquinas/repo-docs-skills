---
title: repo-docs-skills — Project Overview
tags: [meta, wiki, overview]
aliases: [repo-docs-skills index, docs home, wiki home]
---

# repo-docs-skills

> A Claude Code plugin providing skills, hooks, commands, and agents for
> well-structured software project documentation.

## What is repo-docs-skills?

repo-docs-skills is a Claude Code plugin that helps software projects
maintain living, accurate documentation. It provides:

- **Skills** — reusable Claude instructions for documentation workflows
- **Hooks** — automated documentation gates in CI and commit flows
- **Commands** — slash commands for common documentation tasks
- **Agents** — multi-step documentation agents (audit, generate, sync)

The repository dog-foods the conventions it teaches: `docs/` is maintained
as an llm-wiki that always reflects the plugin's current state.

## Documentation Pattern

Following the [llm-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f):

| Layer | Location | Role |
|---|---|---|
| Sources | Everything outside `docs/` | Immutable inputs; never edited by the wiki |
| Raw drops | `docs/raw/`, `docs/research/` | Immutable; ingested into the wiki |
| Wiki | `docs/**` (all other files) | Persistent, compounding artifact |

The wiki describes what exists in the sources. It does not replace them.

## Navigation

| Section | Description |
|---|---|
| [[roadmap]] | Phased delivery roadmap |
| [[log]] | Append-only wiki-update log |
| [[AGENTS]] | Agent guidance for this docs directory |
| `adr/` | _(no content yet)_ |
| `plans/` | _(no content yet)_ |
| `superpowers/specs/` | [[superpowers/specs/2026-04-17-skeleton-design]] — skeleton design |
| `superpowers/plans/` | _(no content yet)_ |
| `research/` | Raw research — see directory for files |

## Project Status

**Scaffolding phase.** No skill files exist yet. The wiki skeleton is being
established before any plugin content is authored.

> [!NOTE]
> All wikilinks use `[[target]]` syntax relative to `docs/`. If a linked
> document does not exist, it is a documentation gap to fill before
> authoring related plugin content.
