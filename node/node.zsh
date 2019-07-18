##
# node.zsh
# -------
# @description zsh configuration for git.
##

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

alias nr='npm run'
alias tags='npm dist-tag ls'
alias utag='npm dist-tag add'

function npmproject {
  git init
  npx license mit -o "$(npm get init.author.name)" > LICENSE.md
  npx gitignore node
  npx covgen "$(npm get init.author.email)" CONTRIBUTING.md
  npm init -y

  printf '%s ' 'Install git hooks? (Y/n)'
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    npm i @brikcss/git-hooks -D
  else
    echo "Skipped git hooks."
  fi
}