# Add homebrew to $PATH.
export PATH="${HOMEBREW_PREFIX}/opt/openssl/bin:$PATH"
# Opt out of homebrew analytics.
export HOMEBREW_NO_ANALYTICS=1

# Configure Volta and to $PATH.
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Add paths to cdpath for `cd` auto completion.
# setopt auto_cd
cdpath=($HOME/Projects $HOME/MQ)
# Add autocompletion to cd command.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories path-directories'


# Set default editor.
export EDITOR='subl -w'
export VISUAL='subl -w'

# eval "$(direnv hook zsh)"

# Load config files for aws-sso-set.
for conf in "$HOME/.config/zsh/config.d/"*.zsh; do
  source "${conf}"
done
unset conf