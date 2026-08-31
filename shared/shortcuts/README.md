# The OS Zimmee shortcut scheme

One keyboard scheme for macOS, Linux and Windows. `keymap.conf` next to this
file is the machine-readable source of truth; this document is the reasoning.

**The one-sentence version:** CapsLock is the only prefix. Tap it for the
launcher; hold it and press a **letter** to reach an app, **h/j/k/l** to move
around windows, **arrows or digits** to move around workspaces, and add
**Shift** to bring the window with you.

---

## 1. Priorities this was designed against

1. **Muscle memory transfers across all three OSes.** Optimised for over local
   elegance on any one platform.
2. **Everything installs programmatically.** A binding that needs a trip through
   System Settings does not exist.
3. **The tiling WM is first-class**, not a Shift-modified afterthought.

OS weighting: **macOS** is the primary work OS and therefore the binding
constraint; **Linux** (Kubuntu/KDE + Krohnkite) is the primary personal/work OS and
where the real WM lives; **Windows** is secondary.

---

## 2. Decision: the hyper key is `Super+Ctrl`, on all three OSes

`CapsLock` held emits **Super+Ctrl** (`Meta+Ctrl` on Linux/Windows, `Cmd+Ctrl`
on macOS — the same physical keys and the same keycode). Tapped alone it opens
the launcher.

This is what Linux already does. It was re-evaluated from scratch rather than
assumed, because the decision propagates into every other line of the scheme.

| Candidate                           | macOS (primary)                                                                              | Linux                                                    | Windows                                                                                        | Verdict                                                                         |
| ----------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| **Super+Ctrl**                      | Only 3 system chords taken: `Space`, `F`, `Q` — and all three are _semantically useful_ (§4) | Audited; 13 active chords, most already ours             | `D`, `C`, `N`, `O`, `Q`, `S`, `Enter`, `F4`, `←/→` — all interceptable by AHK                  | **Chosen**                                                                      |
| Super+Alt                           | `Cmd+Opt+<letter>` is heavily used by apps (`Cmd+Opt+I`, `Cmd+Opt+Esc`, `Cmd+Opt+D`)         | 5 collisions, fixable                                    | `Win+Alt+<digit>` opens taskbar jump lists — already a known problem in `autohotkey/hyper.ahk` | Rejected: worst on the primary OS                                               |
| Ctrl+Alt                            | Common in-app chord                                                                          | Ctrl+Alt+F1–F12 switch VTs; equals AltGr on many layouts | Equals AltGr                                                                                   | Rejected (already rejected on Linux for this reason)                            |
| Ctrl+Alt+Shift+Super ("true hyper") | Cleanest collision-wise                                                                      | Clean                                                    | Clean                                                                                          | Rejected: baking Shift into the prefix destroys `Hyper+Shift` as a second layer |
| Super+Shift                         | —                                                                                            | —                                                        | —                                                                                              | Rejected, same reason                                                           |

Super+Ctrl also survives the one test that matters for shared app config: VS Code
spells it `ctrl+meta+<key>` and resolves `meta` to Cmd on macOS and Super
elsewhere, so a single `shared/vscode/keybindings.json` line is literally
portable.

**No modifier is swapped on any OS.** See §8.

---

## 3. Decision: the hyper key is also the _only_ WM prefix

There were two competing prefixes — Krohnkite's stock bare-`Super` bindings and
the hyper layer. This scheme retires bare Super entirely and folds the WM onto
hyper.

The deciding argument is Windows, and it is a hard one:

> **`Win+L` cannot be intercepted.** It is registered by `winlogon` as a secure
> attention sequence. AutoHotkey can _detect_ it but cannot suppress it — the
> workstation locks anyway.

So `Super+H/J/K/L` — the i3/Krohnkite convention — is structurally impossible to
carry to Windows. Any scheme built on bare Super has a permanent hole in it on
one of the three machines, in the _focus-right_ key, one of the most-pressed
bindings in a tiling workflow. `Meta+Ctrl+L` has no such problem anywhere.

Three further arguments point the same way:

- **Bare Super stays native everywhere.** `Win+E`, `Win+R`, `Meta+Space`
  (KRunner — the CapsLock tap target), KDE quick-tile, `Meta+<digit>` taskbar:
  all untouched. That is the KISS principle paying out, and it is why Windows no
  longer needs any Win-key remap.
- **macOS has no bare-Super WM story at all.** Cmd is Cmd; `Cmd+H/J/K/L` are
  app-level chords that a WM cannot take.
- **One prefix, one mental model.** Everything global goes through one physical
  key.

### How the WM gets to be first-class without a second prefix

Not by adding a modifier, but by **partitioning the key space by key semantics**:

| Key family              | Layer                        | Why it can't collide                          |
| ----------------------- | ---------------------------- | --------------------------------------------- |
| **i k**                 | focus up / down, directional | Directional, never a mnemonic                 |
| **j l**                 | focus prev / next, circular  | Ordinal; works in every layout                 |
| **'**                   | layout cycling               | Punctuation, so never confusable with an app  |
| **arrows**              | previous / next workspace    | Directional; native on KDE and Windows        |
| **u i o p**             | apps                         | Positional, deliberately not mnemonic         |
| **d**                   | next display (circular)      | One key; two displays make prev/next the same |
| **digits 1–9**          | workspaces, absolute         | Never a mnemonic                              |
| **Shift + a direction** | "carry the window with me"   | Consistent wherever a direction appears       |

The WM gets the home row — the best real estate on the keyboard — which is what
"first-class" actually means. And critically, **the existing muscle memory
survives**: `hyper + <letter>` is still "switch to an app", and
`hyper + Shift + <direction>` is still "move the window". The scheme is
additive, not a relearn.

---

## 4. The three macOS system chords do not constrain us

macOS owns `Ctrl+Cmd+Space` (Character Viewer), `Ctrl+Cmd+F` (Full Screen) and
`Ctrl+Cmd+Q` (Lock Screen). An earlier draft of this document treated them as
immovable and built around them. They are not immovable.

**Karabiner-Elements intercepts at the DriverKit level, before macOS dispatches
system hotkeys.** A carve-out maps CapsLock+`<key>` to any output at all, so
macOS never sees the `Ctrl+Cmd+<key>` chord. The native binding still fires when
the physical modifiers are pressed.

That has three consequences worth stating plainly:

- **Any hyper chord can be reclaimed on macOS.** The three above are not a
  reserved set; they are three chords where passing through happens to be an
  option.
- **`Hyper+W` = close window works on all three OSes**, via a carve-out
  emitting a plain `Cmd+W`. The action is genuinely identical, not merely
  analogous. (Quit used to live here too; it has since moved to the bare
  native chord — see §9 and §12.)
- **`Hyper+F` is free to mean "float"**, which is used far more often in a
  tiling workflow than fullscreen. Fullscreen drops to `Hyper+Shift+F`, tier 2,
  and macOS's native `Ctrl+Cmd+F` still works on the physical modifiers.

`Hyper+Space` is left unbound, so the Character Viewer keeps that chord on macOS
for free. The emoji picker lives on `Hyper+Alt+Space` — which keeps the shape of
the `Ctrl+Alt+Space` it replaces while staying inside the one-prefix rule, and
whose extra Alt separates it from the bare CapsLock *tap* that opens the
launcher, so a slip cannot fire the wrong one.

**This is the load-bearing fact for the whole scheme.** Without carve-outs, the
primary work OS would dictate three bindings; with them, the hyper layer is
ours outright on all three machines.

---

## 5. What Linux and Windows give us for free

The workspace layer costs almost nothing, because both other OSes already put it
on the same chords:

| Chord                 | KDE default                            | Windows default        | What we bind                    |
| --------------------- | -------------------------------------- | ---------------------- | ------------------------------- |
| `Hyper+←` / `Hyper+→` | Switch One Desktop to the Left / Right | Switch virtual desktop | Switch to Previous/Next Desktop |
| `Hyper+Shift+←` / `→` | Window One Desktop to the Left / Right | _(none)_               | Window to Previous/Next Desktop |

The only change on Linux is grid-directional → **circular**, so the chord and its
meaning are unchanged and it now wraps at the ends. On Windows the native
binding already is prev/next.

This also dissolves the collision the brief flagged. `hyper+Shift+<arrows>` vs
KDE's "Window One Desktop to the …" is not a conflict — it is exactly the
binding this scheme wants, already installed.

`Hyper+Esc` gets the same treatment in reverse: KDE's Kill Window still fires
there and we leave it alone, but it is **not** part of the taught scheme — it
would be a dead key on two of three machines. No reason to unbind a native
escape hatch; every reason not to teach it.

---

## 6. The keymap

Chords use the portable `Hyper` token. Modifier order is always Hyper → Shift →
Alt. `keymap.conf` beside this file is the machine-readable original; if the two
ever disagree, the `.conf` wins.

### Three rules are the whole scheme

1. **Window navigation uses two models, one per axis.**

   ```
   I  focus up        directional — precise, walks the current column
   K  focus down      and stops cleanly at its ends

   J  focus previous  circular — walks the whole list in visual order
   L  focus next      and wraps
   ```

   **Measured, not assumed.** Directional up/down walks a column correctly.
   Directional left/right did not — from the master it jumped to the *bottom* of
   the stack rather than the nearest window — so it was replaced by circular
   next/previous, which covers master↔stack properly and is the model Krohnkite
   inherits from dwm.

   The two are complementary, not redundant: circular crosses between master and
   stack, directional moves precisely inside a column. Maximize is on `M`, centre
   on `C`.
2. **Three scopes**, smallest to largest: `I J K L` move within the current
   workspace, `D` hops to the next display, arrows move between workspaces.
3. **Shift = "carry the window with me"** wherever it sits next to a direction.

### Tier 1 — core. Identical on all three OSes.

| Chord                       | Action                                   |
| --------------------------- | ---------------------------------------- |
| **tap CapsLock**            | Launcher                                 |
| `Hyper+U O P ;`             | Brave / VS Code / Claude / Terminal      |
| `Hyper+I` `Hyper+K`         | Focus up / down (directional)            |
| `Hyper+J` `Hyper+L`         | Focus previous / next (circular, wraps)  |
| `Hyper+Shift+Alt+I J K L`   | Move window up/left/down/right — tile order when tiled (master ↔ stack), edge-snapping step when floating |
| `Hyper+M`                   | Maximize (monocle)                       |
| `Hyper+D`                   | Focus next display (circular)            |
| `Hyper+Shift+D`             | Move window to next display              |
| `Hyper+← →`                 | Previous / next workspace                |
| `Hyper+Shift+← →`           | Move window to previous / next workspace |
| `Hyper+'` `Hyper+Shift+'`   | Next / previous layout                   |
| `Hyper+F`                   | Toggle floating                          |
| `Hyper+W`                   | Close window                             |
| `Ctrl+Q` *(not Hyper)*      | Quit application — Linux/Windows, global |
| `Super+Shift+5`             | Screenshot                               |
| `Super+Shift+4`             | Screen recording                         |

App toggles are a **true toggle**: focused → minimize, running → activate,
not running → launch.

### Tier 2 — extended. May degrade rather than mean something different.

| Chord                | Action                                                  |
| -------------------- | ------------------------------------------------------- |
| `Hyper+Alt+I J K L`  | Grow height / shrink width / shrink height / grow width |
| `Hyper+Shift+I J K L` | Snap window top/left/bottom/right, cycling sizes (Linux only) |
| `Hyper+Shift+F`      | Fullscreen toggle                                       |
| `Hyper+C`            | Centre a floating window on its screen                  |
| `Hyper+Enter`        | Promote to master                                       |
| `Hyper+1…9`          | Go to workspace N                                       |
| `Hyper+Shift+1…9`    | Move window to workspace N                              |
| `Hyper+Alt+Space`    | Emoji picker                                            |

`Hyper+Alt` is the **adjust** layer: it changes the shape of whatever the tier 1
keys select. `Hyper+Shift+Alt+I/J/K/L` (tier 1, table above) stacks "carry the
window with me" (rule 3) on top of that same layer -- it isn't a new idiom,
just the existing one a layer deeper, and it's where the tile-order move lives
now that plain `Hyper+Shift+I/J/K/L` means snap-cycle instead.

### The letter rule

The app positions are positional, not mnemonic, and that is deliberate: with
CapsLock held by the left pinky at home position, the right hand never leaves
its rest. Note these all sit on the **hyper** layer — on bare Super the same
keys are blocked by `Win+L` (unblockable, §3) and by `Cmd+L` / `Cmd+K` being
among the most contested chords on macOS.

This is **not** vim-adjacent: `K` is *down* here and *up* in vim/Vimium, and `J`
is *previous* rather than a direction at all. That is the thing to feel for —
Vimium is live in the browser on all three machines.

`Shift+I/J/K/L` is claimed by snap-cycle (tier 2) rather than the ordinal move
now — snap is reached for more often, so it gets the shallower chord.
Krohnkite's ordinal move (`ShiftUp`/`ShiftDown`/`ShiftLeft`/`ShiftRight`) drops
to `Shift+Alt+I/J/K/L`, stacking rule 3 ("carry the window with me") onto the
`Alt` adjust layer that resize already lives on — not a new idiom, the same one
a layer deeper. On Linux this chord means two different things depending on
window state: tile-order move (Krohnkite's own action, unchanged) on a tiled
window, or an edge-snapping incremental step on a floating one — Krohnkite's
own step has no clamping and will walk a floating window straight off the
screen, so `wm.move.*` routes through a small generated KWin script
(`osz-snapcycle`) that clamps to the usable area instead of Krohnkite's raw
action. See `linux/config/kde/actions.conf`.

If it grates, the fallback is plain `hjkl`, and `keymap.conf` carries a
paste-ready revert block for exactly that: twelve rows plus one optional line to
put the terminal back on `I` and restore the `U I O P` app row. Nothing else in
the scheme depends on which of the two is active.

Reserved, never assign to an app:

`I` `J` `K` `L` (navigation) · `'` (layout) · `U` `O` `P` `;` (apps) ·
`M` (maximize) · `D` (display) · `C` (centre) · `F` (float) · `W` (close) ·
`R` (Spectacle, see below)

Free for more apps: `A B E G H N Q S T V X Y Z` and `,` `.` — `Q` freed up
when quit moved off the Hyper layer; see §9 and §12.

### Key names

Letters and digits are written as themselves; everything else uses its Qt/KDE
name, so no key in `keymap.conf` is ambiguous. `'` is **`Apostrophe`** — Qt
`Key_Apostrophe`, `0x27`, the unshifted key immediately right of `;` on a US
layout. The full translation table (Qt code → AeroSpace → AutoHotkey spelling)
is in the header of `keymap.conf`.

**Shift folds into the symbol.** On Linux, `Hyper+Shift+'` does not reach KWin
as `Meta+Ctrl+Shift+Apostrophe` — pressing it emits `Meta+Ctrl+"`, with the Shift
consumed into the character and **no Shift modifier at all**. KWin's own
bindings show the convention: Krohnkite ships Previous Layout as `Meta+|`, not
`Meta+Shift+\`; Walk Through Windows (Reverse) is `Meta+~`; zoom-in is `Meta++`.

A binding stored the naive way writes and reads back perfectly and then simply
never fires — there is no error anywhere. It cost 14 chords here before it was
caught: every `Hyper+Shift+<digit>`, both screenshot chords, and the layout and
display-move pairs. The Linux backend now folds Shift into the symbol when
emitting chords (`Hyper+Shift+1` → `Meta+Ctrl+!`).

Letters and arrows are unaffected — `Shift+h` really is Shift plus `Key_H`, and
arrows have no shifted form. The fold table is US-layout-specific, which is
exactly why it lives in the Linux backend and not in this cross-OS keymap.

> An earlier draft claimed the opposite, on the strength of a round-trip test
> showing `Meta+Ctrl+Shift+Apostrophe` stored and read back byte-identical. That
> was true and irrelevant: it proved storage, not dispatch.

(`R` is **not** free — Spectacle's *Start/Stop Window Recording* holds
`Meta+Ctrl+R`, and it does not appear in `kglobalshortcutsrc`; see §11.)

> Which app sits on which of `U I O P` has no structural argument behind it.
> Edit the app block in `keymap.conf`; the Linux implementation is data-driven
> from that file, so moving an app is a config edit and a re-run, never a code
> change.

### No dedicated lock chord

Lock is a **launcher action**, not a keybinding. It is infrequent, it is
destructive if mistriggered, and every OS keeps a native fallback regardless:
`Ctrl+Alt+L` on Linux, physical `Ctrl+Cmd+Q` on macOS, `Win+L` on Windows.

`Meta+L` is therefore **actively unbound** on Linux rather than merely unused —
a native lock chord one row from `Meta+K` is a hazard without a matching binding
on the other two machines. Windows cannot unbind it; §9 says why.

Two Spectacle bindings sit *inside* the hyper layer and are unbound on Linux:
`Meta+Ctrl+R` (Record Window) and `Meta+Ctrl+Print` (Capture Window Under
Cursor). Neither appears in `kglobalshortcutsrc` — see §11.

---

## 7. How each OS implements it

Every layer below is a text file in this repo. No layer requires clicking
through a settings UI.

| Layer              | Linux                                                | macOS                                         | Windows                                     |
| ------------------ | ---------------------------------------------------- | --------------------------------------------- | ------------------------------------------- |
| CapsLock dual-role | **keyd** — `/etc/keyd/default.conf`                  | **Karabiner-Elements** — `karabiner.json`     | **AutoHotkey v2** — `hyper.ahk`             |
| Launcher (tap)     | KRunner ← `Meta+Space`                               | Raycast ← `Cmd+Space`                         | PowerToys Run ← `Alt+Space`                 |
| Window manager     | **Krohnkite** (KWin), bound via `kglobalshortcutsrc` | **AeroSpace** — `aerospace.toml`              | **komorebi + whkd**, else AHK Snap fallback |
| App toggles        | `osz-apps` KWin script                               | AeroSpace `exec-and-forget` + a toggle script | AHK                                         |
| Workspaces         | KDE virtual desktops                                 | AeroSpace workspaces                          | `VirtualDesktopAccessor.dll` via AHK        |
| Programmatic?      | yes                                                  | yes                                           | yes                                         |

### Linux portability: KDE is a backend, not the architecture

**Rule: where two mechanisms can do the same job on Linux, take the one that is
not tied to a desktop environment.**

The uncomfortable truth first: on Wayland there is no cross-compositor way to
inspect or move a window. `wmctrl` and `xdotool` were X11 protocol features that
Wayland deliberately did not reproduce, and nothing replaced them. So focus,
move, resize, layout and app-activation are compositor-specific **by
construction** — no choice of tool avoids that.

Portability therefore cannot come from picking a different mechanism. It has to
come from where the seam sits:

| Layer                     | Mechanism                       | Portable?                              |
| ------------------------- | ------------------------------- | -------------------------------------- |
| CapsLock → hyper          | **keyd**, at the evdev layer    | ✅ any distro, any DE, X11/Wayland/TTY |
| Chord → action id         | `shared/shortcuts/keymap.conf`  | ✅ cross-OS, let alone cross-DE        |
| App launch                | systemd user unit → desktop ID  | ✅ any systemd Linux                   |
| Chord → action **binding** | `kglobalshortcutsrc`           | ❌ KDE — but generated, never authored |
| Window / layout actions   | Krohnkite, KWin scripting       | ❌ KWin — unavoidable on Wayland       |

The two non-portable rows are confined to `linux/config/kde/` and one backend
function. Porting to Sway or Hyprland means writing a new emitter against the
same `keymap.conf` — not redesigning anything. That is the whole point of
splitting *chord → action* from *action → implementation*.

Three places this rule changes a concrete choice:

- **Launch by desktop ID, not by binary.** `apps.conf` names
  `code.desktop`, not `code` — more portable *and* more correct, since VS Code's
  actual `Exec` is `/usr/share/code/code`, which the binary name never would
  have found. `gtk-launch` and `gio launch` are both present here; `kstart` is
  the KDE-only option and is not used.
- **systemd user units over KDE service menus** for the launch escape hatch —
  `StartUnit` is DE-agnostic and verified working from KWin JS (§11).
- **keyd carries anything that does not need the compositor.** It already owns
  the hyper key itself, which is the single most portable thing in the stack.

#### keyd `command()`: available, deliberately not used

keyd 2.5.0 *does* support `command(...)` — confirmed directly in the shipped
binary (`command(`, `/bin/sh`, `execl`, `executing command: %s`), even though it
is absent from the packaged man page. In principle the whole app-toggle layer
could live there and be DE-independent.

It is not used, for two reasons:

1. **keyd is a root-owned system daemon**, so `command()` executes as root.
   Getting a GUI app from there into the user's Wayland session means
   re-entering the session with the right `DBUS_SESSION_BUS_ADDRESS` and
   `WAYLAND_DISPLAY` — precisely the fragility the systemd-user-unit path avoids
   by already being *in* the session.
2. **A chord keyd consumes never reaches applications.** The hyper layer has to
   stay visible to apps — `shared/vscode/keybindings.json` binds `ctrl+meta+…`
   directly — and a keyd `command()` binding would swallow it.

Worth re-testing if the KDE backend ever needs replacing wholesale; not worth
the fragility while KWin is the compositor.

### Open risk: Karabiner on a MacBook's built-in keyboard

**Verify this on the actual work Mac before relying on the macOS half.**

macOS 26.4 changed HID access such that DriverKit virtual HID devices could no
longer intercept events from the **built-in** MacBook keyboard; external
keyboards were unaffected
([Karabiner #4402](https://github.com/pqrs-org/Karabiner-Elements/issues/4402),
reported Feb 2026). Since the CapsLock layer is the foundation of this entire
scheme, that would break it on a laptop keyboard.

The issue is now **closed**, and Karabiner 16.0.0 (May 2026) notes that
*"Karabiner-Core-Service now requires Accessibility permission"* — which reads
as the fix. That has not been confirmed on hardware here, so treat it as
resolved-pending-verification rather than resolved.

Two consequences worth planning for:

- Install **Karabiner ≥ 16.0.0** and grant **Accessibility** as well as Input
  Monitoring. Older versions will fail silently on the internal keyboard.
- Accessibility is a TCC permission an **MDM profile can withhold**. On a
  managed work Mac, confirm it can be granted before committing to this scheme
  there. If it cannot, the fallback is `hidutil` (which can remap CapsLock to a
  single modifier but cannot do dual-role tap/hold), which would cost the
  launcher tap.

### Why Raycast is demoted to launcher-only

Raycast hotkeys **cannot be installed programmatically.** Export produces an
encrypted, passphrase-protected `.rayconfig` that must be imported by hand, and
cloud sync is a paid feature. That fails priority 2 outright.

So Raycast keeps exactly **one** hotkey — `Cmd+Space`, the launcher — which is
the single setting you would configure by hand on a new machine anyway. App
toggles and window management move to AeroSpace's TOML, which is a plain file in
this repo.

### Why AeroSpace, not yabai or Amethyst

- **yabai** needs SIP partially disabled for its most useful features. On a
  managed work Mac that may be prohibited outright, and it is a bad dependency
  for the _primary_ machine.
- **Amethyst** works without SIP but its bindings live in its own YAML with a
  fixed vocabulary; it is a window _arranger_ more than an i3-style WM.
- **AeroSpace** never requires disabling SIP, keeps its entire configuration —
  bindings included — in one TOML file, and its command vocabulary (`focus`,
  `move`, `resize`, `workspace`, `move-node-to-workspace`, `fullscreen`,
  `layout`, `exec-and-forget`) maps one-to-one onto this keymap.

### Windows degradation, stated honestly

Without komorebi, `Hyper+J/K/L/;` fall back to AHK-driven Snap: approximate, not
a real tiling layout, but not a dead key either. Moving a window between virtual
desktops has no native Windows shortcut at all and needs
`VirtualDesktopAccessor.dll`. Both are documented degradations, not silent gaps.

---

## 8. No modifier swapping, anywhere

The Windows track currently ships `LAlt::LControl` (Command emulation) and
`LWin::LAlt` in `autohotkey/macos.ahk`. That file is already commented out of
`init.ahk`, so neither is live.

**Decision: leave it that way, and park the file.**

`macos.ahk` stays in the repo but stays out of `init.ahk`, so re-enabling is a
one-line change if the pinky-vs-thumb difference ever proves annoying.

- The hyper scheme no longer needs the Win key freed, which was one of the two
  reasons the swap existed.
- Modifier swapping is the largest single source of cross-machine hesitation:
  the same physical key means different things depending on which laptop you
  are holding.
- The remaining benefit — `Cmd+C` landing on the thumb like it does on a Mac —
  is an _in-app_ concern, orthogonal to this scheme, and each app's own keymap
  already handles it.

This is a genuine trade-off and it is reversible; it is called out here so the
decision is explicit rather than accidental.

---

## 9. Documented divergences

Every place the three OSes differ, and why.

| Divergence                                                                            | Justification                                                                                                                                                                                   |
| ------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **The tap emits a different chord per OS** (`Meta+Space` / `Cmd+Space` / `Alt+Space`) | The _gesture_ is the muscle memory; the emitted chord is invisible. Each OS's launcher has a different native hotkey and forcing one on all three fights the platform for no user-visible gain. |
| `Hyper+↑` / `Hyper+↓` — Linux only (KDE desktop grid)                                 | Unbound elsewhere rather than bound to something else. A key that does nothing on two machines is safer than a key that does three different things.                                            |
| `Hyper+M` — Krohnkite Monocle / AeroSpace accordion / komorebi monocle                | Same intent ("show me one thing, big"), different mechanics. Tier 2.                                                                                                                            |
| `Hyper+Enter` — no AeroSpace equivalent                                               | AeroSpace has no master-stack concept. Left unbound on macOS. Tier 2.                                                                                                                           |
| `Hyper+Shift+←/→` on Windows needs a DLL                                              | No native Windows shortcut exists for moving a window between desktops.                                                                                                                         |
| **`Win+L` survives on Windows** — it is unbound on Linux and absent on macOS | The only way to remove `Win+L` is the `DisableLockWorkstation` policy, which disables locking *system-wide*: it strips Lock from the Start menu and Ctrl+Alt+Del, and makes the `LockWorkStation()` call behind the launcher's Lock entry fail. Losing the ability to lock at all, in order to remove a redundant chord, is a bad trade — so `Win+L` stays. |
| **`⌘⇧4` means region-screenshot on macOS, screen-recording elsewhere** | Chosen deliberately so the two screenshot chords sit adjacent; §12.1 gives two ways to close it. The only Class 2 member that fails test 3 — flagged rather than quietly shipped. |
| **Quit is bare `Ctrl+Q`, global, on Linux/Windows — not on the Hyper layer, and not (yet) mirrored on macOS** | Moved off `Hyper+Q` because it was an awkward reach; `Ctrl+Q` is the everyday app-level quit convention on both OSes already. Accepted knowingly against the Class 3 guidance in §12: as a KDE *global* shortcut it is intercepted before the focused app sees the keypress, which can shadow an app's own non-quit use of `Ctrl+Q` — concretely, terminal Ctrl+S/Ctrl+Q flow control in Warp. If that bites, fix it with a Warp-local override rather than reverting this globally. macOS already has native per-app `Cmd+Q`; the `Hyper+Q` → `Cmd+Q` carve-out this doc used to describe was never actually built in `karabiner.json`, so there is nothing to unwind there — macOS's story for this action is simply open, to settle when that track is migrated. |

---

## 10. What changes on Linux, and what stops being true

Adopting this scheme **reverts** two earlier decisions, both of which existed
only to serve the bare-Super WM prefix that this scheme retires:

- **`Meta+L` is retired outright.** It was moved off Lock Session to
  `Ctrl+Alt+L` so that Krohnkite could claim it for focus-right. Krohnkite no
  longer uses bare Super, so that reason is gone — but rather than restore it,
  `Meta+L` is unbound entirely. Lock has no dedicated chord at all — it is a
  launcher action (§6) — and `Ctrl+Alt+L` stays as the conventional Linux
  fallback. One lock chord that works on all
  three machines beats two that work on two.
- **Krohnkite's resize bindings move** from `Meta+Ctrl+H/J/K/L` to
  `Meta+Ctrl+Alt+J/K/L/;`. The old alignment ("hyper+hjkl = resize") was a happy
  accident; under this scheme those keys are _focus_, which is the far more
  frequent action and deserves the cheaper chord.

Everything else on Linux is either already correct (`Hyper+←/→`,
`Hyper+Shift+←/→`) or a new binding.

---

## 11. Two mechanisms this depends on, both verified

Both were tested on Kubuntu 26.04 / Plasma 6.6 Wayland before the scheme was
committed to.

### A KWin script _can_ launch a non-running app

KWin's JS engine has no `exec`, which is why the app-toggle design was blocked.
It does have `callDBus`, and systemd's `StartUnit` has a trivial `(ss)`
signature. Shipping one user unit per app and calling:

```js
callDBus("org.freedesktop.systemd1", "/org/freedesktop/systemd1",
         "org.freedesktop.systemd1.Manager", "StartUnit",
         "osz-app-brave.service", "replace", function (job) { ... });
```

**Verified working** — the callback returned a job path and the process actually
started. No shell script, no `.desktop` indirection, no per-keypress script
loading.

### Shortcuts can be rebound live, without a relogin

Plasma 6 Wayland has no kglobalaccel daemon, so `kglobalshortcutsrc` edits
normally need a full logout. But `org.kde.kglobalaccel` is on the session bus:

```bash
# rebind at runtime -- keys are Qt keycodes, in a(ai)
gdbus call --session --dest org.kde.kglobalaccel --object-path /kglobalaccel \
  --method org.kde.KGlobalAccel.setForeignShortcutKeys \
  "['kwin','KrohnkiteFocusLeft','','']" "[([335544392,0,0,0],)]"

# and ask who owns a chord, live -- returns [] if free
gdbus call --session --dest org.kde.kglobalaccel --object-path /kglobalaccel \
  --method org.kde.KGlobalAccel.getGlobalShortcutsByKey 335544392
```

**Both verified working.** Qt keycodes: `Meta 0x10000000`, `Ctrl 0x04000000`,
`Alt 0x08000000`, `Shift 0x02000000`, letters `0x41`–`0x5A`.

This makes iterating on the scheme a sub-second loop instead of a logout, and it
is what turns priority 2 from "the file is right" into "the machine is right".

### The file-based owner checker has a blind spot

`kde.sh --owner` reads `kglobalshortcutsrc`. Shortcuts that a `.desktop` file
registers via `X-KDE-Shortcuts` are **live in KWin but absent from that file**
until something overrides them — so the checker confidently reports them FREE.

A full live sweep of the hyper layer found two real collisions that the file
checker missed entirely, both Spectacle's:

```
Hyper+R        RecordWindow                 | Start/Stop Window Recording
Hyper+Print    WindowUnderCursorScreenShot  | Capture Window Under Cursor
```

`getGlobalShortcutsByKey` is therefore the **authoritative** checker and
`--owner` is the offline fallback. Ask the running compositor, not the file.

> Note the file must **still** be written. `registerShortcut()`'s default only
> applies on _first_ registration; after that KDE treats the stored value as
> authoritative. That is exactly why `KrohnkiteFocusRight` sat empty and unbound.
> The repo asserts every binding rather than relying on any default.


---

## 12. Where does a new binding go?

Three classes. Deciding which one a new binding belongs to answers the question
every time; guessing is how a scheme rots.

### Class 1 — the hyper layer

**Anything this scheme invents**: app toggles, window management, workspaces.
Nothing else on any of the three machines claims `Super+Ctrl`, so these bindings
are ours outright, portable by construction, and installable from a text file on
all three OSes. **This is the default home for a new binding.**

### Class 2 — the Super mirror

A short, **explicitly enumerated** list — never a prefix layer — for the case
where *macOS already owns a deeply-ingrained global* `Cmd+<key>` and the same
chord is free on Linux and Windows as `Super+<key>`.

The argument is physical: on a Mac, ⌘ sits immediately left of the space bar; on
a PC keyboard, so does Super. `⌘⇧4` and `Win+Shift+4` are the *same thumb, same
finger, same motion*. Adopting macOS's chord costs nothing on the primary work
OS (zero changes there) and buys real transfer.

Qualifying test — all four must hold:

1. macOS already binds it globally, and the muscle memory is strong.
2. The equivalent `Super+<key>` is free on Linux and Windows.
3. The action means **exactly** the same thing on all three. Not "roughly".
4. It is a *system* action, not something an app implements.

Current members: **screenshots** (§12.1) and the launcher (`Cmd+Space` /
`Meta+Space`, which already agree).

This does qualify the claim in §3 that bare Super stays untouched. Precisely:
bare Super is not a **prefix layer** — it hosts a short enumerated list, and
every addition has to pass the four tests above.

#### 12.1 Screenshots

macOS's `⌘⇧3 / ⌘⇧4 / ⌘⇧5` are as ingrained as any shortcut gets. Two chords are
wanted here, not three; both mirror chords are verified free on this machine.

| Chord | macOS | Linux (Spectacle action) | Windows |
|---|---|---|---|
| `Super+Shift+5` | native — capture UI | `RectangularRegionScreenShot` | AHK → `Win+Shift+S` |
| `Super+Shift+4` | **native — region shot** ⚠ | `RecordRegion` | AHK → Snipping Tool video |

⚠ **This one is a knowing divergence.** On macOS `⌘⇧4` is region-screenshot, so
the same motion screenshots on the Mac and starts a *recording* on Linux and
Windows. That is the "same finger, different outcome" pattern this document
warns about elsewhere; it was chosen with the cost understood, in exchange for
`4` and `5` sitting adjacent.

Two ways to close the gap later, if it grates:

- Displace the macOS default with `defaults write com.apple.symbolichotkeys` —
  programmatic, but fragile across OS updates and may be blocked by MDM.
- Move recording to `Super+Shift+6`, free on all three: only Touch Bar Macs
  claim `⇧⌘6`, and no current MacBook has one.

KDE's own defaults (`Print`, `Meta+Shift+S`, `Shift+Print`, `Meta+Print`) are
**left in place alongside** — they cost nothing, and `Meta+Shift+S` happens to
match Windows' native snip chord.

Two Spectacle bindings must move regardless, because they sit *inside* the hyper
layer: `Meta+Ctrl+R` (Record Window) and `Meta+Ctrl+Print` (Capture Window Under
Cursor).

### Class 3 — native, left alone

**In-app editing chords**: copy, paste, save, undo, close, quit. These stay
divergent per OS (`Cmd+C` / `Ctrl+C`), and where a specific app matters, the fix
is that app's own keymap in `shared/<app>/` — the pattern `shared/vscode/`
already follows.

Do **not** promote these to global chords. Three reasons, in order of severity:

1. **The semantics genuinely differ, and the difference is destructive.**
   `Cmd+W` on macOS closes a *tab* in Brave and VS Code. A global `Super+W`
   bound to KWin's `Window Close` closes the whole *browser*. Same finger,
   catastrophically different outcome — worse than an honest divergence,
   because the muscle memory transfers and the result does not.
2. **They are app-implemented on macOS, not global.** Making them global
   changes their nature, and a global interceptor shadows every app that uses
   the chord for something else — terminals, editors, anything with a Vim mode.
3. **`Super+Q` would sit one dropped modifier away from `Hyper+Q`.** A keyd or
   Karabiner hiccup that loses the Ctrl would fire the global quit on a chord
   you meant as something else.

**Revisited:** a global quit was originally kept on `Hyper+Q` (Class 1) rather
than a bare chord, specifically to avoid this class of problem. That decision
was deliberately reversed for `Ctrl+Q` on Linux/Windows — see §9 — accepting
the collision risk in exchange for the more natural chord. It is still not a
Class 2 member: it fails test 4 (quit is app-implemented, not a system action),
and macOS is left out of this row entirely rather than pretending it fits.

Note what this does *not* do: it does not promote `Cmd+W` to a global.
Close-tab versus close-window is exactly the destructive ambiguity described
above, so close-window stays native (`Ctrl+W` / `Cmd+W` / `Alt+F4`). If a global
close-window is ever wanted, `Hyper+Shift+Q` is free on all three.
