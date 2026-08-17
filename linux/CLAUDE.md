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

**Super+Ctrl is contested on KDE.** It was audited against a stock Plasma 6.6
install; `config/kde/shortcuts.conf` records what was freed and, just as
importantly, what was left alone and why. Re-audit after a Plasma major upgrade:

```bash
awk '/^\[/{sec=$0} /Meta\+Ctrl/{print sec"  ->  "$0}' ~/.config/kglobalshortcutsrc
```

**Krohnkite registers its shortcuts at install time**, so they cannot appear in a
pre-install audit — re-audit *after* installing it. Its resize bindings are
`Meta+Ctrl+H/J/K/L`, which with Hyper = Super+Ctrl arrive as `Hyper+h/j/k/l`.
That alignment is deliberate to keep; it is not a collision.

**Escape hatch:** a keyd config that breaks the keyboard is recoverable by
pressing **backspace + escape + enter** together, which terminates keyd.

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
  `latest/download/` needs no version bumping.
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
