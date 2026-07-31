#!/usr/bin/env bash
# Deploy the AutoHotkey runtime from the WSL canonical repo to a native Windows
# path, so it launches at Windows boot without depending on the WSL VM/9p share.
# The Startup shortcut points at DEST/init.ahk. Run after editing any .ahk, or
# let the git post-commit/post-merge hooks run it automatically.
set -euo pipefail
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="/mnt/c/Users/thezi/Apps/autohotkey"
mkdir -p "$DEST"
cp -f "$SRC"/*.ahk "$DEST"/
echo "Deployed $(ls "$SRC"/*.ahk | wc -l) .ahk files -> $DEST"
