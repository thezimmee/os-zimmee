#!/usr/bin/env bash
# The shortcut scheme -- binds shared/shortcuts/keymap.conf onto KDE.
#
# THE SPLIT (see shared/shortcuts/README.md S7):
#   shared/shortcuts/keymap.conf   chord    -> action id   cross-OS, portable
#   config/kde/actions.conf        action id -> KDE action  this desktop
#   config/kde/apps.conf           action id -> app         this desktop
# Porting to another desktop means a sibling of the last two, not a rewrite.
#
# WHAT THIS DOES
#   1. Generates the `osz-apps` KWin script (app toggles + quit-application)
#      from apps.conf, installs it, and enables it in kwinrc.
#   2. Generates one systemd user unit per app, so the KWin script can launch
#      something that is not running (KWin's JS engine has no exec; StartUnit
#      over D-Bus is the way out, and it runs inside the user session already).
#   3. Generates the `osz-snapcycle` KWin script (edge snap, cycling sizes)
#      from snapcycle.conf, installs it, and enables it in kwinrc.
#   4. Writes every chord into kglobalshortcutsrc, AND asserts it live over
#      D-Bus so the change takes effect without a logout.
#
# BOTH WRITES ARE REQUIRED, and this is the subtle part:
#   - The FILE alone is not live. Plasma 6 Wayland has no kglobalaccel daemon;
#     KWin hosts the registry in-process and reads the file at login.
#   - D-BUS alone is not persistent. setForeignShortcutKeys updates the live
#     registry; the file can still read `none` right after. Verified: a live
#     rebind was readable over D-Bus while the file was unchanged.
#   - registerShortcut()'s default applies only on FIRST registration. After
#     that KDE treats the stored value as authoritative and a changed default
#     does nothing. This is exactly why KrohnkiteFocusRight once sat unbound.
#     So nothing here relies on a default -- every binding is asserted.

# Paths below need $OSZ_ROOT, which lib.sh derives. When this file is sourced by
# linux/install that has already happened; when it is run standalone (--verify,
# --owner) it has not, and the assignments would silently resolve to '/...'.
if [[ -z ${OSZ_LIB_LOADED:-} ]]; then
	source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"
fi

KEYMAP="$OSZ_ROOT/shared/shortcuts/keymap.conf"
ACTIONS_CONF="$OSZ_LINUX/config/kde/actions.conf"
APPS_CONF="$OSZ_LINUX/config/kde/apps.conf"
SNAPCYCLE_CONF="$OSZ_LINUX/config/kde/snapcycle.conf"
KWINSCRIPT_ID="osz-apps"
KWINSCRIPT_SRC="$OSZ_LINUX/kwin-scripts/$KWINSCRIPT_ID"
KWINSCRIPT_SNAP_ID="osz-snapcycle"
KWINSCRIPT_SNAP_SRC="$OSZ_LINUX/kwin-scripts/$KWINSCRIPT_SNAP_ID"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"

# --- Qt keycodes ------------------------------------------------------------
# Shortcuts cross D-Bus as Qt key codes, not strings.
_QT_SHIFT=$((0x02000000)); _QT_CTRL=$((0x04000000))
_QT_ALT=$((0x08000000));   _QT_META=$((0x10000000))

# Named (non-alphanumeric) keys, using the spellings keymap.conf is normalised to.
_qt_named_key () {
	case "$1" in
		Space)      echo $((0x20)) ;;
		Apostrophe) echo $((0x27)) ;;
		Comma)      echo $((0x2C)) ;;
		Period)     echo $((0x2E)) ;;
		Semicolon)  echo $((0x3B)) ;;
		Backslash)  echo $((0x5C)) ;;
		Minus)      echo $((0x2D)) ;;
		Equal)      echo $((0x3D)) ;;
		Slash)      echo $((0x2F)) ;;
		Escape)     echo $((0x01000000)) ;;
		Tab)        echo $((0x01000001)) ;;
		Backspace)  echo $((0x01000003)) ;;
		Return)     echo $((0x01000004)) ;;
		Enter)      echo $((0x01000005)) ;;
		Delete)     echo $((0x01000007)) ;;
		Print)      echo $((0x01000009)) ;;
		Home)       echo $((0x01000010)) ;;
		End)        echo $((0x01000011)) ;;
		Left)       echo $((0x01000012)) ;;
		Up)         echo $((0x01000013)) ;;
		Right)      echo $((0x01000014)) ;;
		Down)       echo $((0x01000015)) ;;
		PgUp)       echo $((0x01000016)) ;;
		PgDown)     echo $((0x01000017)) ;;
		Menu)       echo $((0x01000055)) ;;
		# Shifted symbols, produced by _fold_shift. For printable ASCII the Qt
		# key code IS the ASCII value.
		'"') echo $((0x22)) ;;  '<') echo $((0x3C)) ;;  '>') echo $((0x3E)) ;;
		':') echo $((0x3A)) ;;  '|') echo $((0x7C)) ;;  '_') echo $((0x5F)) ;;
		'+') echo $((0x2B)) ;;  '?') echo $((0x3F)) ;;
		'!') echo $((0x21)) ;;  '@') echo $((0x40)) ;;  '#') echo $((0x23)) ;;
		'$') echo $((0x24)) ;;  '%') echo $((0x25)) ;;  '^') echo $((0x5E)) ;;
		'&') echo $((0x26)) ;;  '*') echo $((0x2A)) ;;  '(') echo $((0x28)) ;;
		')') echo $((0x29)) ;;  '~') echo $((0x7E)) ;;
		Pause)      echo $((0x01000008)) ;;
		# F1..F35 are sequential from Qt::Key_F1. These matter more than they
		# look: Alt+F4 and Meta+F1 arrive here as preserved DEFAULT chords, and
		# an unmapped one used to be dropped silently from the live list.
		F[0-9]|F[12][0-9]|F3[0-5])
			echo $((0x01000030 + ${1#F} - 1)) ;;
		*)          echo "" ;;
	esac
}

# _qt_keycode "Meta+Ctrl+Shift+Apostrophe" -> integer, or empty if unmappable
_qt_keycode () {
	local chord="$1" part total=0 key="" IFS='+'
	local -a parts
	read -ra parts <<< "$chord"
	for part in "${parts[@]}"; do
		case "$part" in
			Meta|Super) total=$((total + _QT_META)) ;;
			Ctrl)  total=$((total + _QT_CTRL)) ;;
			Alt)   total=$((total + _QT_ALT)) ;;
			Shift) total=$((total + _QT_SHIFT)) ;;
			*)     key="$part" ;;
		esac
	done
	[[ -z $key ]] && { echo ""; return 1; }
	local code
	if [[ ${#key} -eq 1 && $key == [a-zA-Z] ]]; then
		# Qt uses the UPPERCASE letter code regardless of Shift.
		printf -v code '%d' "'${key^^}"
	elif [[ ${#key} -eq 1 && $key == [0-9] ]]; then
		printf -v code '%d' "'$key"
	else
		code="$(_qt_named_key "$key")"
	fi
	[[ -z $code ]] && { echo ""; return 1; }
	echo $((total + code))
}

# KWin FOLDS Shift into the symbol for any key whose shifted form is a different
# character. Its own bindings prove it: Previous Layout ships as `Meta+|`, not
# `Meta+Shift+\\`; Walk Through Windows (Reverse) is `Meta+~`; zoom-in is
# `Meta++`. Pressing hyper+shift+' therefore emits `Meta+Ctrl+"` with NO Shift
# modifier, so a binding stored as `Meta+Ctrl+Shift+Apostrophe` never matches --
# it stores and reads back perfectly and simply never fires.
#
# Letters and arrows are unaffected: Shift+h is still Shift plus Key_H, and
# arrows have no shifted form. Only these do. (US layout; a different layout
# would need a different table, which is why this lives in the Linux backend and
# not in the cross-OS keymap.)
_shifted_symbol () {
	case "$1" in
		Apostrophe) echo '"' ;;   Comma) echo '<' ;;   Period) echo '>' ;;
		Semicolon)  echo ':' ;;   Backslash) echo '|' ;;
		Minus)      echo '_' ;;   Equal) echo '+' ;;   Slash) echo '?' ;;
		1) echo '!' ;;  2) echo '@' ;;  3) echo '#' ;;  4) echo '$' ;;  5) echo '%' ;;
		6) echo '^' ;;  7) echo '&' ;;  8) echo '*' ;;  9) echo '(' ;;  0) echo ')' ;;
		*) echo '' ;;
	esac
}

# Rewrite 'Meta+Ctrl+Shift+Comma' -> 'Meta+Ctrl+<' when the key has a shifted
# form. Leaves letters and arrows alone.
_fold_shift () {
	local chord="$1"
	[[ $chord != *Shift* ]] && { echo "$chord"; return; }
	local key="${chord##*+}" sym
	sym="$(_shifted_symbol "$key")"
	[[ -z $sym ]] && { echo "$chord"; return; }
	# Drop the Shift token wherever it sits -- it is part of the symbol now.
	local -a parts out=(); local pIFS=$IFS p
	IFS='+' read -ra parts <<< "${chord%+*}"
	IFS=$pIFS
	for p in "${parts[@]}"; do
		[[ $p == Shift ]] && continue
		out+=("$p")
	done
	local mods; printf -v mods '%s+' "${out[@]}"
	echo "${mods}${sym}"
}

# Normalise a keymap chord to the spelling KDE uses.
#   'Hyper+Shift+L'   -> 'Meta+Ctrl+Shift+L'   (Hyper IS Meta+Ctrl; see keyd config)
#   'Super+Shift+5'   -> 'Meta+Shift+5'        (KDE spells the Super key 'Meta')
# The Super rewrite is easy to miss: without it 'Super' parses as the KEY rather
# than a modifier, and the chord silently loses its Meta bit.
_expand_chord () {
	local c="${1/#Hyper+/Meta+Ctrl+}"
	c="${c/#Super+/Meta+}"
	_fold_shift "$c"
}

# --- config readers ---------------------------------------------------------
# Trim leading/trailing whitespace from a variable IN PLACE, via nameref --
# pure parameter expansion, no subshell and no external process. Config
# parsing runs this over every field of every row (~90+ rows across the four
# conf files), so avoiding a fork-per-field here is not cosmetic: the
# 'echo "$x" | xargs' idiom this replaced forked and exec'd twice per field.
_trim_var () {
	local -n __osz_trim_var="$1"
	__osz_trim_var="${__osz_trim_var#"${__osz_trim_var%%[![:space:]]*}"}"
	__osz_trim_var="${__osz_trim_var%"${__osz_trim_var##*[![:space:]]}"}"
}

# Emit 'chord|action|tier' for every real row, comments and blanks stripped.
_read_keymap () {
	local line c a t
	[[ -f $KEYMAP ]] || { err "missing $KEYMAP"; return 1; }
	while IFS= read -r line; do
		line="${line%%#*}"
		[[ -z "${line// }" ]] && continue
		IFS='|' read -r c a t _ <<< "$line"
		_trim_var c; _trim_var a; _trim_var t
		[[ -z $c || -z $a ]] && continue
		printf '%s|%s|%s\n' "$c" "$a" "$t"
	done < "$KEYMAP"
}

# Emit 'action|component|key' from actions.conf, plus the generated app rows.
_read_actions () {
	local line a comp key
	[[ -f $ACTIONS_CONF ]] || { err "missing $ACTIONS_CONF"; return 1; }
	while IFS= read -r line; do
		line="${line%%#*}"
		[[ -z "${line// }" ]] && continue
		IFS='|' read -r a comp key _ <<< "$line"
		_trim_var a; _trim_var comp; _trim_var key
		[[ -z $a || -z $comp || -z $key ]] && continue
		printf '%s|%s|%s\n' "$a" "$comp" "$key"
	done < "$ACTIONS_CONF"
	# app.* live in the generated KWin script, under the kwin component.
	local cls did label
	while IFS='|' read -r a cls did label; do
		[[ -z $a ]] && continue
		printf '%s|kwin|%s\n' "$a" "$(_osz_action_name "$a")"
	done < <(_read_apps)
}

# Emit 'action|class|desktop-id|label'
_read_apps () {
	local line a cls did label
	[[ -f $APPS_CONF ]] || { err "missing $APPS_CONF"; return 1; }
	while IFS= read -r line; do
		line="${line%%#*}"
		[[ -z "${line// }" ]] && continue
		IFS='|' read -r a cls did label _ <<< "$line"
		_trim_var a; _trim_var cls; _trim_var did; _trim_var label
		[[ -z $a || -z $cls || -z $did ]] && continue
		printf '%s|%s|%s|%s\n' "$a" "$cls" "$did" "$label"
	done < "$APPS_CONF"
}

# '1/3' -> '0.333333', '0.5' -> '0.500000'. Bash has no floats, hence awk.
_frac_to_decimal () {
	awk -v v="$1" 'BEGIN {
		if (split(v, a, "/") == 2) printf "%.6f", a[1] / a[2]
		else                       printf "%.6f", v
	}'
}

# Emit 'direction|dec1,dec2,...' for every row in snapcycle.conf.
_read_snapcycle () {
	local line dir fracs f dec out
	[[ -f $SNAPCYCLE_CONF ]] || { err "missing $SNAPCYCLE_CONF"; return 1; }
	while IFS= read -r line; do
		line="${line%%#*}"
		[[ -z "${line// }" ]] && continue
		IFS='|' read -r dir fracs <<< "$line"
		_trim_var dir
		[[ -z $dir ]] && continue
		out=""
		local -a farr; IFS=',' read -ra farr <<< "$fracs"
		for f in "${farr[@]}"; do
			_trim_var f
			[[ -z $f ]] && continue
			dec="$(_frac_to_decimal "$f")"
			out+="${dec},"
		done
		[[ -z $out ]] && continue
		printf '%s|%s\n' "$dir" "${out%,}"
	done < "$SNAPCYCLE_CONF"
}

# app.brave -> OszAppBrave   (the KWin script's registerShortcut name)
_osz_action_name () {
	local a="${1#app.}" first rest
	first="$(echo "${a:0:1}" | tr '[:lower:]' '[:upper:]')"
	echo "OszApp${first}${a:1}"
}

# app.brave -> osz-app-brave.service
_osz_unit_name () { echo "osz-app-${1#app.}.service"; }

# --- systemd user units -----------------------------------------------------
# KWin's JS engine has no exec. It does have callDBus, and systemd's StartUnit
# has a trivial (ss) signature -- verified working, it returned a job path and
# the process actually started. The unit runs inside the user session, which
# already carries WAYLAND_DISPLAY / DISPLAY / DBUS_SESSION_BUS_ADDRESS, so no
# environment has to be reconstructed.
#
# ExecStart is resolved from the desktop entry's Exec line rather than assumed
# from the binary name: VS Code's is /usr/share/code/code, which no amount of
# guessing at "code" would have produced.
_desktop_exec () {
	local did="$1" f ex bin
	for f in "$HOME/.local/share/applications/$did" "/usr/share/applications/$did" \
	         "/var/lib/flatpak/exports/share/applications/$did"; do
		[[ -f $f ]] && break
	done
	[[ -f $f ]] || { echo ""; return 1; }
	# Strip XDG field codes (%U %F %u %f %i %c %k ...); systemd wants a plain argv.
	ex="$(grep -m1 '^Exec=' "$f" | sed 's/^Exec=//; s/ *%[A-Za-z]//g')"
	[[ -z $ex ]] && { echo ""; return 1; }
	bin="${ex%% *}"
	# systemd requires an absolute ExecStart.
	if [[ $bin != /* ]]; then
		local abs; abs="$(command -v "$bin" 2>/dev/null)" || { echo ""; return 1; }
		ex="${abs}${ex#"$bin"}"
	fi
	echo "$ex"
}

write_app_units () {
	local a cls did label unit exec_line written=0
	mkdir -p "$SYSTEMD_USER_DIR"
	while IFS='|' read -r a cls did label; do
		[[ -z $a ]] && continue
		exec_line="$(_desktop_exec "$did")"
		if [[ -z $exec_line ]]; then
			warn "no usable Exec for ${did}; ${a} will activate but not launch"
			continue
		fi
		unit="$(_osz_unit_name "$a")"
		cat > "$SYSTEMD_USER_DIR/$unit" <<UNIT
# Generated by linux/modules/shortcuts.sh from config/kde/apps.conf. Do not edit.
# Exists so the osz-apps KWin script can launch ${label} via StartUnit -- KWin's
# JS engine has no exec. Resolved from ${did}.
[Unit]
Description=OS Zimmee: launch ${label}
PartOf=graphical-session.target

[Service]
Type=simple
ExecStart=${exec_line}
Slice=app.slice
UNIT
		ok "unit ${unit} -> ${exec_line}"
		written=$((written + 1))
	done < <(_read_apps)
	[[ $written -gt 0 ]] && systemctl --user daemon-reload
	log "wrote ${written} app units"
}

# --- the osz-apps KWin script ----------------------------------------------
generate_kwin_script () {
	local a cls did label rows="" quit_desc="Quit application"
	mkdir -p "$KWINSCRIPT_SRC/contents/code"

	while IFS='|' read -r a cls did label; do
		[[ -z $a ]] && continue
		rows+="    { action: \"$(_osz_action_name "$a")\", label: \"${label}\", cls: \"${cls,,}\", unit: \"$(_osz_unit_name "$a")\" },"$'\n'
	done < <(_read_apps)

	cat > "$KWINSCRIPT_SRC/metadata.json" <<META
{
    "KPlugin": {
        "Id": "${KWINSCRIPT_ID}",
        "Name": "OS Zimmee app toggles",
        "Description": "Toggle-to-app shortcuts and quit-application, generated from apps.conf",
        "Version": "1.0",
        "License": "MIT",
        "Authors": [ { "Name": "OS Zimmee" } ],
        "EnabledByDefault": true
    },
    "X-Plasma-API": "javascript",
    "X-Plasma-MainScript": "code/main.js",
    "KPackageStructure": "KWin/Script"
}
META

	cat > "$KWINSCRIPT_SRC/contents/code/main.js" <<'JSHEAD'
// GENERATED by linux/modules/shortcuts.sh from linux/config/kde/apps.conf.
// Do not edit here -- edit apps.conf and re-run `bash linux/install shortcuts`.
//
// Toggle semantics:  focused -> minimize, running -> activate, absent -> launch.
//
// Launching is the interesting part. KWin's JS engine has no exec, so a script
// cannot start a program directly. It does have callDBus, and systemd's
// StartUnit takes a plain (ss) signature, so each app ships a generated user
// unit and we ask systemd to start it. The unit runs inside the user session,
// which already has WAYLAND_DISPLAY and the session bus.
//
// NOTE the default passed to registerShortcut below is deliberately empty.
// KDE applies a registerShortcut default only on FIRST registration; after that
// the stored value wins and changing the default silently does nothing. Every
// binding is asserted from the repo instead -- see modules/shortcuts.sh.

// KWin 6 renamed these; keep working on either.
function allWindows() {
    return (typeof workspace.windowList === "function")
        ? workspace.windowList()
        : workspace.clientList();
}
function activeWindow() {
    return (workspace.activeWindow !== undefined)
        ? workspace.activeWindow
        : workspace.activeClient;
}
function setActive(w) {
    if (workspace.activeWindow !== undefined) { workspace.activeWindow = w; }
    else { workspace.activeClient = w; }
}
function classOf(w) {
    return String(w.resourceClass || "").toLowerCase();
}

function windowsOfClass(cls) {
    var all = allWindows(), out = [], i;
    for (i = 0; i < all.length; i++) {
        if (all[i] && classOf(all[i]) === cls) { out.push(all[i]); }
    }
    return out;
}

function launch(unit, label) {
    callDBus("org.freedesktop.systemd1",
             "/org/freedesktop/systemd1",
             "org.freedesktop.systemd1.Manager",
             "StartUnit", unit, "replace",
             function (job) { print("OSZ: launched " + label + " (" + job + ")"); });
}

function toggle(app) {
    var wins = windowsOfClass(app.cls);
    if (wins.length === 0) { launch(app.unit, app.label); return; }

    var active = activeWindow();
    if (active && classOf(active) === app.cls) {
        active.minimized = true;                 // focused -> get out of the way
        return;
    }
    // Prefer a window on the current desktop, else just take the first.
    var target = wins[0], i;
    for (i = 0; i < wins.length; i++) {
        if (wins[i].onAllDesktops || wins[i].desktops === undefined
            || wins[i].desktops.indexOf(workspace.currentDesktop) !== -1) {
            target = wins[i]; break;
        }
    }
    target.minimized = false;
    setActive(target);
}

// Close every window belonging to the active window's app. KDE has no
// "quit application" action -- Window Close closes exactly one window.
function quitApp() {
    var active = activeWindow();
    if (!active) { return; }
    var cls = classOf(active);
    var wins = windowsOfClass(cls), i;
    for (i = 0; i < wins.length; i++) {
        if (typeof wins[i].closeWindow === "function") { wins[i].closeWindow(); }
    }
    print("OSZ: quit " + cls + " (" + wins.length + " window(s))");
}

var APPS = [
JSHEAD
	printf '%s' "$rows" >> "$KWINSCRIPT_SRC/contents/code/main.js"
	cat >> "$KWINSCRIPT_SRC/contents/code/main.js" <<'JSTAIL'
];

(function () {
    for (var i = 0; i < APPS.length; i++) {
        (function (app) {
            registerShortcut(app.action, "OS Zimmee: " + app.label, "",
                             function () { toggle(app); });
        })(APPS[i]);
    }
    registerShortcut("OszQuitApp", "OS Zimmee: Quit application", "", quitApp);
    print("OSZ: registered " + (APPS.length + 1) + " shortcuts");
})();
JSTAIL
	ok "generated ${KWINSCRIPT_ID} (${#rows} bytes of app table)"
}

# --- the osz-snapcycle KWin script -------------------------------------------
# Edge-snap a floating window, cycling through the fractions configured per
# direction in snapcycle.conf. The current step is read off the window's
# ACTUAL geometry (matched against each candidate within a tolerance) rather
# than counted key-presses -- so switching windows/desktops between presses
# never leaves the cycle in a stale state, and a manual resize just becomes
# "no match, start the cycle over" instead of a wrong step.
generate_snapcycle_script () {
	local dir fracs rows=""
	mkdir -p "$KWINSCRIPT_SNAP_SRC/contents/code"

	while IFS='|' read -r dir fracs; do
		[[ -z $dir ]] && continue
		rows+="    ${dir}: [${fracs}],"$'\n'
	done < <(_read_snapcycle)
	[[ -z $rows ]] && { err "no directions found in $SNAPCYCLE_CONF"; return 1; }

	cat > "$KWINSCRIPT_SNAP_SRC/metadata.json" <<META
{
    "KPlugin": {
        "Id": "${KWINSCRIPT_SNAP_ID}",
        "Name": "OS Zimmee window snap-cycle + maximize",
        "Description": "Snap-cycle sizes (snapcycle.conf) and the native-maximize escape hatch",
        "Version": "1.0",
        "License": "MIT",
        "Authors": [ { "Name": "OS Zimmee" } ],
        "EnabledByDefault": true
    },
    "X-Plasma-API": "javascript",
    "X-Plasma-MainScript": "code/main.js",
    "KPackageStructure": "KWin/Script"
}
META

	cat > "$KWINSCRIPT_SNAP_SRC/contents/code/main.js" <<'JSHEAD'
// GENERATED by linux/modules/shortcuts.sh from linux/config/kde/snapcycle.conf.
// Do not edit here -- edit snapcycle.conf and re-run `bash linux/install shortcuts`.
//
// Each direction cycles through its configured width/height fractions in
// order, wrapping at the end. The step is inferred from the window's actual
// geometry rather than tracked press-by-press.
//
// clientArea mode 0 is PlacementArea (screen area minus panels) -- the same
// call Krohnkite itself makes: workspace.clientArea(0, output, desktop). See
// ~/.local/share/kwin/scripts/krohnkite/contents/code/script.js.

var TOLERANCE = 6; // px slack when matching the window's geometry to a step

var CYCLES = {
JSHEAD
	printf '%s' "$rows" >> "$KWINSCRIPT_SNAP_SRC/contents/code/main.js"
	cat >> "$KWINSCRIPT_SNAP_SRC/contents/code/main.js" <<'JSTAIL'
};

function activeWindow() {
    return (workspace.activeWindow !== undefined)
        ? workspace.activeWindow
        : workspace.activeClient;
}

function usableArea(win) {
    return workspace.clientArea(0, win.output, workspace.currentDesktop);
}

// frameGeometry's getter hands back a live QRect wrapper, not an immutable
// value -- confirmed live: saving it directly and later reassigning
// frameGeometry on the SAME window mutated the "saved" copy right along with
// it, so a restore-to-previous-size ended up restoring to the just-set size
// instead. Always clone before holding onto one.
function cloneRect(r) {
    return { x: r.x, y: r.y, width: r.width, height: r.height };
}

// A plain {x,y,width,height} object, NOT Qt.rect(...) -- the Qt QML global is
// only injected under X-Plasma-API "declarativescript" (how Krohnkite's own
// main.qml gets it). Under plain "javascript" (this script) Qt is undefined,
// and frameGeometry's setter accepts the plain object just as well.
function candidateRect(direction, area, fraction) {
    var w, h;
    switch (direction) {
        case "left":
            w = Math.round(area.width * fraction);
            return { x: area.x, y: area.y, width: w, height: area.height };
        case "right":
            w = Math.round(area.width * fraction);
            return { x: area.x + area.width - w, y: area.y, width: w, height: area.height };
        case "top":
            h = Math.round(area.height * fraction);
            return { x: area.x, y: area.y, width: area.width, height: h };
        case "bottom":
            h = Math.round(area.height * fraction);
            return { x: area.x, y: area.y + area.height - h, width: area.width, height: h };
    }
}

function closeEnough(a, b) {
    return Math.abs(a.x - b.x) <= TOLERANCE && Math.abs(a.y - b.y) <= TOLERANCE
        && Math.abs(a.width - b.width) <= TOLERANCE && Math.abs(a.height - b.height) <= TOLERANCE;
}

// Krohnkite's own move, one direction short of Krohnkite's own "grow/shrink"
// vocabulary -- these are its Shift{Left,Right,Up,Down} actions, the same
// ones Hyper+Shift+Alt+<direction> already fires directly (see keymap.conf).
function fallbackActionFor(direction) {
    switch (direction) {
        case "left": return "KrohnkiteShiftLeft";
        case "right": return "KrohnkiteShiftRight";
        case "top": return "KrohnkiteShiftUp";
        case "bottom": return "KrohnkiteShiftDown";
    }
}

function invokeGlobalShortcut(name) {
    callDBus("org.kde.kglobalaccel", "/component/kwin",
             "org.kde.kglobalaccel.Component", "invokeShortcut", name,
             function () {});
}

// A tiling layout (Krohnkite's Tiled/Maximized states) reasserts its own
// geometry on a window it manages -- confirmed live: setting frameGeometry
// sticks immediately, then gets silently overwritten back once something next
// triggers Krohnkite's relayout (typically well under a second; ordinary
// desktop activity is enough). There is no cross-script way to ask Krohnkite
// "is this window actually tiled right now" -- its state is a private closure
// inside its own script instance, and window.tile (KWin's NATIVE tiling
// concept) stays null regardless, since Krohnkite manages geometry directly
// rather than through it. So instead of asking first, this watches what
// actually happens: if frameGeometry changes again shortly after ours, that
// wasn't the user, and the fallback move (the same action
// Hyper+Shift+Alt+<direction> invokes) reproduces what a real move would have
// done -- more useful than a snap that will not hold.
var PENDING_WIN = null, PENDING_HANDLER = null, PENDING_TARGET = null;
var PENDING_FALLBACK = null, PENDING_DEADLINE = 0;

function clearPending() {
    if (PENDING_WIN && PENDING_HANDLER) {
        try { PENDING_WIN.frameGeometryChanged.disconnect(PENDING_HANDLER); } catch (e) {}
    }
    PENDING_WIN = null; PENDING_HANDLER = null; PENDING_TARGET = null; PENDING_FALLBACK = null;
}

function onPendingGeometryChanged() {
    var win = PENDING_WIN, target = PENDING_TARGET, fallback = PENDING_FALLBACK, deadline = PENDING_DEADLINE;
    if (!win) { return; }
    if (Date.now() > deadline) { clearPending(); return; }  // window's closed -- give up quietly
    // frameGeometry only actually updates on the NEXT layout pass, so the
    // first fire after our assignment is usually just confirming it landed --
    // stay connected rather than disconnecting here, since a real revert (if
    // one comes) is a SEPARATE, later fire and would otherwise be missed.
    var current;
    // The window can close between watchForRevert() connecting and this
    // signal firing, leaving win a dangling reference to a destroyed KWin
    // object -- reading a property off it can throw. Nothing useful to do at
    // that point (there is no window left to move), so give up quietly.
    try { current = win.frameGeometry; } catch (e) { clearPending(); return; }
    if (closeEnough(current, target)) { return; }
    clearPending();               // a genuine mismatch: something else (Krohnkite) changed it back
    invokeGlobalShortcut(fallback);
}

// Shared by snapCycle and toggleNativeMaximize: after WIN's frameGeometry is
// set to TARGET, watch for a revert and invoke FALLBACK if one happens.
function watchForRevert(win, target, fallback) {
    PENDING_WIN = win;
    PENDING_TARGET = target;
    PENDING_FALLBACK = fallback;
    PENDING_DEADLINE = Date.now() + 1500;
    PENDING_HANDLER = onPendingGeometryChanged;
    win.frameGeometryChanged.connect(PENDING_HANDLER);
}

function snapCycle(direction) {
    var win = activeWindow();
    if (!win) { return; }
    var fractions = CYCLES[direction];
    if (!fractions || fractions.length === 0) { return; }

    // Maximized/fullscreen hides the window's real geometry -- clear both so
    // there is a real rect to compare against and to land on.
    if (win.fullScreen) { win.fullScreen = false; }
    if (win.maximizeMode !== undefined && win.maximizeMode !== 0) { win.setMaximize(false, false); }

    clearPending(); // a fresh press supersedes whatever the last one was watching

    var area = usableArea(win);
    var current = win.frameGeometry;
    var step = -1, i;
    for (i = 0; i < fractions.length; i++) {
        if (closeEnough(current, candidateRect(direction, area, fractions[i]))) { step = i; break; }
    }
    var next = (step + 1) % fractions.length;
    var target = candidateRect(direction, area, fractions[next]);
    win.frameGeometry = target;
    watchForRevert(win, target, fallbackActionFor(direction));
}

registerShortcut("OszSnapLeft", "OS Zimmee: Snap window left (cycle sizes)", "",
                 function () { snapCycle("left"); });
registerShortcut("OszSnapRight", "OS Zimmee: Snap window right (cycle sizes)", "",
                 function () { snapCycle("right"); });
registerShortcut("OszSnapTop", "OS Zimmee: Snap window top (cycle sizes)", "",
                 function () { snapCycle("top"); });
registerShortcut("OszSnapBottom", "OS Zimmee: Snap window bottom (cycle sizes)", "",
                 function () { snapCycle("bottom"); });

// The incremental move (Hyper+Shift+Alt+i/j/k/l), edge-aware on a FLOATING
// window. Krohnkite's own ShiftLeft/Right/Up/Down (what these actions bound
// to directly before this script existed) nudges a floating window by a
// fixed 5% step via moveFloat() in its own script.js -- with NO clamping to
// the screen: repeated presses walk it straight off the edge. Same 5% step
// here (so the feel is unchanged), but x/y are clamped to the usable area, so
// a step that would carry the window past an edge instead lands it exactly
// on the edge -- the "snap" the plain Krohnkite action never had.
//
// On a TILED window this is meaningless -- Krohnkite's ShiftLeft/Right/Up/Down
// swaps the window's position in the master/stack order there, not a pixel
// move, and only Krohnkite's own engine knows that order. Same "watch what
// actually happens" pattern as snapCycle: try the clamped geometry write,
// and if Krohnkite reverts it (this window is Tiled, not Floating), fall back
// to invoking the real KrohnkiteShift* action so tile-order move keeps
// working exactly as before this script existed.
var MOVE_STEP_FRACTION = 0.05; // matches Krohnkite's own moveFloat() step

function moveStep(direction) {
    var win = activeWindow();
    if (!win) { return; }
    if (win.fullScreen) { win.fullScreen = false; }
    if (win.maximizeMode !== undefined && win.maximizeMode !== 0) { win.setMaximize(false, false); }

    clearPending(); // a fresh press supersedes whatever the last one was watching

    var area = usableArea(win);
    var current = win.frameGeometry;
    var x = current.x, y = current.y;
    switch (direction) {
        case "left":  x -= area.width * MOVE_STEP_FRACTION; break;
        case "right": x += area.width * MOVE_STEP_FRACTION; break;
        case "up":    y -= area.height * MOVE_STEP_FRACTION; break;
        case "down":  y += area.height * MOVE_STEP_FRACTION; break;
    }
    // The clamp IS the snap: bound x/y so the window's far edge can never
    // pass the usable area's edge.
    x = Math.max(area.x, Math.min(x, area.x + area.width - current.width));
    y = Math.max(area.y, Math.min(y, area.y + area.height - current.height));
    var target = { x: Math.round(x), y: Math.round(y), width: current.width, height: current.height };

    win.frameGeometry = target;
    watchForRevert(win, target, fallbackActionFor(direction));
}

registerShortcut("OszMoveStepLeft", "OS Zimmee: Move window left (edge-snapping step)", "",
                 function () { moveStep("left"); });
registerShortcut("OszMoveStepRight", "OS Zimmee: Move window right (edge-snapping step)", "",
                 function () { moveStep("right"); });
registerShortcut("OszMoveStepUp", "OS Zimmee: Move window up (edge-snapping step)", "",
                 function () { moveStep("up"); });
registerShortcut("OszMoveStepDown", "OS Zimmee: Move window down (edge-snapping step)", "",
                 function () { moveStep("down"); });

// The native-maximize escape hatch (Hyper+Shift+O), NOT KWin's real "Window
// Maximize" -- that flips window.maximizeMode, which fires Krohnkite's own
// maximizedAboutToChange listener and forces WindowState.NativeMaximized, a
// state its tileable check explicitly excludes (confirmed live: focus/move
// stop seeing the window for as long as it stays maximized). Setting
// frameGeometry directly to the full usable area never touches maximizeMode
// at all, so Krohnkite never excludes the window -- nav keeps working. Meant
// for a genuinely floating window; on one Krohnkite still manages, the same
// watchForRevert() as snapCycle notices the geometry not holding and falls
// back to the nav-safe monocle maximize (the same action Hyper+M invokes)
// rather than silently doing nothing.
var MAXIMIZE_MEMORY = {}; // internalId -> pre-maximize geometry

function toggleNativeMaximize() {
    var win = activeWindow();
    if (!win) { return; }
    if (win.fullScreen) { win.fullScreen = false; }
    if (win.maximizeMode !== undefined && win.maximizeMode !== 0) { win.setMaximize(false, false); }
    var id = String(win.internalId);
    var area = usableArea(win);
    var full = { x: area.x, y: area.y, width: area.width, height: area.height };

    clearPending();

    if (MAXIMIZE_MEMORY[id] && closeEnough(win.frameGeometry, full)) {
        win.frameGeometry = MAXIMIZE_MEMORY[id];
        delete MAXIMIZE_MEMORY[id];
        return;
    }

    MAXIMIZE_MEMORY[id] = cloneRect(win.frameGeometry);
    win.frameGeometry = full;
    watchForRevert(win, full, "KrohnkiteMonocleLayout");
}

registerShortcut("OszMaximizeToggle", "OS Zimmee: Maximize window (native, literal edge-to-edge)", "",
                 toggleNativeMaximize);

print("OSZ: registered 4 snap-cycle shortcuts + 4 move-step shortcuts + 1 maximize toggle");
JSTAIL
	ok "generated ${KWINSCRIPT_SNAP_ID} (${#rows} bytes of cycle table)"
}

install_kwin_script () {
	local id="$1" src="$2"
	have kpackagetool6 || { err "kpackagetool6 not found"; return 1; }
	local action=install
	kpackagetool6 --type=KWin/Script --list 2>/dev/null | grep -qx "$id" && action=upgrade
	# kpackagetool6 takes a DIRECTORY here; there is no zip step.
	if ! kpackagetool6 --type=KWin/Script "--${action}" "$src" >/dev/null 2>&1; then
		err "kpackagetool6 --${action} failed for $src"; return 1
	fi
	ok "kwin script ${action}ed: ${id}"
	# A KWin script is inert until enabled in kwinrc.
	kwriteconfig6 --file kwinrc --group Plugins --key "${id}Enabled" true
	ok "enabled ${id} in kwinrc"

	# `kwin reconfigure` alone does NOT reload an already-running script's code --
	# verified: upgrading osz-snapcycle in place and reconfiguring left the OLD
	# code running (its startup print never re-appeared) until the plugin was
	# toggled off and back on. Same family of gotcha as Krohnkite's config-reload
	# quirk in linux/CLAUDE.md. Only needed on an upgrade -- a fresh install has
	# nothing running yet to fail to reload.
	if [[ $action == upgrade ]] && have qdbus6; then
		kwriteconfig6 --file kwinrc --group Plugins --key "${id}Enabled" false
		qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1
		kwriteconfig6 --file kwinrc --group Plugins --key "${id}Enabled" true
		qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1
		ok "forced ${id} to reload its updated code"
	fi
}

# The LIVE component name and the FILE group are not the same thing for
# .desktop services: kglobalaccel calls it 'org.kde.spectacle.desktop', while
# kglobalshortcutsrc nests it as [services][org.kde.spectacle.desktop]. Writing
# the flat name creates a junk top-level group that KDE then ignores.
_file_group_for_component () {
	case "$1" in
		*.desktop) echo "services/$1" ;;
		*)         echo "$1" ;;
	esac
}

# --- binding ----------------------------------------------------------------
# Chords the keymap explicitly disables -- never re-add one while merging.
_disabled_chords () {
	local chord action tier
	while IFS='|' read -r chord action tier; do
		[[ $action == none ]] && _expand_chord "$chord"
	done < <(_read_keymap)
}

# The merged active chord list for an action, one chord per line.
#
# Our chord comes first, then the action's DEFAULT chords, so native bindings
# survive: binding sys.close would otherwise take Alt+F4 away from Window Close,
# and Meta+F1 away from Switch to Desktop 1. Merging against the DEFAULT field
# (never the current active) is what keeps this idempotent -- defaults do not
# change, so a re-run produces the same list.
#
# Two kinds of chord are never merged back in:
#   - anything inside the hyper layer, which is ours by definition
#   - anything the keymap disables outright
#
# DEFAULTS is passed in by the caller (already read once) rather than queried
# here -- this and _write_binding used to each independently kreadconfig6 the
# same field for the same action, doubling the read-side subprocess count
# across every action in apply_keymap.
_merged_chords () {
	local comp="$1" key="$2" chord="$3" defaults="$4"
	printf '%s\n' "$chord"
	[[ -z $defaults || $defaults == none ]] && return 0
	local -a dparts; local d
	IFS=$'\t' read -ra dparts <<< "$defaults"
	for d in "${dparts[@]}"; do
		[[ -z $d || $d == "$chord" ]] && continue
		[[ $d == Meta+Ctrl+* ]] && continue
		grep -qxF "$d" <<< "${OSZ_DISABLED_CHORDS:-}" && continue
		printf '%s\n' "$d"
	done
}

# kwriteconfig6/kreadconfig6 take one --group per nesting level.
_group_args () {
	local comp="$1" g; local -a groups
	IFS='/' read -ra groups <<< "$comp"
	printf '%s\n' --file kglobalshortcutsrc
	for g in "${groups[@]}"; do printf '%s\n%s\n' --group "$g"; done
}

# Field N of an action's "active,default,description" value.
_config_field () {
	local comp="$1" key="$2" n="$3"; local -a ga
	mapfile -t ga < <(_group_args "$comp")
	kreadconfig6 "${ga[@]}" --key "$key" 2>/dev/null | cut -d, -f"$n"
}

# Write the merged active list to kglobalshortcutsrc, preserving the default
# field. DEFAULTS is passed in by the caller -- see _merged_chords above for
# why this no longer queries it itself.
_write_binding () {
	local comp="$1" key="$2" desc="$3" defaults="$4"; shift 4
	local -a chords=("$@") ga
	mapfile -t ga < <(_group_args "$comp")
	local active
	printf -v active '%s\t' "${chords[@]}"; active="${active%$'\t'}"
	kwriteconfig6 "${ga[@]}" --key "$key" "${active},${defaults},${desc}"
}

# Assert the same list on the LIVE registry, so it works without a logout.
# It must be the SAME list: setForeignShortcutKeys replaces the whole key list,
# so sending only our chord makes KWin flush the merged natives back out again.
# Silence is fine -- kglobalaccel refuses actions it has never seen (a KWin
# script that has not loaded yet), and the file write still covers that case.
_apply_live () {
	local comp="$1" key="$2"; shift 2
	local unique="${comp##*/}" arg="" c code
	for c in "$@"; do
		code="$(_qt_keycode "$c")"
		# Bail rather than send a PARTIAL list. setForeignShortcutKeys replaces
		# the whole list, so quietly skipping one unmappable chord would make
		# KWin flush it out of the file too -- which is exactly how Alt+F4 got
		# lost before F-keys were in the table. The file write already holds the
		# full truth; a relogin picks it up.
		if [[ -z $code ]]; then
			warn "cannot map '${c}' to a Qt keycode; leaving ${key} to the file only"
			return 1
		fi
		arg+="([${code},0,0,0],),"
	done
	[[ -z $arg ]] && return 1
	gdbus call --session --dest org.kde.kglobalaccel --object-path /kglobalaccel \
		--method org.kde.KGlobalAccel.setForeignShortcutKeys \
		"['${unique}','${key}','','']" "[${arg%,}]" >/dev/null 2>&1
}

# Who owns a chord right now? Empty means free.
# This asks the RUNNING compositor, not the file, and that distinction matters:
# shortcuts registered from a .desktop (X-KDE-Shortcuts) are live in KWin but
# absent from kglobalshortcutsrc until something overrides them, so a file-based
# check reports them FREE. A live sweep is what found Spectacle sitting on
# Meta+Ctrl+R and Meta+Ctrl+Print, inside the hyper layer.
shortcut_owner_live () {
	local code; code="$(_qt_keycode "$(_expand_chord "$1")")" || return 1
	[[ -z $code ]] && return 1
	gdbus call --session --dest org.kde.kglobalaccel --object-path /kglobalaccel \
		--method org.kde.KGlobalAccel.getGlobalShortcutsByKey "$code" 2>/dev/null \
		| grep -oE "^\(\[\('[^']*', '[^']*', '[^']*'" | sed "s/^(\[('//; s/', '/ | /g; s/'$//"
}

# Release a chord from whatever currently holds it.
# Needed because kglobalaccel does NOT transfer a contested chord -- it clears
# the NEW binding and leaves the incumbent in place, silently. Observed with
# Meta+Ctrl+Left: "Switch One Desktop to the Left" kept it and
# "Switch to Previous Desktop" was written back as empty. Krohnkite's actions
# happened to transfer, which makes this failure easy to miss on a partial test.
_release_chord () {
	local chord="$1" want_key="$2" owner okey odesc ocomp ogroup odefaults
	owner="$(shortcut_owner_live "$chord")"
	[[ -z $owner ]] && return 1
	okey="$(echo "$owner"  | awk -F' \\| ' '{print $1}')"
	odesc="$(echo "$owner" | awk -F' \\| ' '{print $2}')"
	ocomp="$(echo "$owner" | awk -F' \\| ' '{print $3}')"
	[[ -z $ocomp ]] && ocomp=kwin
	# Already ours: nothing to do.
	[[ -n $want_key && $okey == "$want_key" ]] && return 1
	ogroup="$(_file_group_for_component "$ocomp")"
	odefaults="$(_config_field "$ogroup" "$okey" 2)"
	_write_binding "$ogroup" "$okey" "$odesc" "$odefaults" "none"
	gdbus call --session --dest org.kde.kglobalaccel --object-path /kglobalaccel \
		--method org.kde.KGlobalAccel.setForeignShortcutKeys \
		"['${ocomp}','${okey}','','']" "[]" >/dev/null 2>&1
	echo "${ocomp}/${okey}"
	return 0
}

apply_keymap () {
	local chord action tier expanded code comp key
	# Computed once; _write_binding consults it when merging default chords.
	export OSZ_DISABLED_CHORDS; OSZ_DISABLED_CHORDS="$(_disabled_chords)"
	local bound=0 released=0 unmapped=0 live=0
	declare -A ACTION_COMP ACTION_KEY
	while IFS='|' read -r a c k; do
		ACTION_COMP["$a"]="$c"; ACTION_KEY["$a"]="$k"
	done < <(_read_actions)

	# --- pass 1: release every chord we are about to claim --------------------
	# Done as a separate pass so that an action losing one chord here can still
	# be given another one below, whatever order the keymap lists them in.
	while IFS='|' read -r chord action tier; do
		[[ $chord == Tap ]] && continue
		local freed
		if freed="$(_release_chord "$chord" "${ACTION_KEY[$action]:-}")"; then
			ok "released $(_expand_chord "$chord") (was ${freed})"
			released=$((released + 1))
		fi
	done < <(_read_keymap)

	# --- pass 2: assert every binding ----------------------------------------
	while IFS='|' read -r chord action tier; do
		[[ $chord == Tap ]] && continue          # the tap is keyd's job
		[[ $action == none ]] && continue        # pass 1 already unbound it
		expanded="$(_expand_chord "$chord")"

		comp="${ACTION_COMP[$action]:-}"; key="${ACTION_KEY[$action]:-}"
		if [[ -z $comp ]]; then
			warn "no Linux implementation for action '${action}' (${expanded})"
			unmapped=$((unmapped + 1)); continue
		fi

		local -a chords
		local defaults; defaults="$(_config_field "$comp" "$key" 2)"
		mapfile -t chords < <(_merged_chords "$comp" "$key" "$expanded" "$defaults")
		_write_binding "$comp" "$key" "$key" "$defaults" "${chords[@]}" \
			|| { warn "file write failed: ${expanded}"; continue; }
		bound=$((bound + 1))
		_apply_live "$comp" "$key" "${chords[@]}" && live=$((live + 1))
	done < <(_read_keymap)

	log "released ${released}, bound ${bound} chords (${live} applied live), ${unmapped} unmapped"
	[[ $unmapped -gt 0 ]] && warn "unmapped actions have no binding; add them to config/kde/actions.conf"
	[[ $bound -gt 0 ]]
}

install_shortcuts () {
	require_linux || return 1
	require_kde || return 1
	have kwriteconfig6 || { err "kwriteconfig6 not found"; return 1; }
	have kreadconfig6  || { err "kreadconfig6 not found"; return 1; }
	have gdbus        || { err "gdbus not found (glib2 tools)"; return 1; }

	# kglobalshortcutsrc holds every shortcut on the system, not just ours.
	local rc="$HOME/.config/kglobalshortcutsrc"
	if [[ -f $rc && ! -f "${rc}.osz-original" ]]; then
		cp "$rc" "${rc}.osz-original"
		ok "backed up original -> ${rc}.osz-original"
	fi

	write_app_units      || return 1
	generate_kwin_script || return 1
	install_kwin_script "$KWINSCRIPT_ID" "$KWINSCRIPT_SRC" || return 1
	generate_snapcycle_script || return 1
	install_kwin_script "$KWINSCRIPT_SNAP_ID" "$KWINSCRIPT_SNAP_SRC" || return 1

	# Load the script before binding, so kglobalaccel knows its actions and the
	# live assertions can land instead of being silently dropped.
	have qdbus6 && qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 && ok "kwin reconfigured"

	apply_keymap || return 1

	# A second reconfigure picks up anything registered during the first.
	have qdbus6 && qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1

	ok "shortcuts applied; most take effect immediately"
	warn "log out and back in if any chord does not respond"
	warn "verify with: bash linux/modules/shortcuts.sh --verify"
}

update_shortcuts () { install_shortcuts; }

uninstall_shortcuts () {
	require_linux || return 1
	local a cls did label
	while IFS='|' read -r a cls did label; do
		[[ -z $a ]] && continue
		rm -f "$SYSTEMD_USER_DIR/$(_osz_unit_name "$a")"
	done < <(_read_apps)
	systemctl --user daemon-reload
	kwriteconfig6 --file kwinrc --group Plugins --key "${KWINSCRIPT_ID}Enabled" false
	kpackagetool6 --type=KWin/Script --remove "$KWINSCRIPT_ID" >/dev/null 2>&1
	kwriteconfig6 --file kwinrc --group Plugins --key "${KWINSCRIPT_SNAP_ID}Enabled" false
	kpackagetool6 --type=KWin/Script --remove "$KWINSCRIPT_SNAP_ID" >/dev/null 2>&1
	have qdbus6 && qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1
	ok "osz-apps and osz-snapcycle removed and units deleted"
	warn "chord bindings are NOT auto-reverted; restore from"
	warn "  ~/.config/kglobalshortcutsrc.osz-original"
}

# --- verification -----------------------------------------------------------
# Reads the LIVE registry, chord by chord, straight from keymap.conf.
verify_shortcuts () {
	local chord action tier expanded owner ok_n=0 bad_n=0 free_n=0
	declare -A ACTION_KEY
	while IFS='|' read -r a c k; do ACTION_KEY["$a"]="$k"; done < <(_read_actions)

	printf '%-24s %-24s %s\n' CHORD ACTION 'LIVE OWNER'
	printf '%-24s %-24s %s\n' ------ ------ ----------
	while IFS='|' read -r chord action tier; do
		[[ $chord == Tap ]] && continue
		expanded="$(_expand_chord "$chord")"
		owner="$(shortcut_owner_live "$chord")"
		if [[ $action == none ]]; then
			if [[ -z $owner ]]; then
				printf '%-24s %-24s %s\n' "$expanded" "(unbound)" 'free  OK'; ok_n=$((ok_n+1))
			else
				printf '%-24s %-24s %s\n' "$expanded" "(unbound)" "STILL TAKEN: $owner"; bad_n=$((bad_n+1))
			fi
			continue
		fi
		local want="${ACTION_KEY[$action]:-}"
		if [[ -z $owner ]]; then
			printf '%-24s %-24s %s\n' "$expanded" "$action" 'NOT BOUND'; free_n=$((free_n+1))
		elif [[ $owner == "$want"* ]]; then
			printf '%-24s %-24s %s\n' "$expanded" "$action" "OK  ($want)"; ok_n=$((ok_n+1))
		else
			printf '%-24s %-24s %s\n' "$expanded" "$action" "MISMATCH: $owner"; bad_n=$((bad_n+1))
		fi
	done < <(_read_keymap)
	echo
	echo "ok=${ok_n}  not-bound=${free_n}  wrong=${bad_n}"
	[[ $bad_n -eq 0 && $free_n -eq 0 ]]
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	case "${1:-}" in
		--verify) verify_shortcuts ;;
		--owner)
			shift
			[[ -z ${1:-} ]] && { echo "usage: shortcuts.sh --owner 'Hyper+B'" >&2; exit 1; }
			out="$(shortcut_owner_live "$1")"
			if [[ -z $out ]]; then echo "FREE: $(_expand_chord "$1")"
			else echo "TAKEN: $(_expand_chord "$1")"; echo "$out"; fi ;;
		*) echo "usage: shortcuts.sh [--verify | --owner <chord>]" >&2; exit 1 ;;
	esac
fi
