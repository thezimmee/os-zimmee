# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

OS Zimmee — a reusable machine-setup repo, primarily for macOS, that installs apps/tools and drops in
personal configuration (dotfiles, editor configs, Hammerspoon, Karabiner, AutoHotkey for the one Windows
machine, etc). One directory per app/tool, orchestrated by root `install`/`uninstall`/`update` scripts.

## Environment: this clone lives on Windows, typically edited from WSL

This working copy is the native Windows clone at `C:\Users\thezi\Apps\os-zimmee`, edited from a WSL shell
via its `/mnt/c/Users/thezi/Apps/os-zimmee` mount. It's the only clone — no separate WSL-native checkout —
and doubles as the live source AutoHotkey v2 runs `autohotkey/init.ahk` from at Windows login (a
Startup-folder shortcut points `AutoHotkey.exe` straight at it, so AHK never depends on WSL's file sharing).

**Always use `git.exe` (native Windows git, reachable via WSL interop) when working from WSL, never plain `git`,
for any git command in this repo.** Linux git operating on `/mnt/c` paths goes through drvfs and is drastically
slower. `git.exe` runs natively against NTFS and returns instantly. `git.exe` also uses its own Windows-side SSH
keys, separate from WSL's SSH config, which matters for auth on push/pull/clone.

## Install / uninstall / update

Root orchestration scripts:
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
