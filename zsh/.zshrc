# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("/Users/tzimmerman/.zsh/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
# Add Homebrew OpenSSL to $PATH (takes precedence over system OpenSSL).
export PATH="/opt/homebrew/opt/openssl/bin:$PATH"
# Opt out of homebrew analytics.
export HOMEBREW_NO_ANALYTICS=1

# Add VSCode to $PATH.
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# Configure Volta and add to $PATH.
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Add mise to $PATH
eval "$(~/.local/bin/mise activate zsh)"

# Claude
alias claude-p="CLAUDE_CONFIG_DIR=~/.claude-personal /Users/tzimmerman/.local/bin/claude"
alias claude-demo="CLAUDE_CONFIG_DIR=~/.claude-demo /Users/tzimmerman/.local/bin/claude"
alias mq-mock="node ~/MQ/cxp/devkit/plugins/api-intel/mock-builder/src/cli.js"

# Configure my todo system.
alias todo="python /Volumes/projects/todone/todo"

# Configure jenv, set JAVA_HOME, and add to $PATH.
export JENV_ROOT="$HOME/.jenv"
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$JAVA_HOME/bin:$PATH
eval "$(jenv init -)"

# Set up mysql for MQ projects.
# export PATH="/opt/homebrew/Cellar/mysql@8.0/8.0.42/bin:$PATH"

# Add paths to cdpath for `cd` auto completion.
# setopt auto_cd
cdpath=($HOME/Projects $HOME/MQ)
# Add autocompletion to cd command.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories path-directories'


# Set default editor.
export EDITOR='code'
export VISUAL='code'

# eval "$(direnv hook zsh)"

# Load config files for aws-sso-set.
for conf in "$HOME/.config/zsh/config.d/"*.zsh; do
  source "${conf}"
done
unset conf
# bun completions
[ -s "/Users/tzimmerman/.bun/_bun" ] && source "/Users/tzimmerman/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Set up pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/tzimmerman/.docker/completions $fpath)
# End of Docker CLI completions
autoload -Uz compinit
compinit

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Use Powerlevel10k
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set shell characters to remove `/`.
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# Added by sonarqube-cli installer
export PATH="$HOME/.local/share/sonarqube-cli/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tzimmerman/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tzimmerman/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tzimmerman/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tzimmerman/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
