# git.zsh
# -------
# @description git environment.

# git aliases
alias gs='git status'

# Initialize git completions (installed with zsh).
# source /usr/local/share/zsh/site-functions/git-completion.zsh

# @todo: Explore using `hub` as our git wrapper (http://defunkt.github.com/hub/).
# hub_path=$(which hub)
# if (( $+commands[hub] ))
# then
#   alias git=$hub_path
# fi

# Run ssh-agent.
# eval "$(ssh-agent -s)" && ssh-add -K ~/.ssh/id_rsa
# plugins=(git ssh-agent)
