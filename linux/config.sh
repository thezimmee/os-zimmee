#!/usr/bin/env bash
# Declarative configuration for the Linux track.
# Everything you would routinely tweak lives here; the modules hold the logic.

# Modules to run, in order. `base` must come first (it installs prerequisites
# every other module leans on). Run a subset with: bash linux/install keyd brave
export OSZ_MODULES=(
	base
	keyd
	brave
	firefox
	vscode
	warp
	krohnkite
	kde
	shortcuts
)

# Modules that touch system state and therefore need sudo. Anything not listed
# here runs entirely as the user (kpackagetool6 and kwriteconfig6 both write
# under $HOME), so it should never trigger a password prompt.
export OSZ_MODULES_NEEDING_SUDO=(
	base
	keyd
	brave
	firefox
	vscode
	warp
)

# --- base packages ----------------------------------------------------------
# Prerequisites for the modules plus the handful of CLI tools assumed present.
export APT_BASE_PACKAGES=(
	curl
	wget
	git
	gnupg
	ca-certificates
	apt-transport-https
	jq
	unzip
	build-essential
)

# --- third-party apt repositories -------------------------------------------
# Format: "name|key-url|suite-and-components"
# `name` determines /etc/apt/keyrings/<name>.gpg and sources.list.d/<name>.list
export APT_REPO_BRAVE="brave-browser|https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg|https://brave-browser-apt-release.s3.brave.com/ stable main"
export APT_REPO_VSCODE="vscode|https://packages.microsoft.com/keys/microsoft.asc|https://packages.microsoft.com/repos/code stable main"
export APT_REPO_WARP="warpdotdev|https://releases.warp.dev/linux/keys/warp.asc|https://releases.warp.dev/linux/deb stable main"

# --- browser extensions -----------------------------------------------------
# Deliberately NOT listed here. The Chromium enterprise-policy file is the single
# source of truth for which extensions get installed, and it is cross-OS content:
#   shared/brave/policies-managed.json
# Duplicating the IDs here would just invite the two lists to drift apart.

# --- krohnkite -------------------------------------------------------------
# The Plasma 6 maintained fork. esjeon/krohnkite upstream stalled at v0.8.1 and
# does not run on KWin 6.
export KROHNKITE_REPO="anametologin/krohnkite"
# Release assets include an unversioned krohnkite.kwinscript that always points
# at the newest build, so this needs no bumping.
export KROHNKITE_ASSET="krohnkite.kwinscript"
