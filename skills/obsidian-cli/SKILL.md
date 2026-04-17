---
name: obsidian-cli
description: >
  Use this skill when the user wants to automate or control the Obsidian desktop app
  using the official `obsidian` CLI command (requires Obsidian 1.12.7+). Covers the
  full command surface: note CRUD (create/read/append/prepend/move/rename), vault
  search and querying, daily note automation, task and tag inspection, Bases queries,
  template insertion, theme switching, workspace and tab management, Sync control, file
  history and diffs, plugin reload, DevTools access (dev:cdp, dev:console, dev:screenshot,
  dev:dom), and JavaScript evaluation (eval). Also use when diagnosing CLI setup issues,
  platform registration problems (macOS symlink, Windows shim, Linux Flatpak), or
  exit-code and quoting edge cases in automation scripts. NOT for Obsidian Headless
  (server-side Sync/Publish without a GUI).
---

# Obsidian CLI

The official `obsidian` CLI controls the running Obsidian desktop app from a terminal.
It is a **GUI-aware automation layer**, not a headless vault parser — it requires the
desktop app and executes commands inside the live app context.

## Intent Router

| Task | Load |
|---|---|
| Look up a command, parameter name, or example | `references/command-reference.md` |
| Understand syntax rules, `vault=` placement, `file=` vs `path=` | `references/syntax-rules.md` |
| Debug setup, platform registration, or known bugs | `references/troubleshooting.md` |

---

## Quick Reference

### Syntax at a glance

```bash
obsidian [vault="<name>"] <command> [param=value ...] [--flag]
```

- `vault=` must be **first** if present
- Named args use `parameter=value`, not `--flag value`
- `path=` (vault-root-relative) is preferred over `file=` (name-resolved) in scripts
- `--copy` sends output to clipboard; `--help` shows help for a command
- Newlines in `content=` are encoded as `\n`
- **Exit codes are unreliable** — validate stdout/stderr content, not just exit status
- **Requires the GUI app running** — cron jobs and headless CI environments will silently fail unless Obsidian is already open with a display; use `obsidian-headless` for server contexts

### 7 command families

| Family | Representative commands |
|---|---|
| General | `help`, `version`, `reload`, `restart` |
| Files & folders | `file`, `files`, `open`, `create`, `read`, `append`, `prepend`, `move`, `rename` |
| Search / tags / tasks | `search`, `search:context`, `tags`, `tag`, `tasks`, `task` |
| Daily notes & history | `daily`, `daily:path`, `daily:read`, `daily:append`, `daily:prepend`, `diff`, `history:*` |
| Sync & Bases | `sync`, `sync:*`, `bases`, `base:views`, `base:create`, `base:query` |
| Templates / themes / workspace | `templates`, `template:insert`, `theme:set`, `workspace:*`, `tabs`, `tab:open`, `recents` |
| Developer & plugin | `devtools`, `dev:cdp`, `dev:errors`, `dev:screenshot`, `dev:console`, `dev:css`, `dev:dom`, `plugin:reload`, `eval` |

---

## Common Patterns

### Availability check

```bash
obsidian version
# → prints version string (e.g., "1.12.7"); "command not found" means CLI not registered
```

### Daily note automation

```bash
obsidian vault="Work" daily
obsidian vault="Work" daily:append content="- [ ] Review inbox\n- [ ] Check calendar"
obsidian vault="Work" tasks daily todo verbose
obsidian vault="Work" tags counts
```

### Vault query and export

```bash
obsidian vault="Notes" search query="status::active" format=json
obsidian vault="Notes" base:query name="Projects" view="Active" format=json
obsidian vault="Notes" search:context query="meeting notes" path="Projects"
```

### File CRUD

```bash
obsidian vault="Notes" create path="Projects/kickoff.md" content="# Kickoff\n\n- [ ] First task" open
obsidian vault="Notes" append path="Projects/kickoff.md" content="- [ ] Second task"
obsidian vault="Notes" read path="Projects/kickoff.md"
obsidian vault="Notes" move path="Projects/kickoff.md" dest="Archive/kickoff.md"
```

### Plugin development loop

```bash
obsidian vault="Plugin Dev" plugin:reload id=my-plugin
obsidian vault="Plugin Dev" dev:errors
obsidian vault="Plugin Dev" dev:console level=error limit=20
obsidian vault="Plugin Dev" dev:screenshot path="artifacts/snapshot.png"
```

### Safer output validation (exit codes unreliable)

```bash
OUTPUT=$(obsidian vault="Notes" read path="expected.md" 2>&1)
if [[ -z "$OUTPUT" ]]; then
  echo "ERROR: expected output was empty" >&2
  exit 1
fi
```

---

## Safety Matrix

| Operation | Risk | Required before use |
|---|---|---|
| `eval code="..."` | Executes arbitrary JS in live app context with full plugin trust | Explicit user intent to run code in app |
| `dev:cdp method=... params=...` | Arbitrary Chrome DevTools Protocol call; can affect app state | Explicit user intent for CDP access |
| `dev:debug on` | Enables debug mode in running app | Explicit user intent |
| `move`, `rename` | Permanent file location change; not undone by CLI | Confirm destination; note Obsidian updates wikilinks but external tools may not |
| `create ... overwrite` | Overwrites existing file silently | Confirm file does not exist or user intends to overwrite |

For `eval` and `dev:cdp`: if the user has not explicitly asked to run code or invoke CDP methods, do not generate these commands. Ask for confirmation.

---

## Resource Index

| File | Contents | Load when |
|---|---|---|
| `references/command-reference.md` | Full command tables with parameters and examples for all 7 families | Looking up a command, parameter, or syntax form |
| `references/syntax-rules.md` | 8 cross-cutting syntax rules: `vault=` placement, `parameter=value`, `file=` vs `path=`, exit codes, quoting, multiline encoding, availability check, `eval`/`dev:cdp` guard | Authoring automation scripts or debugging unexpected behavior |
| `references/troubleshooting.md` | Issue classes table, first-response sequence, platform setup (macOS/Windows/Linux), Desktop CLI vs. Headless distinction | Setup failures, platform registration, known bugs |
