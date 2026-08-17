#!/usr/bin/env bash
# Visual Studio Code.
#
# Config comes from shared/vscode/ because settings.json and keybindings.json are
# genuinely identical across machines -- VS Code handles per-OS differences
# in-file via `.linux`/`.osx` suffixes, so no per-OS fork is needed.

VSCODE_USER_DIR="$HOME/.config/Code/User"
VSCODE_SHARED="$OSZ_SHARED/vscode"

install_vscode () {
	require_linux || return 1

	local name key repo
	IFS='|' read -r name key repo <<< "$APT_REPO_VSCODE"
	apt_repo "$name" "$key" "$repo" || return 1
	apt_install code || return 1

	mkdir -p "$VSCODE_USER_DIR"
	symlink "$VSCODE_SHARED/settings.json"    "$VSCODE_USER_DIR/settings.json"
	symlink "$VSCODE_SHARED/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

	install_vscode_extensions
}

install_vscode_extensions () {
	local list="$VSCODE_SHARED/extensions.txt" ext installed
	[[ -f $list ]] || { skip "no extensions.txt"; return 0; }
	have code || { warn "code not on PATH yet; skipping extensions"; return 0; }

	installed="$(code --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')"
	while read -r ext; do
		ext="${ext%%#*}"; ext="$(echo "$ext" | xargs)"   # strip comments/whitespace
		[[ -z $ext ]] && continue
		if grep -qxF "$(echo "$ext" | tr '[:upper:]' '[:lower:]')" <<< "$installed"; then
			skip "extension already installed: $ext"
		else
			log "installing extension: $ext"
			code --install-extension "$ext" --force || warn "failed to install $ext"
		fi
	done < "$list"
}

# Snapshot the extensions actually installed on this machine back into the repo.
export_vscode_extensions () {
	have code || { err "code not found"; return 1; }
	local list="$VSCODE_SHARED/extensions.txt"
	{
		echo "# OS Zimmee -- VS Code extensions, one marketplace ID per line."
		echo "# Installed by linux/modules/vscode.sh via \`code --install-extension\`."
		echo "# Regenerate from a configured machine with: bash linux/modules/vscode.sh --export"
		code --list-extensions
	} > "$list"
	ok "wrote $list"
}

update_vscode () {
	require_linux || return 1
	install_vscode_extensions
}

uninstall_vscode () {
	require_linux || return 1
	rm -f "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/keybindings.json"
	apt_remove code
	apt_repo_remove vscode
}

# Allow `bash linux/modules/vscode.sh --export` to run standalone.
if [[ "${BASH_SOURCE[0]}" == "${0}" && "${1:-}" == "--export" ]]; then
	source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"
	VSCODE_SHARED="$OSZ_SHARED/vscode"
	export_vscode_extensions
fi
