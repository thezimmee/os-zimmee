# shared/

Cross-OS application config. One directory per app: `shared/<app>/`.

## The rule

**`shared/` holds content. The OS directories hold logic and paths.**

There are no install scripts here — nothing in this tree is executable. A file
lands here because its *contents* are the same on every machine; the OS module
(`linux/modules/<app>.sh`, and eventually `macos/` and `windows/` equivalents)
owns getting it to the right place, because the destination path is inherently
OS-specific:

| App | Linux | macOS | Windows |
|---|---|---|---|
| VS Code | `~/.config/Code/User/` | `~/Library/Application Support/Code/User/` | `%APPDATA%\Code\User\` |
| Brave policy | `/etc/brave/policies/managed/*.json` | `com.brave.Browser` plist | `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` |
| Firefox policy | `/etc/firefox/policies/policies.json` | `<app>/Contents/Resources/distribution/` | `HKLM\SOFTWARE\Policies\Mozilla\Firefox` |

## What earns a place here

A file moves into `shared/` when a **second** OS actually consumes it — not when
one might someday. Until then it belongs in the OS directory that uses it.
Otherwise this becomes the drawer where anything vaguely portable accumulates.

## Handling per-OS differences

In order of preference:

1. **Let the app do it.** VS Code resolves `.linux` / `.osx` / `.windows` key
   suffixes natively, and `key` vs `mac` in keybindings, so one file genuinely
   works. Always prefer this.
2. **Duplicate.** For a short file, two copies beat a merge pipeline.
3. **Base + overlay merged at install time.** Powerful, but the deployed file
   becomes *generated*, which forfeits the symlink property this repo leans on —
   edit in the repo, live immediately. Avoid until something forces it.

If option 3 starts showing up in more than a place or two, that is the signal to
reconsider a real config manager (`chezmoi` solves exactly this) rather than
growing a homegrown templating layer.

## Browser policies are not one schema

Both `brave/` and `firefox/` deploy extensions by enterprise policy, but they do
not share a format and the files are not interchangeable:

| | Brave (Chromium) | Firefox |
|---|---|---|
| Top level | flat — `ExtensionSettings` at root | wrapped in a `"policies"` key |
| Addressed by | Chrome Web Store ID | AMO GUID, e.g. `{d7742d87-…}` |
| Source | `update_url` (clients2.google.com) | `install_url` (an AMO `.xpi`) |

`installation_mode: normal_installed` means the same thing in both: installed
automatically, still removable by hand.

**The Firefox snap caveat.** Ubuntu's Firefox is a snap with no `distribution/`
directory in its squashfs. It reads `/etc/firefox` only through a connected
`system-files` plug. Check before trusting a policy:

```bash
snap connections firefox | grep etc-firefox     # must show a connected slot
```

## Note on format vs. content

`brave/policies-managed.json` is shared *content* in an OS-specific *format*:
Linux reads the JSON directly, while macOS and Windows express the same policy
as a plist and registry keys. The JSON is the source of truth; those modules
will need a mechanical translation step, not a symlink.
