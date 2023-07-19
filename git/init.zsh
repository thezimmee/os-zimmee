# git.zsh
# -------
# @description git environment.

# git aliases
alias gs='git status'

# Initialize git completions (installed with zsh).
source /usr/local/share/zsh/site-functions/git-completion.zsh

# Run ssh-agent.
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
ssh-add ~/.ssh/id_ed25519
