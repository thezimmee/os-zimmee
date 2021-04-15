##
# globals.zsh
# -----------
# @description Only put global variables here. Any local variables (variables that shouldn't go in
# 	the repo) should go in locals.zsh.
##

# [[[ OS Zimmee

# Add paths to CDPATH for `cd` auto completion.
export CDPATH=.:~:~/Projects:~/Projects/marqeta/wam/apps:~/Projects/marqeta/wam/packages:~/Projects/marqeta

# Source autojump.
# [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Uncomment the following line to change how often to autoupdate (in days) zsh plugins that are git repos.
# export UPDATE_ZSH_DAYS=13

# ]]]

# [[[ Default editor.
export EDITOR='subl -w'
export VISUAL='subl -w'
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
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0)

# ]]]
