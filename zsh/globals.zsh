##
# globals.zsh
# -----------
# @description Only put global variables here. Any local variables (variables that shouldn't go in
# 	the repo) should go in locals.zsh.
##

# [[[ OS Zimmee

# Add paths to CDPATH for `cd` auto completion.
export CDPATH=.:~:~/Projects:~/Projects/marqeta/wam/apps:~/Projects/marqeta/wam/packages:~/Projects/marqeta

# Prevent `command not found: compdef` error on iTerm startup.
# autoload -Uz compinit
# compinit

# Source autojump.
# [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# ]]]

# [[[ Default editor.
export EDITOR='subl'
export VISUAL='subl'
# ]]]

# [[[ Homebrew

# Opt out of homebrew analytics.
export HOMEBREW_NO_ANALYTICS=1

# ]]]

# [[[ Language specific

# @TODO: Move this to project directories and add plugin to source files when
# opening the directory.

## GO LANG
export GOPATH=$HOME/go-projects
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin

## JAVA
export JAVA_HOME=$(/usr/libexec/java_home)

# ]]]
