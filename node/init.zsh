# node.zsh
# -------
# @description zsh configuration for git.

# [[[ Node version manager

# Load NVM from homebrew.
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# Set $NVM_SYMLINK_CURRENT=true to enable symlink current version of node to
# ~/.nvm/current when running the `npm use <version>` command.
export NVM_SYMLINK_CURRENT=true

# ]]]

# alias nr='npm run'
# alias tags='npm dist-tag ls'
# alias utag='npm dist-tag add'

function nmfind {
  find . -name 'node_modules' -type d -prune
}
function nmkill {
  find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
}