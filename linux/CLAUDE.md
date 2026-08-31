# CLAUDE.md — linux

The Linux track of `os-zimmee`: Kubuntu / KDE Plasma machine setup. Built and
verified on **Kubuntu 26.04 (resolute), Plasma 6.6 on Wayland, x86_64**.

This is the repo's primary track going forward. It is **fully self-contained** —
it shares no code with the root `install`/`update`/`uninstall` scripts, which are
stale macOS/Homebrew orchestrators. Do not wire the two together.

## Architecture: orchestrator + modules

`linux/install` is a dispatcher. It sources `lib.sh` and `config.sh`, then for
each requested module sources `modules/<name>.sh` and calls `install_<name>`.
`uninstall` and `update` are the same script with `$OSZ_ACTION` flipped, calling
`uninstall_<name>` / `update_<name>`.

Adding an app means: write `modules/<app>.sh`, add its name to `OSZ_MODULES` in
`config.sh`. Nothing else.

**Every module must be idempotent.** Re-running is the supported way to apply an
edit, so guard every mutation. The `lib.sh` helpers already do this — prefer them
over raw commands:

| Helper | Use for |
|---|---|
| `apt_install` / `apt_remove` | packages; skips what's already installed |
| `apt_repo <name> <key-url> <suite>` | third-party repos; keyring + `.list`, idempotent |
| `symlink` / `sudo_symlink` | config; backs up anything real already there |
| `log` `ok` `warn` `err` `step` `skip` | output — don't hand-roll `echo` |
| `require_linux` / `require_kde` / `require_sudo` | preconditions |
| `have <cmd>` / `confirm <prompt> [y|n]` | checks and prompts |

A module that defines only some of the three functions is fine — the dispatcher
skips a missing one with a note.

## Where config lives

- `linux/config/<app>/` — Linux-only config (keyd, KDE shortcuts, Krohnkite).
- `shared/<app>/` — cross-OS config (VS Code, Brave policy, Vimium). See
  `shared/README.md`. Content only, never scripts; the module owns the path.

Config is **symlinked** from the repo where possible, so edits go live without a
re-install. Two deliberate exceptions:

- **Brave policy** is *copied*. A managed policy is meant to be root-owned and
  not user-writable; pointing it at `$HOME` would undermine that. Re-run the
  module to push an edit.
- **`kwinrc`** is written key-by-key with `kwriteconfig6`. It is shared with the
  rest of KWin, so it cannot be replaced wholesale.

## Plasma 6 Wayland gotchas

These caused real problems; don't rediscover them.

- **There is no kglobalaccel daemon.** `plasma-kglobalaccel.service` exists but
  sits inert — KWin hosts the global-shortcut registry in-process. Writes to
  `kglobalshortcutsrc` are only guaranteed live after a **full logout/login**.
  `qdbus6 org.kde.KWin /KWin reconfigure` picks up the `[kwin]` group and KWin
  scripts, but not `[services]`, `[plasmashell]`, or other groups.
- **Shortcut values are `active,default,description`.** Setting the *active*
  field to `none` disables a binding. Multiple active shortcuts are separated by
  a literal **tab**.
- **A KWin script is inert until enabled** in `kwinrc` under `[Plugins]` as
  `<name>Enabled=true`. Installing the package alone does nothing.
- **`kpackagetool6`, not `kpackagetool5`.** Both are on PATH; the 5 variant will
  appear to work and then not load.

## The Hyper key

CapsLock is dual-role via keyd: **held → Super+Ctrl**, **tapped → Super+Space**
(KRunner). This mirrors `karabiner-elements/` on macOS and `autohotkey/` on
Windows, which is deliberate — the three machines should emit the same chords so
that app-level keybindings can live in `shared/`.

keyd runs at the evdev layer, below the display server, so it is Wayland-native.

**Super+Ctrl is contested on KDE.** `config/kde/shortcuts.conf` records the
collision clearing that the keymap cannot express; the chord-by-chord scheme
itself lives in `shared/shortcuts/keymap.conf` and is applied by
`modules/shortcuts.sh`. Re-audit after a Plasma major upgrade:

```bash
awk '/^\[/{sec=$0} /Meta\+Ctrl/{print sec"  ->  "$0}' ~/.config/kglobalshortcutsrc
```

**Krohnkite registers its shortcuts at install time**, so they cannot appear in a
pre-install audit — and the `shortcuts` module overwrites the ones the scheme
uses, which is what frees bare Super to stay native. Krohnkite's stock
`Meta+H/J/K/L` no longer apply.

**Escape hatch:** a keyd config that breaks the keyboard is recoverable by
pressing **backspace + escape + enter** together, which terminates keyd.

## Global shortcuts: what actually bites

The `shortcuts` module applies `shared/shortcuts/keymap.conf`. Every item below
cost real debugging; none is guessable.

- **kglobalaccel does NOT transfer a contested chord.** Assigning a chord that
  another action already holds silently **clears the new binding** and leaves the
  incumbent in place — the file gets written back as `Key=,,Description`. So the
  module runs two passes: release every chord it is about to claim, then assert.
  Krohnkite's actions happen to transfer, which makes this very easy to miss on a
  partial test; `Meta+Ctrl+Left` vs "Switch One Desktop to the Left" is where it
  shows up.
- **The file and the live registry are different things, and you need both.**
  `kglobalshortcutsrc` alone is not live (no kglobalaccel daemon on Plasma 6
  Wayland; KWin reads the file at login). `setForeignShortcutKeys` alone is not
  persistent — a live rebind was readable over D-Bus while the file still said
  `none`. Write both.
- **`getGlobalShortcutsByKey` is the authoritative owner check.** Shortcuts
  registered from a `.desktop` (`X-KDE-Shortcuts`) are live in KWin but **absent
  from `kglobalshortcutsrc`** until overridden, so a file-based check reports
  them FREE. A live sweep is what found Spectacle holding `Meta+Ctrl+R` and
  `Meta+Ctrl+Print` inside the hyper layer.
- **The gdbus owner tuple leaves a trailing quote.** Parsing it naively yields a
  component named `kwin'`, which then writes a junk `[kwin']` group that KDE
  ignores — a silent no-op that looks like success in the log.
- **Live component name != file group for services.** kglobalaccel says
  `org.kde.spectacle.desktop`; the file nests it as
  `[services][org.kde.spectacle.desktop]`. Writing the flat name creates another
  ignored junk group.
- **`KrohnkitegrowWidth` has a lowercase `g`.** The other three resize actions
  are capitalised. Upstream's spelling, and it fails silently if "corrected".
- **`registerShortcut()`'s default applies only on FIRST registration.** After
  that the stored value is authoritative and changing the default does nothing —
  which is why `KrohnkiteFocusRight` once sat unbound. Nothing in this repo
  relies on a default; every binding is asserted.
- **Module order matters.** `shortcuts` must run after `krohnkite` and `kde`,
  both of which re-register their own bindings. `config.sh` already orders it
  last; keep it there.
- **Binding an action MERGES with its default chords, it does not replace them.**
  Writing only our chord takes `Alt+F4` off Window Close and `Meta+F1` off Switch
  to Desktop 1. The merge is against the `default` field, never the current
  active, so re-runs stay idempotent. Krohnkite's defaults are `none`, so bare
  Super stays freed.
- **`setForeignShortcutKeys` replaces the WHOLE key list.** Send the merged list,
  not just our chord, or KWin flushes the natives back out of the file. And if
  any chord in the list cannot be mapped to a Qt keycode, skip the live apply
  entirely rather than send a partial list -- a partial list is how `Alt+F4`
  disappeared before F1–F35 were in the keycode table.

### Shift folds into the symbol — the silent shortcut killer

`Hyper+Shift+'` does **not** arrive as `Meta+Ctrl+Shift+Apostrophe`. Pressing it
emits `Meta+Ctrl+"` — Shift consumed into the character, **no Shift modifier**.
KWin's own defaults are the proof: `KrohnkitePreviousLayout=Meta+|` (not
`Meta+Shift+\`), `Walk Through Windows (Reverse)=Meta+~`, `view_zoom_in=Meta++`.

A naively stored binding writes fine, reads back byte-identical, and **never
fires**. Nothing errors. Fourteen chords were dead this way before it was
noticed — every `Hyper+Shift+<digit>`, both screenshot chords, and the layout and
display-move pairs.

`_fold_shift` in `modules/shortcuts.sh` handles it: `Hyper+Shift+1` →
`Meta+Ctrl+!`, `Hyper+Shift+Comma` → `Meta+Ctrl+<`. Letters and arrows are left
alone — `Shift+h` genuinely is Shift plus `Key_H`, and arrows have no shifted
form. The table is US-layout-specific.

> **Verifying storage is not verifying dispatch.** `--verify` reads the registry,
> which will happily report a chord that can never be produced by a keyboard. The
> only real test is pressing the key.

### Krohnkite reads its settings only at script load

`kwin reconfigure` does **not** make Krohnkite re-read `[Script-krohnkite]`. Gaps
written there keep their old values and the edit looks like it silently failed.
`modules/krohnkite.sh` toggles `krohnkiteEnabled` off, reconfigures, back on, and
reconfigures again -- that forces a real reload. Do not replace it with a plain
reconfigure.

Key names must come from the installed package's own schema
(`~/.local/share/kwin/scripts/krohnkite/contents/config/main.xml`), not from
upstream docs -- this fork's names differ, and a wrong key is ignored without a
warning. Two were being written for a while with no effect: `tileLayoutGap` (the
real key is `screenGapBetween`) and `maximizeSoleTile` (the real ones are the
`soleWindow*` group).

**A plain KWin script is the same way.** `kwin reconfigure` does not reload the
*code* of a script that is already running, even after `kpackagetool6 --upgrade`
has replaced the file on disk -- a changed `main.js` keeps executing its OLD
version until the plugin is toggled off and back on. The generated `osz-apps`
and `osz-snapcycle` scripts hit exactly this: their startup `print()` (proof of
a real reload) never reappeared after an upgrade + reconfigure, only after the
disable/reconfigure/enable/reconfigure dance. `install_kwin_script()` in
`modules/shortcuts.sh` does this automatically on every upgrade now -- do not
"simplify" it back to a bare reconfigure.

**Krohnkite fights direct geometry writes on a window it still tracks, and
there is no cross-script way to ask it first.** `osz-snapcycle` sets
`window.frameGeometry` directly, and on a genuinely floating window (real
`KrohnkiteToggleFloat`) the size sticks. On a window Krohnkite still manages
(Tiled, or Monocle with `monocleMaximize`), the geometry snaps right back --
no error anywhere, no fixed delay either (observed both under 300ms and over
1.5s) -- Krohnkite reasserts its own computed layout once *anything* next
triggers its relayout pass, and ordinary desktop activity is enough that this
usually happens fast. There is no reliable way to check "is this window tiled"
from outside Krohnkite's own script instance first: its `WindowState` is a
private closure variable, and the KWin-native `window.tile` property (real
native tiling, a separate feature Krohnkite doesn't use) stays `null`
regardless, in every state observed here.

So `osz-snapcycle` doesn't ask first -- it watches what actually happens.
After setting `frameGeometry` it connects once to the window's
`frameGeometryChanged` signal and compares each firing against what it just
set: the FIRST firing is usually just confirming its own write landed (the
property only updates on the next layout pass, so an immediate synchronous
readback right after assignment still shows the OLD value -- caught this by
printing it), so it stays connected rather than treating that as success. Only
a later firing that does NOT match is a real external revert, and only then
does it invoke the equivalent Krohnkite move shortcut
(`KrohnkiteShift{Left,Right,Up,Down}` -- the same action
`Hyper+Shift+Alt+<direction>` calls directly) as a fallback, gated by a
generous (1.5s) `Date.now()`-based deadline so a stale connection can't fire a
move off some unrelated change long after the fact. `Date.now()` works fine in
a KWin script; `setTimeout` does not, which is why this is reactive (wait for
the signal) rather than poll-after-a-delay.

**The plain `"javascript"` API (what the generated scripts use) has no `Qt`
global at all** -- confirmed live: `Qt.rect(...)`, the exact call Krohnkite's
own code uses to build geometry, throws `ReferenceError: Qt is not defined`
here. Krohnkite gets it because it declares `"X-Plasma-API": "declarativescript"`
and ships a real `main.qml` -- QML injects `Qt` as a language builtin; a plain
JS-API script never gets it, `setTimeout` included, since that's also a
QML/Qt-provided global elsewhere, not an ECMAScript one. Assign a plain
`{x, y, width, height}` object to `frameGeometry` instead -- the setter takes
it exactly as it would a real QRect.

**Native "Window Maximize" silently breaks Krohnkite's own focus/move keys
on that window, for as long as it stays maximized.** Krohnkite's per-window
`state` getter special-cases the native case ahead of its own tracked state:
it listens for the native `maximizedAboutToChange` signal and, when
`mode > 0`, forces `WindowState.NativeMaximized` -- a state `isTileableState()`
explicitly excludes. `KrohnkiteFocusLeft/Right/Up/Down` and `KrohnkiteShift*`
simply stop seeing the window; confirmed live, focus-cycling skipped it
outright. `KrohnkiteMonocleLayout` doesn't have this problem: with
`monocleMaximize=true` (already set in `config/krohnkite/kwinrc.conf`) a
monocled window becomes `WindowState.Maximized` instead, which IS tileable, so
nav keeps working -- and pressing `KrohnkiteMonocleLayout` again while already
in Monocle is a genuine toggle back to whatever layout was active before
(`Layout.setLayout`'s own logic, not something this repo built). This is why
`wm.maximize` is wired to `KrohnkiteMonocleLayout`, never native "Window
Maximize".

**The `Hyper+Shift+O` escape hatch (literal edge-to-edge, no Krohnkite
gaps/borders/layout) can't use native "Window Maximize" either**, for exactly
the reason above -- so `OszMaximizeToggle` in `osz-snapcycle` fakes it by
setting `frameGeometry` directly to the full usable area, which never touches
`maximizeMode` and so never trips Krohnkite's exclusion. Two more KWin
scripting gotchas turned up building it:

- **`window.maximizeMode` is READ-ONLY.** `win.maximizeMode = 0` throws
  `TypeError: Cannot assign to read-only property "maximizeMode"` -- it fails
  ONLY when there's actually something to clear, so a naive test that never
  hits a really-maximized window won't catch it. Krohnkite's own code never
  assigns it either; it calls `window.setMaximize(false, false)`, a method,
  not a property setter. Both `snapCycle` and `toggleNativeMaximize` clear
  maximize state through that method now.
- **`window.frameGeometry`'s getter returns a live reference, not an immutable
  value.** `MAXIMIZE_MEMORY[id] = win.frameGeometry` followed later by
  `win.frameGeometry = full` mutated the "saved" copy right along with the
  live assignment -- confirmed live: a restore-to-previous-size toggle
  restored to the just-set MAXIMIZED size instead, because by the time the
  restore ran, the "remembered" object had silently become the full-screen
  rect too. `cloneRect()` (a plain `{x,y,width,height}` copy) fixes it. This
  is why `candidateRect()` for snap-cycle was never affected -- it always
  builds a fresh object, never holds a reference to a live one.

Layouts are ordered, not toggled: `<layout>LayoutOrder` is the position in the
cycle and **0 removes it**. `columnsLayout` additionally has `enableColumnsLayout`.

**Krohnkite's own incremental move has no screen-edge clamp.** `wm.move.*`
(`Hyper+Shift+Alt+I/J/K/L`) used to bind straight to Krohnkite's
`ShiftLeft/Right/Up/Down`. Read its `moveFloat()` in
`~/.local/share/kwin/scripts/krohnkite/contents/code/script.js`: on a floating
window it steps `frameGeometry` by a fixed 5% of the usable area with no
bounds check at all -- repeated presses walk the window straight past the
screen edge and off-screen. `OszMoveStep{Left,Right,Up,Down}` in
`osz-snapcycle` replaces it: same 5% step (matching Krohnkite's own constant,
so the feel doesn't change), but `x`/`y` are clamped to the usable area, so a
step that would overshoot an edge lands exactly on it instead. Same
"watch what actually happens" fallback as `snapCycle` and
`toggleNativeMaximize` -- on a genuinely TILED window (where this chord means
tile-order move, not a pixel move, and only Krohnkite's engine knows the tile
order) the geometry write gets reverted and `watchForRevert` invokes the real
`KrohnkiteShift*` action, reproducing the exact behavior this replaced.
`linux/config/kde/actions.conf` routes `wm.move.*` through these instead of
Krohnkite's raw actions now.

### KWin scripts can launch apps

KWin's JS engine has no `exec`, which blocks the obvious app-toggle design. It
*does* have `callDBus`, and systemd's `StartUnit` takes a trivial `(ss)`
signature — so each app ships a generated systemd **user** unit and the script
starts it. Verified end to end: the callback returns a job path and the process
starts. The unit is already inside the user session, so `WAYLAND_DISPLAY`,
`DISPLAY` and `DBUS_SESSION_BUS_ADDRESS` need no reconstruction.

`linux/kwin-scripts/osz-apps/` is **generated** from `config/kde/apps.conf`.
Edit the conf, re-run the module.

### Iterating without logging out

`org.kde.kglobalaccel` is on the session bus and `setForeignShortcutKeys`
rebinds at runtime, so a change is testable in under a second. Shortcuts cross
D-Bus as Qt key codes: `Meta 0x10000000`, `Ctrl 0x04000000`, `Alt 0x08000000`,
`Shift 0x02000000`, letters `0x41`–`0x5A`. `modules/shortcuts.sh` has the
name→code table.

To trigger an action without pressing keys — useful for testing a KWin script
action — `org.kde.kglobalaccel.Component.invokeShortcut` on `/component/kwin`.

## keyd gotchas

All three of these cost real debugging time. None are guessable from the docs.

- **The binary is `keyd.rvaiya` on Debian/Ubuntu.** No `keyd` alias, no
  alternatives entry; the systemd unit calls the full path. `modules/keyd.sh`
  resolves the name rather than hardcoding either form.
- **The package postinst starts the daemon before the config is linked in**, so
  it comes up with *no* bindings and silently ignores every keyboard. The
  `reload` after linking is load-bearing, not tidiness.
- **keyd has no subcommand that reports grabbed devices.** Its verbs are
  `monitor`, `list-keys`, `reload`, `listen`, `bind`; an unrecognised verb prints
  usage and **exits 0**, so a naive check passes on help text. Verification reads
  the journal instead.
- **keyd exits 15 on SIGTERM** and the packaged unit sets no
  `SuccessExitStatus=15`, so a clean `systemctl stop keyd` leaves the unit in
  `failed` state. Benign — do not treat `is-active` as a health check.

### keyd breaks the touchpad on KDE — and its logs point the wrong way

keyd unconditionally creates a **`keyd virtual pointer`** input device. KDE
classifies that as an external mouse, so with the stock
`DisableEventsOnExternalMouse=true` the real touchpad is disabled for the entire
session.

Symptom: touchpad dead after login, alive the instant keyd is stopped. The logs
actively mislead — keyd reports `DEVICE: ignoring … Touchpad`, which is *true*.
The damage comes from the virtual device it adds, not from anything it grabs, so
narrowing `[ids]` does not help.

Fix: `config/kde/touchpad.conf` sets `DisableEventsOnExternalMouse=false`.
`kcminputrc` keys a touchpad by decimal vendor/product plus name
(`[Libinput][11311][37][VEN_2C2F:00 2C2F:0025 Touchpad]`), which is
machine-specific, so `modules/kde.sh` discovers it from
`/proc/bus/input/devices` rather than hardcoding it.

> Ubuntu's `awk` is **mawk**, which has no `strtonum()`. The hex→decimal
> conversion for those IDs happens in bash for that reason.

## Upstream notes

- **keyd** — `2.5.0` is in Ubuntu *universe*. No third-party repo. Don't add one.
- **Krohnkite** — use the `anametologin` fork. Upstream `esjeon/krohnkite`
  stalled at v0.8.1 and does not run on KWin 6. The release publishes an
  unversioned `krohnkite.kwinscript` asset that tracks the newest build, so
  the "latest" URL needs no version bumping. **Source moved from GitHub to
  Codeberg on 2025-12-11** (`codeberg.org/anametologin/Krohnkite`, capital K —
  GitHub's repo, lowercase, is now archived read-only with no further
  releases). Codeberg runs Forgejo, whose "always newest release" URL shape
  differs from GitHub's: `releases/download/latest/<asset>`, not
  `releases/latest/download/<asset>`. Verified live to resolve to the newest
  *stable* release, skipping a newer prerelease — same semantics as the old
  GitHub URL.
- **Brave extensions** — no CLI exists. Enterprise policy is the only scriptable
  route. Brave has open bugs about this on Linux
  ([#23966](https://github.com/brave/brave-browser/issues/23966),
  [#27149](https://github.com/brave/brave-browser/issues/27149)) — always verify
  at `brave://policy`, never assume it took.
- **Vicinae** — evaluated and deliberately not installed; KRunner holds
  Super+Space. If it's revisited: no `.deb` exists, only an AppImage and a
  tarball, so it needs a real update path rather than an apt repo.
- **Firefox is a snap here.** Its policy path differs from the documented
  `/etc/firefox/policies/` and was never verified. Don't script it blind.

## Testing a change

No automated harness. Verification is:

1. `bash -n` every script you touched.
2. Re-run the single module: `bash linux/install <name>`. It must be clean the
   second time — a second run that repeats work is a bug.
3. For KDE changes: `bash linux/modules/kde.sh --verify`, then log out and back
   in and verify again. The post-relogin check is the one that counts.
