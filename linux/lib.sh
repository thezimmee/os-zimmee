#!/usr/bin/env bash
# Shared helpers for the Linux install modules.
# Sourced by linux/install, linux/uninstall, linux/update and every modules/*.sh.
# Safe to source more than once.

[[ -n "${OSZ_LIB_LOADED:-}" ]] && return 0
OSZ_LIB_LOADED=1

# --- output -----------------------------------------------------------------
# Colors only when stdout is a terminal, so logs pipe cleanly.
if [[ -t 1 ]]; then
	_c_reset=$'\033[0m'; _c_blue=$'\033[34m'; _c_green=$'\033[32m'
	_c_yellow=$'\033[33m'; _c_red=$'\033[31m'; _c_dim=$'\033[2m'
else
	_c_reset=''; _c_blue=''; _c_green=''; _c_yellow=''; _c_red=''; _c_dim=''
fi

log ()  { echo "${_c_blue}[i]${_c_reset} $*"; }
ok ()   { echo "${_c_green}[ok]${_c_reset} $*"; }
warn () { echo "${_c_yellow}[!]${_c_reset} $*" >&2; }
err ()  { echo "${_c_red}[x]${_c_reset} $*" >&2; }
step () { echo; echo "${_c_blue}==>${_c_reset} $*"; }
skip () { echo "${_c_dim}[-] $*${_c_reset}"; }

# confirm <prompt> [default:y|n]
confirm () {
	local prompt="$1" default="${2:-y}" reply hint
	[[ $default == y ]] && hint='Y/n' || hint='y/N'
	# Non-interactive runs take the default rather than hanging on read.
	if [[ ! -t 0 ]]; then
		[[ $default == y ]] && return 0 || return 1
	fi
	read -r -p "[?] ${prompt} (${hint}) " reply
	reply=${reply:-$default}
	[[ $reply =~ ^([yY][eE][sS]|[yY])$ ]]
}

# --- environment ------------------------------------------------------------
have () { command -v "$1" >/dev/null 2>&1; }

# Resolve the repo root from this file's location, so every script works no
# matter where it is invoked from.
OSZ_ROOT="${OSZ_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export OSZ_ROOT
export OSZ_LINUX="$OSZ_ROOT/linux"
export OSZ_SHARED="$OSZ_ROOT/shared"

# Bail early rather than half-applying a config on the wrong OS.
require_linux () {
	if [[ "$(uname -s)" != Linux ]]; then
		err "This module is Linux-only (detected $(uname -s)). Skipping."
		return 1
	fi
}

require_kde () {
	if [[ "${XDG_CURRENT_DESKTOP:-}" != *KDE* ]]; then
		warn "KDE Plasma not detected (XDG_CURRENT_DESKTOP='${XDG_CURRENT_DESKTOP:-unset}')."
		confirm "Continue anyway?" n || return 1
	fi
}

# Prime the sudo timestamp up front so password prompts don't appear
# unexpectedly in the middle of a long run.
require_sudo () {
	if [[ $EUID -eq 0 ]]; then
		err "Do not run this as root. It installs user config into \$HOME."
		return 1
	fi
	have sudo || { err "sudo not found."; return 1; }
	sudo -v || return 1
}

# --- filesystem -------------------------------------------------------------
# symlink <source> <dest>
# Idempotent. Backs up anything real already sitting at <dest>.
symlink () {
	local src="$1" dest="$2"
	[[ -e $src ]] || { err "symlink source missing: $src"; return 1; }
	mkdir -p "$(dirname "$dest")"
	if [[ -L $dest ]]; then
		if [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
			skip "already linked: $dest"
			return 0
		fi
		rm -f "$dest"
	elif [[ -e $dest ]]; then
		local backup="${dest}.osz-backup.$(date +%Y%m%d%H%M%S)"
		warn "backing up existing $dest -> $backup"
		mv "$dest" "$backup"
	fi
	ln -s "$src" "$dest"
	ok "linked $dest -> $src"
}

# sudo_symlink <source> <dest> -- same, for root-owned destinations
sudo_symlink () {
	local src="$1" dest="$2"
	[[ -e $src ]] || { err "symlink source missing: $src"; return 1; }
	sudo mkdir -p "$(dirname "$dest")"
	if [[ -L $dest && "$(sudo readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
		skip "already linked: $dest"
		return 0
	fi
	if [[ -e $dest || -L $dest ]]; then
		local backup="${dest}.osz-backup.$(date +%Y%m%d%H%M%S)"
		warn "backing up existing $dest -> $backup"
		sudo mv "$dest" "$backup"
	fi
	sudo ln -s "$src" "$dest"
	ok "linked $dest -> $src"
}

# --- apt --------------------------------------------------------------------
OSZ_APT_REFRESHED=0

# apt_repo <name> <key-url> <repo-line>
# Installs a dearmored key into /etc/apt/keyrings and writes a .list file.
# Idempotent; flags the cache as stale when anything changes.
apt_repo () {
	local name="$1" key_url="$2" repo_line="$3"
	local keyring="/etc/apt/keyrings/${name}.gpg"
	local list="/etc/apt/sources.list.d/${name}.list"
	local changed=0

	sudo install -d -m 0755 /etc/apt/keyrings

	if [[ ! -s $keyring ]]; then
		log "fetching signing key for ${name}"
		# Fetch to a temp file first so a failed download can't write a
		# truncated keyring that apt would then choke on.
		local tmp; tmp="$(mktemp)"
		if ! curl -fsSL "$key_url" -o "$tmp"; then
			err "failed to download key: $key_url"; rm -f "$tmp"; return 1
		fi
		# The key may be armored or already binary; gpg --dearmor handles
		# armored input, so fall back to a straight copy for binary keys.
		if ! gpg --dearmor < "$tmp" | sudo tee "$keyring" >/dev/null 2>&1; then
			sudo cp "$tmp" "$keyring"
		fi
		sudo chmod 0644 "$keyring"
		rm -f "$tmp"
		changed=1
	else
		skip "keyring present: $keyring"
	fi

	local line="deb [arch=$(dpkg --print-architecture) signed-by=${keyring}] ${repo_line}"
	if [[ ! -f $list ]] || ! grep -qxF "$line" "$list"; then
		echo "$line" | sudo tee "$list" >/dev/null
		ok "wrote $list"
		changed=1
	else
		skip "repo present: $list"
	fi

	[[ $changed -eq 1 ]] && OSZ_APT_REFRESHED=0
	return 0
}

apt_refresh () {
	if [[ $OSZ_APT_REFRESHED -eq 1 ]]; then
		skip "apt cache already refreshed this run"
		return 0
	fi
	log "apt update"
	sudo apt-get update -qq && OSZ_APT_REFRESHED=1
}

# apt_install <pkg>...  -- skips anything already installed
apt_install () {
	local pkg missing=()
	for pkg in "$@"; do
		if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed"; then
			skip "already installed: $pkg"
		else
			missing+=("$pkg")
		fi
	done
	[[ ${#missing[@]} -eq 0 ]] && return 0
	apt_refresh
	log "installing: ${missing[*]}"
	sudo apt-get install -y "${missing[@]}"
}

apt_remove () {
	local pkg present=()
	for pkg in "$@"; do
		dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed" && present+=("$pkg")
	done
	[[ ${#present[@]} -eq 0 ]] && { skip "nothing to remove"; return 0; }
	sudo apt-get remove -y "${present[@]}"
}

# apt_repo_remove <name> -- drops the .list and keyring written by apt_repo
apt_repo_remove () {
	local name="$1"
	sudo rm -f "/etc/apt/sources.list.d/${name}.list" "/etc/apt/keyrings/${name}.gpg"
	ok "removed apt repo: ${name}"
}
