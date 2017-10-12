##
# zpreztorc.link.zsh
# ------------------
# @description My .zpreztorc configuration.
##


# Set the Prezto modules to load (browse modules).
# The order matters.
zstyle ':prezto:load' pmodule \
	'environment' \
	'terminal' \
	'editor' \
	'history' \
	'directory' \
	'spectrum' \
	'utility' \
	'autosuggestions' \
	'fasd' \
	'git' \
	'homebrew' \
	'node' \
	'osx' \
	'rsync' \
	'ssh' \
	'completion' \
	'syntax-highlighting' \
	'history-substring-search' \
	'prompt'

# Allow the zsh prompt context to be shown.
zstyle ':prezto:module:editor' ps-context 'yes'

# Set the prompt theme to load.
# Setting it to 'random' loads a random theme.
# Auto set to 'off' on dumb terminals.
# zstyle ':prezto:module:prompt' theme 'steeef'
# zstyle ':prezto:module:prompt' theme 'paradox'
# zstyle ':prezto:module:prompt' theme 'powerline'
# zstyle ':prezto:module:prompt' theme 'nicoulaj'
zstyle ':prezto:module:prompt' theme 'agnoster'

# Set the prompt to display the return code along with an indicator for non-zero
# return codes. This is not supported by all prompts.
zstyle ':prezto:module:prompt' show-return-val 'yes'

# Set the SSH identities to load into the agent.
zstyle ':prezto:module:ssh:load' identities 'id_rsa' 'id_rsa2' 'id_github'

# Set syntax highlighters.
# By default, only the main highlighter is enabled.
zstyle ':prezto:module:syntax-highlighting' highlighters \
	'main' \
	'brackets' \
	'pattern' \
	'line' \
	'cursor' \
	'root'

# Auto set the tab and window titles.
zstyle ':prezto:module:terminal' auto-title 'yes'

# Set the window title format.
zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'

# Set the tab title format.
zstyle ':prezto:module:terminal:tab-title' format '%m: %s'

# Integrate with iTerm2.
zstyle ':prezto:module:tmux:iterm' integrate 'yes'

# Enabled safe options. This aliases cp, ln, mv and rm so that they prompt
# before deleting or overwriting files. Set to 'no' to disable this safer
# behavior.
zstyle ':prezto:module:utility' safe-ops 'yes'
