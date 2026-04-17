# Obsidian CLI — Syntax Rules

Critical rules for automation. Violations cause silent failures.

---

## Rule 1: `vault=` Must Be First

If specifying a vault, `vault=` must be the **first** argument after the command name.

```bash
# Correct
obsidian vault="Work" daily:append content="- [ ] Task"

# Wrong — vault= after other params breaks vault selection
obsidian daily:append vault="Work" content="- [ ] Task"
```

Omit `vault=` only when you intend to use whichever vault is currently active in the running app.

---

## Rule 2: `parameter=value` Syntax (Not Flags)

The CLI uses `parameter=value` for named arguments, not `--flag value` or `--flag=value`.

```bash
# Correct
obsidian vault="Notes" search query="status::active" format=json

# Wrong
obsidian --vault "Notes" search --query "status::active" --format json
```

Exception: `--copy` and `--help` are documented `--flag` style. Since 1.12.2, unrecognized `--` flags are silently ignored — typos in long flags will not produce errors.

---

## Rule 3: `file=` vs `path=`

| Parameter | Resolution | Use when |
|---|---|---|
| `file=` | Obsidian name resolution — searches vault index by name | Vault has unique filenames; interactive use |
| `path=` | Exact vault-root-relative path | Scripts; avoids ambiguity when duplicate names exist |

Prefer `path=` in automation. `file=` on a non-unique name may resolve to the wrong file without error.

---

## Rule 4: Exit Codes Are Not Reliable

`set -e` is **not sufficient** for detecting CLI failures. Forum reports confirm failures can exit `0` and print to stdout.

```bash
# Unreliable — script may continue on CLI failure
set -e
obsidian vault="Notes" create path="out.md" content="..."

# Safer — validate output content
OUTPUT=$(obsidian vault="Notes" read path="expected.md" 2>&1)
if [[ -z "$OUTPUT" ]]; then
  echo "ERROR: expected output was empty" >&2
  exit 1
fi
```

Always validate stdout/stderr content semantically rather than relying on exit status.

---

## Rule 5: Multiline Content Uses `\n` and `\t`

Newlines and tabs in `content=` values are encoded as `\n` and `\t` literals in the argument string.

```bash
obsidian vault="Notes" daily:append content="- [ ] Item one\n- [ ] Item two"
```

---

## Rule 6: Quoting — Avoid Complex Payloads

Single quotes inside `content=` are not reliably supported. Control characters and raw backslash-heavy strings (e.g., LaTeX) can misbehave.

```bash
# Avoid — single quotes inside content= are unsupported
obsidian vault="Notes" create path="note.md" content="don't use this"

# Safer for complex content — use a template or write the file directly then open
obsidian vault="Notes" template:insert name="My Template" path="Notes/new.md"
obsidian vault="Notes" open path="Notes/new.md"
```

For payloads with complex quoting requirements, prefer writing the file outside the CLI and then calling `open` or using a dedicated property command.

---

## Rule 7: Availability Check

The CLI requires Obsidian 1.12.7+ with the CLI enabled. First command launches the app if not running.

```bash
# Verify CLI is registered and app is responsive
obsidian version
# Expected output: version string like "1.12.7"
# If command not found: PATH not set; re-register in Settings → General → CLI
```

---

## Rule 8: `dev:cdp` / `eval` — Explicit Intent Required

`dev:cdp` and `eval` operate inside the live app with full plugin trust. Never invoke these without explicit user intent to run arbitrary code or DevTools protocol methods.
