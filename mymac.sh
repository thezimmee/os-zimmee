# @TODO: Install default global node packages?
# @TODO: Install ZSH configurations I want to keep.
# @TODO: install any zsh/oh-my-zsh integrations I want into Warp.
# @TODO: Install macos system settings.
# @TODO: Write up postinstall.md instructions. Which include:
#	- Add sync code from brave browser to sync browser extensions, etc.

osz_root=${OSZ_ROOT:-$HOME/Projects/os-zimmee}


##
## ----------------------------------------------
## Install required apps/dependencies/frameworks.
##
Install required dependencies/frameworks.

##
## Install homebrew.
##
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

##
## Install git.
##
brew install git\

# Link local git config.
gitconfig_local=$HOME/.gitconfig-local
if [ -f $gitconfig_local ]; then
	mv -f $gitconfig_local "${gitconfig_local}-backup"
	echo "[i] Existing $gitconfig_local moved to ${gitconfig_local}-backup"
fi
cp -rf "$osz_root/git/.gitconfig-local-default" $gitconfig_local	
ln -sf "$osz_root/git/.gitignore $HOME/.gitignore"
ln -sf "$osz_root/git/.gitconfig $HOME/.gitconfig"

# Set up SSH key.
if [[ -e $HOME/.ssh/id_ed25519 ]]; then
	mv -f "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ed25519-BACKUP"
fi
ssh-keygen -t ed25519 -C "thezimmee@gmail.com"

# Symlink ssh config.
if [[ -e $HOME/.ssh/id_ed25519 ]]; then
	mv -f "$HOME/.ssh/config" "$HOME/.ssh/config-BACKUP"
fi
ln -s "$osz_root/git/ssh-config" "$HOME/.ssh/config"

\# Start up SSH agent.
eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/id_ed25519"

# Copy SSH to clipboard.
pbcopy < "$HOME/.ssh/id_ed25519.pub"
read -n 1 -s -r -p "[!!] Your SSH key has been copied to the clipboard; paste it into your GitHub account (https://github.com/account/ssh). Then hit any key to continue... "

##
## Install node version manager and node.
##
curl https://get.volta.sh | bash
volta install node@16 # for MQ
volta install node

##
## Install terminal.
##
brew install --cask warp


##
## ---------------------
## Install primary apps.
##

##
## Install Raycast.
##
brew install --cask raycast

##
## Install browsers.
##
brew install --cask brave-browser

##
## Install IDEs.
##
brew install --cask sublime-text

# Create subl CLI executable.
mkdir $HOME/bin
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" $HOME/bin/subl

# Set sublime as default IDE.
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.4;}'

# Install package control.
if [ ! -f "$packages_path/Installed Packages/Package Control.sublime-package" ]; then
	curl https://packagecontrol.io/Package%20Control.sublime-package -o "$HOME/Library/Application Support/Sublime Text/Installed Packages/Package Control.sublime-package"
fi

# Symlink sublime user preferences to OS Zimmee.
rm -rf "$HOME/Library/Application Support/Sublime Text/Packages"
ln -sf "${OSZ_ROOT:-$HOME/Projects/os-zimmee}/sublime/v4/Packages" "$HOME/Library/Application Support/Sublime Text/Packages"

# [TEMPORARY] Install fork of BetterFindBuffer.
# @NOTE: Once BetterFindBuffer releases
# [this](https://github.com/aziz/BetterFindBuffer/pull/37) or
# [this](https://github.com/aziz/BetterFindBuffer/pull/35)
# we can install it from PackageControl.
cd "$osz_root/sublime/Packages"
git clone git@github.com:mreq/BetterFindBuffer.git
cd BetterFindBuffer
git fetch
git switch patch-1
cd "$osz_root"

##
## Install fonts.
##
brew tap homebrew/cask-fonts
brew install --cask font-bebas-neue font-consolas-for-powerline font-dejavu-sans-mono-for-powerline font-droid-sans-mono-for-powerline font-fira-mono-for-powerline font-hasklig font-inconsolata font-inconsolata-for-powerline font-menlo-for-powerline font-meslo-for-powerline font-open-sans font-roboto-mono-for-powerline font-source-code-pro-for-powerline font-ubuntu-mono-derivative-powerline

##
## Install keyboard productivity tools.
##
brew install --cask karabiner-elements

# Link karabiner config to user.
mkdir -p $HOME/.config
ln -sf "${OSZ_ROOT:-$HOME/Projects/os-zimmee}/karabiner-elements/karabiner.link" "$HOME/.config/karabiner"

##
## Install MacOS optimizations.
##
brew install --cask betterzip qlcolorcode qlimagesize qlmarkdown qlprettypatch qlstephen quicklook-csv quicklook-json qlvideo syntax-highlight the-unarchiver webpquicklook

# Remove MacOS quarantine attributes from quicklook plugins (see https://github.com/sindresorhus/quick-look-plugins).
xattr -r ~/Library/QuickLook
xattr -d -r com.apple.quarantine ~/Library/QuickLook

##
## Install automations.
##
brew install direnv


##
## -------------------
## Install other apps.
##

brew install --cask \
	4k-video-downloader \
	affinity-designer \
	affinity-photo \
	affinity-publisher \
	aldente
	audacity \
	bitwarden \
	cleanshot \
	commander-one \
	forklift \
	foxitreader \
	handbrake \
	iina \
	imageoptim \
	kaleidoscope \
	microsoft-office \
	mountain-duck \
	notion \
	obsidian \
	pdf-expert \
	postbox \
	postman \
	sublime-merge


##
## -----------------------
## Other apps to consider.
##

# TERMINAL / CLI:
# Fig: https://fig.io
#
# WINDOW MANAGER:
# https://magnet.crowdcafe.com
# Moom
#
# MACOS UTILITIES:
# TinkerTool: http://www.bresink.com/osx/0TinkerTool/screenshots.html
# Bartender: https://www.macbartender.com
# OmniDiskSweeper: https://www.omnigroup.com/more
# Unarchiver: https://theunarchiver.com
# Transmit: https://panic.com/transmit/
# Displays: https://www.jibapps.com/apps/displays/
# Display Buddy: https://displaybuddy.app
# Forklift: https://binarynights.com
#
# CALENDAR + PRODUCTIVITY
# Fantastical: https://flexibits.com
# Cron: https://cron.com
# TimeOut: https://apps.apple.com/us/app/time-out-break-reminders/id402592703?mt=12
#
# MULTIMEDIA TOOLS:
# Hazel: https://www.noodlesoft.com
# Audio Hijack: https://rogueamoeba.com/audiohijack/
# TextSniper: https://apps.apple.com/us/app/textsniper-ocr-simplified/id1528890965?mt=12&uo=4

##
## ----------------------------------
## Install dotfiles and config files.
##
for dotfile in $osz_root/{dotfiles,zsh}/.[^.]*; do
    if [ -f $dotfile ]; then
		dest="$HOME/$(basename $dotfile)"
		# Back up file if it already exists.
		if [ -f $dest ]; then
			mv $dest $dest-BACKUP
		fi
		# Symlink dotfile.
        ln -s $dotfile $dest
        echo "[ok] Set up ${dest}..."
    fi
done
