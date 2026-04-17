# Obsidian CLI — Troubleshooting and Platform Setup

---

## First-Response Sequence

When the CLI fails or behaves unexpectedly, apply in order:

1. Upgrade to the latest Obsidian **installer** (not just the in-app updater — download the installer)
2. In Obsidian: Settings → General → Command line interface → toggle OFF then ON
3. Let Obsidian re-register itself to PATH
4. Restart the terminal
5. Verify: `obsidian version` or `obsidian help`

---

## Platform Registration

### macOS

- Creates a symlink at `/usr/local/bin/obsidian` → bundled CLI binary
- Requires administrator approval via system dialog on first registration
- **"Unable to find helper app" error:** disable and re-enable the CLI in Settings → General → CLI (the toggle re-registers the helper binary), then approve in the macOS system dialog
- Check for stale PATH entries: `grep -n obsidian ~/.zprofile ~/.zshrc ~/.bash_profile 2>/dev/null`
- Remove stale lines if the app re-registered to a different location

### Windows

- Uses an `Obsidian.com` terminal redirector next to `Obsidian.exe`
- PATH change is per-user; requires terminal restart
- Shim-based package managers (e.g., Scoop) can spawn extra console windows — prefer official installer
- Several Windows detection bugs were fixed in 1.12.2–1.12.4; ensure installer is current

### Linux

- Copies CLI binary to `~/.local/bin/obsidian`
- Requires `~/.local/bin` in PATH: `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc`
- Flatpak builds are **community-maintained** and can sandbox the CLI socket — use the official installer where possible

---

## Known Issue Classes

| Issue | Symptom | Fix |
|---|---|---|
| **Installer mismatch** | CLI misbehaves or version check fails | Upgrade installer; re-register CLI |
| **Exit-code unreliability** | `set -e` doesn't catch failures | Validate stdout/stderr content semantically |
| **Quoting/control chars** | `content=` with single quotes or LaTeX silently corrupts | Use templates or write file directly |
| **External-write race** | `property:set` no-op after writing file outside Obsidian | Write through CLI or insert a sync/wait step |
| **Frontmatter bootstrapping** | `create` + `append` leaves frontmatter on line 2, breaking YAML parse | Use `template:insert`; or discover property commands via `obsidian help \| grep property` |
| **Packaging/sandbox** | Scoop shim, old Homebrew install, or Flatpak breaks discovery | Use official installer |
| **Cron / headless environment** | CLI silently fails — Obsidian does not launch or is unreachable | The CLI requires the GUI app to be running and a display server present; verify Obsidian is already open before the job runs, or use `obsidian-headless` for server contexts |
| **Agent shell sandbox** | Some agent environments (e.g., Codex Desktop on macOS) launch a second crashing instance | Test from a normal terminal first; file bug with agent vendor |
| **Stale early-release examples** | Pre-1.12.7 examples use wrong parameter names | Run `obsidian help <command>` on installed version |

---

## Desktop CLI vs. Obsidian Headless

| | Desktop CLI (`obsidian`) | Obsidian Headless (`obsidian-headless`) |
|---|---|---|
| Requires running GUI | Yes — launches app if not running | No |
| Use case | Live vault, plugins, UI, dev tools | Server-side Sync/Publish only |
| Install | Built into Obsidian desktop app | `npm install -g obsidian-headless` (Node 22+) |
| Subscription | None for core features | Requires Sync or Publish subscription |

**Never substitute one for the other.** If you want to script against live plugin commands, workspace state, or developer tools — use `obsidian`. If you need a GUI-free server pipeline for Sync/Publish — use `obsidian-headless`.

---

## Version Stability Note

The CLI shipped in 1.12.0 (Feb 10, 2026) and matured rapidly through 1.12.7 (Mar 23, 2026). Community posts and examples from early February 2026 may reference incorrect parameter names or deprecated behavior. Always check `obsidian help <command>` for the authoritative surface of the installed version.
