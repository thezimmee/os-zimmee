# OS Zimmee — Linux

Machine setup for Kubuntu / KDE Plasma. Built and verified on **Kubuntu 26.04
(resolute), Plasma 6.6 on Wayland, x86_64**.

## Usage

```bash
bash linux/install              # everything, in config.sh order
bash linux/install keyd brave   # just these
bash linux/install --list       # what's available
bash linux/uninstall [module…]
bash linux/update [module…]     # apt upgrade, then per-module update steps
```

Every module is idempotent — re-running is the supported way to apply an edit.
You need to be at the keyboard: the run asks for `sudo` once, up front.

## Modules

| Module | What it does |
|---|---|
| `base` | apt prerequisites (`curl`, `git`, `jq`, `gnupg`, …) |
| `keyd` | CapsLock → Hyper. From Ubuntu universe — no third-party repo |
| `brave` | Brave + Bitwarden/Vimium via enterprise policy |
| `vscode` | VS Code + config symlinked from `shared/vscode/` + extensions |
| `warp` | Warp terminal |
| `krohnkite` | KWin tiling, from the maintained Plasma 6 fork |
| `kde` | Launcher on Super+Space, Hyper collision fixes |

## The Hyper key

CapsLock is dual-role, matching `karabiner-elements/` (macOS) and `autohotkey/`
(Windows):

- **held** → Hyper prefix, emitted as **Super+Ctrl**
- **tapped alone** → **Super+Space**, which opens KRunner

CapsLock's original toggle function is gone. keyd works at the evdev layer, so
this is Wayland-native — no compositor support required.

> **Escape hatch:** if a bad keyd config ever leaves the keyboard unusable, press
> **backspace + escape + enter** together to terminate keyd and restore raw input.

**keyd and the touchpad:** keyd creates a virtual pointer device, which KDE reads
as an external mouse and then disables the touchpad. The `kde` module sets
`DisableEventsOnExternalMouse=false` to prevent this. If your touchpad ever dies
right after login, that setting is the first thing to check — `keyd` logs say it
is *ignoring* the touchpad, which is true and beside the point.

Super+Ctrl collides with some KDE defaults; `config/kde/shortcuts.conf` documents
exactly which ones are freed and which are deliberately left alone.

## Manual steps after install

Nothing below can be scripted — they all require an interactive login.

1. **Brave** — launch it; Bitwarden and Vimium install themselves on first run.
   Confirm at `brave://policy` and `brave://extensions`.
2. **Bitwarden** — sign in to your vault.
3. **Vimium** — Options → *Import* → `shared/vimium/options.json`. Vimium has no
   policy-driven way to preload settings.
4. **Warp** — sign in on first launch.
5. **VS Code** — sign in if you want Settings Sync.
6. **Log out and back in** — required for the KDE shortcut changes and for your
   `keyd` group membership.

## Layout

```
linux/
  install / uninstall / update   orchestrators (module dispatch)
  lib.sh                         logging, confirm, symlink, apt helpers
  config.sh                      module order, package lists, apt repo defs
  modules/*.sh                   one file per app: install_/update_/uninstall_<name>
  config/<app>/                  Linux-only config files
```

Cross-OS config lives in `shared/<app>/` — see `shared/README.md`.
