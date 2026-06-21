# CLAUDE.md — autohotkey

AutoHotkey **v2** config (a subfolder of the `os-zimmee` OS-config repo) that gives a
Windows machine macOS-style keys plus mouse-button and key utilities.

You are an AutoHotkey v2 expert. You know the v1→v2 breaking changes cold and default to
the v2 idioms below. These remaps run on every keystroke, so favor the simplest construct
that works — stability over cleverness.

## Division of labour

**Raycast** owns app launch/switch and window management — do **not** rebuild those here.
**AutoHotkey** owns what Raycast can't: in-app shortcuts (Cmd+C/V/S…), text navigation/
editing, mouse buttons on keys, and per-app key overrides.

## Architecture — "Option 1": Left-Alt-as-Command

- `LAlt::LControl` makes the left thumb key act as **Command** for every Ctrl shortcut at
  once. Windows never sees a bare Alt → no stray-Alt menu flashes, no enumeration gaps.
- **Corner LCtrl** stays a real Ctrl → Mac "Control" + native word-nav (Ctrl+←/→, Ctrl+⌫).
- **RAlt** is untouched → the real Alt (Alt+F4, menus, AltGr).
- Shortcuts that aren't simply "Cmd = Ctrl" (the app switcher, line/doc navigation) are
  **carve-outs**: `LAlt & <key>` custom combinations that intercept the physical thumb+key
  *before* the remap turns the thumb into Ctrl. This is the only way to distinguish
  thumb+key from corner-Ctrl+key once both produce `LControl`.
- The remap holds `LCtrl` down (DownR), so a carve-out **lifts it** (`{LCtrl up}`) when it
  needs non-Ctrl output (Home/End/Alt+Tab) and **keeps it** when it wants Ctrl (Cmd+Up =
  Ctrl+Home). `{Blind}` preserves the physically-held Shift so one line covers selection too.
- The swap is AHK-level: reversible (suspend/exit AHK) and `#HotIf`-scopable per app —
  never an OS/registry swap.

> If the remap + custom-combo-prefix interaction ever proves flaky, the fallback is
> "Option 2": no swap, explicit `!c::^c`-style maps. (Option 1 is less code and more robust,
> so it's preferred.)

## Hard rules

- **AutoHotkey v2 only.** Every script starts with `#Requires AutoHotkey v2.0`. v1 command
  syntax is a bug to fix, never a pattern to copy.
- **Each hotkey is defined exactly once, globally.** Grep before adding a key.
- **`#HotIf` contexts must be closed** with a bare `#HotIf`. An unclosed context silently
  scopes every hotkey after it — including in later `#Include`d files.
- **Directives live only in `init.ahk`** (`#SingleInstance`, `SendMode`, `SetWorkingDir`…).
- **Don't wrap simple remaps in `Suspend`.** A `key::otherkey` remap doesn't retrigger
  itself; the wrapper just adds latency and disables unrelated hotkeys.

## v1→v2 traps

| v1 (wrong) | v2 (correct) |
|---|---|
| `SendMode Input`, `SetCapsLockState, AlwaysOff` | `SendMode "Input"`, `SetCapsLockState "AlwaysOff"` |
| `IfWinExist`, `WinActivate, title` | `if WinExist("ahk_exe x")`, `WinActivate` |
| `Run, path` | `Run "path"` |
| `%var%` in strings | concatenation: `"ahk_exe " exe` |

## Files

`init.ahk` is the single entry point — run/reload **only** it.

- `init.ahk` — directives + `#Include`s.
- `macos.ahk` — the Command swap, app switcher, and text nav/editing carve-outs.
- `keyboard-mouse.ahk` — mouse buttons on keys; CapsLock (role TBD).
- `apps.ahk` — per-application `#HotIf WinActive` overrides.

`#Include` order matters: global remaps before any `#HotIf` context, and every context reset.

## Key symbol legend

```
#  Win        +  Shift        !  Alt        ^  Ctrl        &  combine keys
```

Lowercase vs uppercase matters: `^a` = Ctrl+A, `^A` = Ctrl+Shift+A. Prefer lowercase.

## Per-app overrides (when needed)

Raycast covers most app needs; for genuine per-app key tweaks, scope with `#HotIf` and
**always reset**:

```ahk
#HotIf WinActive("ahk_exe Notion.exe")
!b::^b
#HotIf            ; <-- mandatory reset
```

## Testing a change

No automated harness — verification is manual:

1. Syntax check without going interactive:
   `& "C:\Program Files\AutoHotkey\v2\AutoHotkey.exe" /validate "init.ahk"`
2. Reload `init.ahk` (or tray → *Reload Script*); a clean reload with **no duplicate-hotkey
   / load-error dialog** is the first signal it's structurally sound.
3. Use **KeyHistory** and **Window Spy** (tray menu) to confirm what a key sent and to get
   exact `ahk_exe` names for `#HotIf` / `WinActive`.
4. Test in the real target app, including with Shift held (selection) and the thumb held
   across multiple keys.

## Git

Part of the **os-zimmee** repo; origin is GitHub (`git@github.com:thezimmee/os-zimmee.git`).
Edit and run AutoHotkey from the local clone (`C:\Users\thezi\Apps\os-zimmee\autohotkey`) so
hotkeys don't depend on the network. Commit in small described commits; push to GitHub.
Don't push a config that fails `/validate` or a clean reload.
