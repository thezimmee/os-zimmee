#!/usr/bin/env bash
#
# set up homebrew

title=Homebrew
first_run=false
brew_taps=(
    homebrew/bundle
    caskroom/cask
    caskroom/fonts
)
brew_apps=(
    bash
    imagemagick
    git
    mas
    node
    wget
    zsh
)
cask_apps=(
    appcleaner
    hammerspoon
    iterm2
    karabiner
    seil
    firefox
    caskroom/versions/firefoxdeveloperedition
    slack
    caskroom/versions/sublime-text3
    filezilla
    colorpicker
    google-chrome
    caskroom/versions/google-chrome-canary
    # osx quicklook plugins
    betterzipql
    qlcolorcode
    qlimagesize
    qlmarkdown
    qlprettypatch
    qlstephen
    quicklook-csv
    quicklook-json
    webpquicklook
    # fonts
    font-inconsolata
    font-inconsolata-for-powerline
    font-open-sans
    font-bebas-neue
)

function install_homebrew () {
    log "Installing Homebrew..." info
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    for tap in "${brew_taps[@]}"; do
        log "Installing Homebrew tap: ${tap}..."
        brew tap "${tap}"
    done

    # setup homebrew packages with bundle
    log "Install complete!" success
}

function install_apps () {
    local count_installed=0 count_skipped=0
    # install brew apps
    for app in "${brew_apps[@]}"; do
        if test $(brew ls --versions "${app}"); then
            log "Installing Homebrew app: ${app}..."
            brew install "${app}"
            (($count_installed++))
        else
            log "${app} already installed." success
            ((count_skipped++))
        fi
    done
    # install cask apps
    for app in "${cask_apps[@]}"; do
        if test $(brew cask ls --versions "${app}"); then
            log "Installing Homebrew (cask) app: ${app}..."
            brew cask install "${app}"
            (($count_installed++))
        else
            log "${app} already installed." success
            ((count_skipped++))
        fi
    done

    log "${BLUE}${count_installed}${END_COLOR} Homebrew apps installed; ${BLUE}${count_skipped}${END_COLOR} were already installed." success
}

function clone_repo () {
    log "Where would you like to clone your OSZ files (relative to your HOME directory)?"
    read -r response < /dev/tty
    git clone https://github.com/thezimmee/os-zimmee.git "~/${response}"
    log "Clone complete."
}

function update_homebrew () {
    log "Updating Homebrew apps..."
    brew update && brew upgrade && brew doctor
    log "Update complete."
}

# if log is not defined, ask to clone the git repo
if ! type log; then
    function log () {
        echo "[ .. ] ${1}"
    }
    log "Would you like to clone the OSZ git repo? [y|n] "
    read -n 1 -r response < /dev/tty

    if [[ $response != y ]]; then
        log 'You will need to clone the OSZ repo to move forward. If you have cloned it, something is wrong.'
        exit
    fi
    local do_clone_repo=true
fi

# install if not already installed
if test ! $(which brew); then
    install_homebrew
    install_apps
    [[ $do_clone_repo = true ]] && clone_repo
fi

# update apps
update_homebrew
if [[ $do_clone_repo = true ]]; then
    log "An attempt will be made to automatically set up the remaining apps; however, if something goes wrong, run the install.sh script located in the OSZ root directory."
    . "~/${response}/install.sh"
fi
log "Homebrew complete." success

# function setup_homebrew () {
#     local first_run=${CONFIG__first_run}
#     if [[ "$(uname -s)" == "Darwin" ]]; then

#         # update homebrew packages
#         cd "$CONFIG__brewfile_dir"
#         brew cleanup
#         brew cask cleanup
#         log 'Updating Homebrew apps...'
#         brew bundle
#         cd "$OSZ_ROOT"

#         if [[ $first_run = true ]]; then
#             log "Fixing permissions for ${MAGENTA}/usr/local/share/zsh${END_COLOR} (see ${MAGENTA}${DIM}http://stackoverflow.com/questions/13762280/zsh-compinit-insecure-directories${END_COLOR})..."
#             sudo chmod -R 755 '/usr/local/share/zsh'
#             sudo chown -R root:staff '/usr/local/share/zsh'
#             chsh -s $(which zsh)
#         fi
#     	log "Completed setup." success
#     else
#         log "Setup skipped...${END_COLOR} macOS not detected." warning
#     fi
# }

# can_continue 'Update all Homebrew apps?' && setup_homebrew