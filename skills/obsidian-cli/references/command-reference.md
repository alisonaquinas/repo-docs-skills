# Obsidian CLI — Command Reference

Requires Obsidian 1.12.7+ with CLI enabled in Settings → General → Command line interface.
Source of truth: `obsidian help` output on the installed version.

---

## Command Families

### General

| Command | Parameters | Effect |
|---|---|---|
| `help` | `[command]` | List all commands or show help for a specific command |
| `version` | — | Print CLI and app version |
| `reload` | — | Reload the app (soft restart) |
| `restart` | — | Full app restart |

```bash
obsidian help
obsidian help search
obsidian version
```

---

### Files and Folders

| Command | Key Parameters | Notes |
|---|---|---|
| `file` | `file=\|path=` | Show info about a file; returns empty output for non-existent paths (use as existence check) |
| `files` | `path=`, `total` | List files in folder |
| `folder` | `path=` | Show info about a folder |
| `folders` | `path=` | List folders |
| `open` | `file=\|path=`, `newtab`, `paneType=` | Open file in Obsidian; `paneType=` values vary by version — run `obsidian help open` to list accepted values |
| `create` | `file=\|path=`, `content=`, `overwrite`, `open` | Create a new file; `overwrite` flag silently replaces existing file |
| `read` | `file=\|path=`, `inline` | Read file contents to stdout |
| `append` | `file=\|path=`, `content=` | Append content to file |
| `prepend` | `file=\|path=`, `content=` | Prepend content to file |
| `move` | `file=\|path=`, `dest=` | Move a file |
| `rename` | `file=\|path=`, `name=` | Rename; `name=` is the new filename stem only (no path) |

**`file=` vs `path=`:**
- `file=` uses Obsidian name resolution (searches vault index; ambiguous if duplicate names exist)
- `path=` requires exact vault-root-relative path (preferred in scripts for determinism)

```bash
obsidian vault="Notes" create path="Projects/kickoff.md" content="# Kickoff\n\n- [ ] First task"
obsidian vault="Notes" read path="Projects/kickoff.md"
obsidian vault="Notes" append path="Projects/kickoff.md" content="- [ ] Second task"
obsidian vault="Notes" files path="Projects"

# Existence check before create (exit codes unreliable — check output instead)
if [[ -z "$(obsidian vault="Notes" file path="Projects/kickoff.md" 2>&1)" ]]; then
  obsidian vault="Notes" create path="Projects/kickoff.md" content="# Kickoff"
fi
```

---

### Search, Tags, Tasks

| Command | Key Parameters | Notes |
|---|---|---|
| `search` | `query=`, `path=`, `format=` | Full-text search; format=json\|csv\|tsv\|md\|paths |
| `search:context` | `query=`, `path=` | Search with surrounding context lines |
| `tags` | `counts`, `verbose` | List all tags in vault |
| `tag` | `query=`, `path=` | Files matching a tag (structured format output not confirmed; use `search query="#tag" format=json` for JSON output) |
| `tasks` | `daily`, `todo`, `done`, `status=`, `verbose`, `total` | Inspect tasks across vault |
| `task` | `file=\|path=`, `todo`, `done`, `status=` | Tasks in a specific file |

```bash
obsidian vault="Notes" search query="status::active" format=json
obsidian vault="Notes" search:context query="meeting notes" path="Projects"
obsidian vault="Notes" tags counts
obsidian vault="Notes" tasks daily todo verbose
obsidian vault="Notes" task path="Projects/kickoff.md" todo
```

---

### Daily Notes and History

| Command | Key Parameters | Notes |
|---|---|---|
| `daily` | `paneType=` | Open today's daily note |
| `daily:path` | — | Print path to today's daily note |
| `daily:read` | `inline` | Read today's daily note |
| `daily:append` | `content=` | Append to today's daily note |
| `daily:prepend` | `content=` | Prepend to today's daily note |
| `diff` | `file=\|path=`, `version=`, `from=`, `to=` | Show diff between file versions (`version=` is a version identifier; `from=`/`to=` are version range endpoints) |
| `history:*` | `file=\|path=`, `filter=local\|sync` | Browse file version history; run `obsidian help history` to list subcommands |

```bash
obsidian vault="Work" daily
obsidian vault="Work" daily:path
obsidian vault="Work" daily:append content="- [ ] Review inbox\n- [ ] Check calendar"
obsidian vault="Work" daily:read
```

---

### Sync and Bases

| Command | Key Parameters | Notes |
|---|---|---|
| `sync` | `on`, `off` | Enable/disable Obsidian Sync |
| `sync:*` | varies | Sync subcommands (status, pause, etc.); run `obsidian help sync` to list all |
| `bases` | — | List Bases |
| `base:views` | `name=` | List views in a Base |
| `base:create` | `name=`, `content=` | Create a Base |
| `base:query` | `name=`, `view=`, `format=json\|csv\|tsv\|md\|paths` | Query a Base |

```bash
obsidian vault="Notes" base:query name="Projects" view="Active" format=json
obsidian vault="Notes" bases

# Discover all sync subcommands on the installed version
obsidian help sync
```

---

### Templates, Themes, Workspace

| Command | Key Parameters | Notes |
|---|---|---|
| `templates` | — | List templates |
| `template:read` | `name=`, `resolve` | Read a template |
| `template:insert` | `name=`, `file=\|path=` | Insert template into file |
| `themes` | `versions`, `ids` | List available themes |
| `theme` | — | Current theme info |
| `theme:set` | `name=` | Switch active theme |
| `workspace:*` | `name=`, `ids`, `group=` | Workspace save/load/list; run `obsidian help workspace` to list subcommands |
| `tabs` | `group=` | List open tabs |
| `tab:open` | `file=\|path=`, `view=` | Open file in new tab |
| `recents` | — | Recently opened files |

```bash
obsidian vault="Notes" template:insert name="Daily Template" path="Notes/2026-04-17.md"
obsidian vault="Notes" theme:set name="Minimal"
obsidian vault="Notes" tabs

# Discover workspace subcommands (save, open, list, etc.)
obsidian help workspace
obsidian help history
```

---

### Developer and Plugin Tooling

| Command | Key Parameters | Notes |
|---|---|---|
| `devtools` | `on`, `off` | Toggle DevTools panel; `dev:*` commands may require this to be `on` first |
| `dev:debug` | `on`, `off` | Toggle debug mode |
| `dev:cdp` | `method=`, `params=` | Chrome DevTools Protocol call |
| `dev:errors` | `limit=` | Recent errors from DevTools console |
| `dev:screenshot` | `path=` | Save screenshot to file |
| `dev:console` | `level=`, `limit=` | DevTools console output |
| `dev:css` | `selector=`, `prop=` | Inspect computed CSS |
| `dev:dom` | `selector=`, `text` | Inspect DOM element |
| `plugin:reload` | `id=` | Reload a plugin by ID; the ID is the `id` field in the plugin's `manifest.json` and matches its folder name under `.obsidian/plugins/` |
| `eval` | `code=` | Evaluate JavaScript in app context |

```bash
# Enable DevTools first if dev:* commands return no output
obsidian vault="Plugin Dev" devtools on

obsidian vault="Plugin Dev" plugin:reload id=my-plugin
obsidian vault="Plugin Dev" dev:errors
obsidian vault="Plugin Dev" dev:console level=error limit=20
obsidian vault="Plugin Dev" dev:screenshot path="artifacts/snapshot.png"
obsidian vault="Plugin Dev" dev:dom selector=".workspace-leaf" text
```

> **Security note:** `eval`, `dev:cdp`, and `dev:debug` operate in the live app context with full plugin trust. Only use when the intent is explicit. `dev:cdp` can call arbitrary DevTools Protocol methods.

---

### Property / Frontmatter Commands

> **Not fully documented.** Official sources reference `property:set` in bug reports but do not publish
> the full property command family on the help page as of 1.12.7. To discover what property commands
> are available on your installed version:
>
> ```bash
> obsidian help | grep property
> obsidian help property:set
> ```
>
> **Caution:** `property:set` is known to silently no-op when the file was last written outside Obsidian
> (external-write race condition). Write the file through the CLI or wait for vault indexing before
> setting properties.

---

## Output and Flags

| Flag | Behavior |
|---|---|
| `--copy` | Copy command output to clipboard instead of stdout |
| `--help` | Alias for `help <command>` (since 1.12.2) |
| `format=json\|csv\|tsv\|md\|paths` | Structured output on supported commands (search, base:query) |

```bash
obsidian vault="Notes" search query="inbox" format=json --copy
```
