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

| Module      | What it does                                                   |
| ----------- | -------------------------------------------------------------- |
| `base`      | apt prerequisites (`curl`, `git`, `jq`, `gnupg`, …)            |
| `keyd`      | CapsLock → Hyper. From Ubuntu universe — no third-party repo   |
| `brave`     | Brave + Bitwarden/Vimium via enterprise policy                 |
| `vscode`    | VS Code + config symlinked from `shared/vscode/` + extensions  |
| `warp`      | Warp terminal                                                  |
| `krohnkite` | KWin tiling, from the maintained Plasma 6 fork                 |
| `kde`       | Launcher on Super+Space, Hyper collision fixes                 |
| `shortcuts` | The whole keyboard scheme, from `shared/shortcuts/keymap.conf` |

**`shortcuts` must run last** — after `krohnkite` and `kde`. Krohnkite registers
its own bindings when it installs, and KDE's defaults come back on reconfigure;
`shortcuts` re-asserts the scheme over both. That ordering is already set in
`config.sh`.

## The shortcut scheme

The chord-by-chord scheme is **not** defined here. It lives in
`shared/shortcuts/keymap.conf`, which is cross-OS, and is mapped onto KDE by two
Linux-only tables:

```
shared/shortcuts/keymap.conf    chord     -> action id      cross-OS
linux/config/kde/actions.conf   action id -> KDE action     this desktop
linux/config/kde/apps.conf      action id -> app            this desktop
```

Read `shared/shortcuts/README.md` for the design and the reasoning. Changing a
binding is a one-line edit in `keymap.conf` plus `bash linux/install shortcuts`
— there is no code to touch.

Two checkers, and the difference matters:

```bash
bash linux/modules/shortcuts.sh --verify            # every chord vs the live registry
bash linux/modules/shortcuts.sh --owner 'Hyper+U'   # who holds one chord, live
```

Both ask the **running compositor**, not `kglobalshortcutsrc`. Shortcuts
registered from a `.desktop` file are live in KWin but absent from that file
until something overrides them, so a file-based check reports them free. That is
how Spectacle sat unnoticed on `Meta+Ctrl+R` and `Meta+Ctrl+Print`, inside the
hyper layer. `modules/kde.sh --owner` still does the file-based check and is the
right tool only when there is no session to ask.

### App toggles

`Hyper+U/I/O/P` are a true toggle: focused → minimize, running → activate, not
running → launch. They are served by `osz-apps`, a KWin script **generated** from
`config/kde/apps.conf` — do not edit the generated script under
`linux/kwin-scripts/`.

Launching is the awkward part: KWin's JS engine has no `exec`. Each app
therefore ships a generated systemd **user** unit, and the script asks systemd to
start it over D-Bus. The unit runs inside the user session, which already has
`WAYLAND_DISPLAY` and the session bus, so nothing has to be reconstructed.

`ExecStart` is read out of the app's desktop entry rather than guessed from its
name — VS Code's real `Exec` is `/usr/share/code/code`, which guessing would
never have found.

### Window keys

Two navigation models, one per axis:

```
  I  focus up      K  focus down      directional — walks the current column
  J  focus prev    L  focus next      circular — wraps, works in any layout
```

`Hyper+Shift+…` moves the window, `Hyper+Alt+…` resizes, `Hyper+D` hops to the
next display.

`I`/`K` stay directional because that axis measures well — they walk the column
precisely and stop at its ends. Directional *left/right* was dropped: from the
master it jumped to the **bottom** of the stack rather than the nearest window,
and circular covers master↔stack better anyway. In the overlapping layouts
(Floating, Monocle, Spread, Stair, Cascade) `J`/`L` are the only focus keys that
make sense at all.

Note `Shift+J`/`L` still move the window *left/right* while `J`/`L` focus
*circularly* — Krohnkite has no circular move pair, and its ordinal move
(`ShiftUp`/`ShiftDown`) already sits on `Shift+I`/`Shift+K`.

This is **not** vim's `hjkl`; `keymap.conf` carries a paste-ready revert block
for that if you want it back.

### Floating windows

`Hyper+F` floats/unfloats the focused window; `Hyper+C` centres a floating one
(KWin's native `Window Move Center`). Centring a _tiled_ window does nothing
visible — Krohnkite re-tiles it the moment it moves.

### Layouts

`Hyper+'` cycles forward, `Hyper+Shift+'` back. Which layouts are *in* the cycle
is set in `config/krohnkite/kwinrc.conf`: each has an **order**, the number is
its position in the cycle, and **`0` removes it**. Keep the cycle short — every
extra layout is another press to get past.

The table below was measured, not copied from docs: four windows on a 1920x1200
screen, geometry read back off KWin.

| Layout           | Order key                | What it does |
| ---------------- | ------------------------ | ------------ |
| **Tile**         | `tileLayoutOrder`        | Master pane on the left at half width, everything else stacked in a right column. The dwm/i3 default and the one to keep. |
| **Monocle**      | `monocleLayoutOrder`     | Every window full-screen, one visible at a time. A focus mode — navigate with the circular keys, not the directional ones. |
| **Three-Column** | `threeColumnLayoutOrder` | Master in a wide centre column, flanked by a left and a right column that take the overflow. For ultrawides. |
| **Quarter**      | `quarterLayoutOrder`     | Up to four equal quadrants. Predictable, but caps out at four. |
| **Columns**      | `columnsLayoutOrder`     | One full-height column per window, side by side, individually resizable. Needs `enableColumnsLayout=true` as well as an order. |
| **Spiral**       | `spiralLayoutOrder`      | Each new window halves the remaining space, spiralling inward — half, then quarter, then eighth. |
| **Binary Tree**  | `binaryTreeLayoutOrder`  | Recursive split; with four windows it lands on even quadrants, but it subdivides wherever the tree happens to branch. |
| **Stacked**      | `stackedLayoutOrder`     | Full-width horizontal bands, the top one tallest and each below it shorter. |
| **Stair**        | `stairLayoutOrder`       | Near-full-size windows offset ~24px each, a staircase down from the top-left. Overlapping, not tiled. |
| **Cascade**      | `cascadeLayoutOrder`     | Like Stair but with a larger offset and the focused window on top. **No direct shortcut** — reachable only by cycling. |
| **Spread**       | `spreadLayoutOrder`      | All windows the same large size, fanned out ~134px apart like a deck of cards. |
| **Floating**     | `floatingLayoutOrder`    | No tiling at all; every window keeps whatever size and position it had. `Hyper+C` centres one. |

The last five overlap rather than tile, so directional focus is ambiguous in
them — use the circular keys there.


`Hyper+'` cycles forward, `Hyper+Shift+'` cycles back. Which layouts are _in_
the cycle is set in `config/krohnkite/kwinrc.conf`: each layout has an **order**,
and **`0` removes it from the cycle**. The cycle currently holds three — tile,
monocle, three-column — and every other layout is listed at `0`, ready to be
given a number.

`Hyper+M` is per-window **maximize** (KWin's `Window Maximize`), which works
inside a tile and leaves the layout alone. Monocle is a _layout_ and lives in the
cycle. Gaps: `screenGap{Left,Right,Top,Bottom}` is the outer margin (0 here),
`screenGapBetween` is the gap between tiles (8).

> **Quit** (`Hyper+Q`) closes every window belonging to the focused app, since
> KDE has no quit-application action. For apps that live in the tray (Claude
> Desktop), that closes the window and leaves the app resident — which is the
> app's own behaviour, and the same thing it does on macOS.

## Making changes

Four files, one command each. Nothing here needs a logout.

| Want to change                       | Edit                                                                             |
| ------------------------------------ | -------------------------------------------------------------------------------- |
| Any chord                            | `shared/shortcuts/keymap.conf` — `<chord> \| <action> \| <tier> \| <desc>`       |
| Which app sits on a key              | `config/kde/apps.conf` — `<action> \| <window class> \| <desktop id> \| <label>` |
| Wire up a new KDE/KWin action        | `config/kde/actions.conf` — `<action> \| <component> \| <key>`                   |
| Gaps, layout cycle, tiling behaviour | `config/krohnkite/kwinrc.conf`                                                   |

```bash
bash linux/install shortcuts     # after any of the first three
bash linux/install krohnkite     # after the fourth
bash linux/modules/shortcuts.sh --verify
```

- **Move a shortcut** — change the chord in `keymap.conf`, re-run. That is the
  whole operation; there is no code to touch.
- **Add an app** — one line in `apps.conf` (invent an `app.foo` id), one line in
  `keymap.conf` pointing a chord at it. The KWin script and the systemd launch
  unit are both generated from that.
- **Add a WM or system action** — one line in `actions.conf`, one in
  `keymap.conf`.

### Two lookups you will need

```bash
# KDE action names, for actions.conf
gdbus call --session --dest org.kde.kglobalaccel --object-path /kglobalaccel \
  --method org.kde.KGlobalAccel.allActionsForComponent "['kwin','','','']" \
  | tr ',' '\n' | grep -i <word>

# Is a chord free? Asks the live compositor, not the file.
bash linux/modules/shortcuts.sh --owner 'Hyper+G'
```

Window classes for `apps.conf` cannot be guessed — three of the four here are
reverse-DNS and none are derivable from the binary name. Capture them off a live
window via KWin scripting; the recipe is in the comments at the top of
`apps.conf`.

### Two things that will otherwise waste your time

- **`--verify` proves a chord is _stored_, not that a keyboard can produce it.**
  It reads the shortcut registry, which will happily report a binding no key
  combination can emit — which is exactly how fourteen Shift-folded chords once
  looked healthy while being dead. Press the key.
- **A wrong key name in `krohnkite/kwinrc.conf` is ignored silently.** Take names
  from the installed package's own schema, not from upstream docs:
  `~/.local/share/kwin/scripts/krohnkite/contents/config/main.xml`.

Currently free for new bindings: `A B E G H N S T V X Y Z` and `,` `.`
(`keymap.conf` keeps this list next to the app block).

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
is _ignoring_ the touchpad, which is true and beside the point.

Super+Ctrl collides with some KDE defaults; `config/kde/shortcuts.conf` documents
exactly which ones are freed and which are deliberately left alone.

## Manual steps after install

Nothing below can be scripted — they all require an interactive login.

1. **Brave** — launch it; Bitwarden and Vimium install themselves on first run.
   Confirm at `brave://policy` and `brave://extensions`.
2. **Bitwarden** — sign in to your vault.
3. **Vimium** — Options → _Import_ → `shared/vimium/options.json`. Vimium has no
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
