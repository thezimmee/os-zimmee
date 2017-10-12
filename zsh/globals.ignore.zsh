##
# globals.zsh
# -----------
# @description Only put global variables here. Any local variables (variables that shouldn't go in
# 	the repo) should go in locals.zsh.
##

# Default user. @todo: Is this needed?
DEFAULT_USER=zimmee

# Default editor.
export EDITOR='subl'
export VISUAL='subl'

## HOMEBREW
# Github token for homebrew.
export HOMEBREW_GITHUB_API_TOKEN=e660996ecb7cc6287c921dafe9d11e2a3afe2463
# Opt out of homebrew analytics.
export HOMEBREW_NO_ANALYTICS=1

## GO LANG
export GOPATH=$HOME/go-projects
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
