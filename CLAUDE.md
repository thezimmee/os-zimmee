# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

OS Zimmee — a reusable machine-setup repo that installs apps/tools and drops in personal configuration
(dotfiles, editor configs, keyboard remaps, desktop settings) so a machine can be rebuilt programmatically.

It covers three operating systems. **Linux (Kubuntu/KDE) is the primary track**; macOS and Windows are
older and largely unmigrated. See *Layout* below before adding anything.

## Clones

This repo is checked out on more than one machine and **no clone is special**:

- **Kubuntu laptop (Dell XPS 16)** — `~/Projects/os-zimmee`. The primary clone
  going forward; the `linux/` track is developed and verified here.
- **Windows** — `C:\Users\thezi\Apps\os-zimmee`, typically edited from WSL via
  `/mnt/c/...`. It doubles as the live source AutoHotkey v2 runs `autohotkey/init.ahk`
  from at login (a Startup-folder shortcut points `AutoHotkey.exe` straight at it).
  **From WSL, always use `git.exe`, never plain `git`** — Linux git on `/mnt/c` goes
  through drvfs and is drastically slower, and `git.exe` uses the Windows-side SSH keys.

Remotes follow the conventions in the parent `Projects/CLAUDE.md`: `bertha` is the
default and source of truth, `github` is `thezimmee/os-zimmee`, and `all` pushes to both.

## Layout

The repo is mid-migration from one-directory-per-app to an **OS-major** layout. The
old structure conflated two axes — app and OS — which stopped working once there were
three operating systems. The target:

```
linux/     macos/     windows/     OS-specific install logic + OS-specific config
shared/                            cross-OS app config (content only, no scripts)
```

**The invariant: `shared/` holds content, the OS directories hold logic and paths.**
A file earns a place in `shared/<app>/` only once a *second* OS actually consumes it.

| Area | Status |
|---|---|
| `linux/` | **Migrated.** Self-contained; the reference for the new layout |
| `shared/` | **Live.** `vscode/`, `brave/`, `vimium/` |
| `macos/`, root `install`/`update`/`uninstall`, and the per-app dirs | Legacy, unmigrated |
| `autohotkey/` → `windows/` | Not yet moved. **Gotcha:** the Startup shortcut points at an absolute path to `init.ahk`; moving the directory silently breaks the hyper key at next login. Recreate the shortcut in the same commit |

**New work goes only in the new layout.** Migrate legacy directories opportunistically
rather than in a big bang, but never extend the old structure.

## Install / uninstall / update

**Linux (primary):** `bash linux/install [module…]` — see `linux/README.md` and
`linux/CLAUDE.md`. It is self-contained and shares nothing with the root scripts below.

**macOS (legacy):** root orchestration scripts:
- `bash ./install` — clones the repo if needed, then walks every top-level app directory and sources its
  `install` script (prompting per app). `homebrew` and `node` install first as prerequisites.
- `bash ./uninstall` — mirrors `install`, sourcing each app directory's `uninstall` script.
- `bash ./update` — prompts to update homebrew, npm globals, macOS software updates, then sources every app
  directory's `update` script.

Any app can also be installed standalone: `bash ./<app>/install`.

## Architecture: one self-contained directory per app/tool

Each top-level directory (`hammerspoon/`, `dotfiles/`, `zsh/`, `karabiner-elements/`, `autohotkey/`, etc.):
- Holds that app/tool's actual config files.
- Optionally exposes `install` / `uninstall` / `update` bash scripts. Each resolves `$OSZ_ROOT` itself
  (prompting if unset), so it works whether sourced by the root scripts or run standalone.
- `install` scripts generally **symlink** config into its expected OS location rather than copy it — e.g.
  `hammerspoon/install` symlinks `hammerspoon/hammerspoon.link` to `~/.hammerspoon`; `dotfiles/install`
  symlinks every `dotfiles/.*` file to `$HOME`. Edits inside this repo take effect live wherever they're
  symlinked; no re-install step needed.

`autohotkey/` is the exception: Windows-only, has its own `CLAUDE.md` with the actual key-remap
architecture, and isn't symlinked — it's launched via a Startup-folder shortcut pointing directly at
`init.ahk`.

## Line endings

`.gitattributes` sets `* text=auto`, so git normalizes line endings per platform on checkout — relevant
since this repo has historically been checked out on both Windows (CRLF) and WSL (LF).

## Submodules

Two Sublime Text plugins are git submodules, both under the `thezimmee` GitHub org:
`sublime/Plugins/MarkdownEditing`, `sublime/Plugins/FileIcons`.

## Per-app docs

Several app directories carry their own `CLAUDE.md` or `README` with tool-specific detail (e.g.
`autohotkey/CLAUDE.md` for the AHK v2 keyboard-remap architecture). Check for one before editing inside a
given app directory.
