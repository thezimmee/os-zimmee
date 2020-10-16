##
# zshrc.link.zsh
# --------------
# @description My .zshrc configuration.
# You may need to force rebuild `zcompdump`:
# rm -f ~/.zcompdump; compinit
# If you receive "zsh compinit: insecure directories" warnings when attempting to load these completions, you may need to run this:
# chmod go-w '/usr/local/share'
##

# OSZ root path.
export OSZ_ROOT=$HOME/Projects/os-zimmee

# Add paths to CDPATH to search projects for `cd` completion.
export CDPATH=.:~:~/Projects:~/Projects/marqeta/wam/apps:~/Projects/marqeta/wam/packages:~/Projects/marqeta

# Prevents `command not found: compdef` error on iTerm startup.
autoload -Uz compinit
compinit

# Source autojump.
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Global variables.
if [[ -s "${OSZ_ROOT}/zsh/globals.ignore.zsh" ]]; then
	source "${OSZ_ROOT}/zsh/globals.ignore.zsh"
fi

# Source Prezto.
if [[ -s "${OSZ_ROOT}/zsh/zprezto.link/init.zsh" ]]; then
	source "${OSZ_ROOT}/zsh/zprezto.link/init.zsh"
fi
# unalias cp # Unalias cp

# Local variables (does not go in source control).
if [[ -s "${HOME}/.locals.zsh" ]]; then
	source "${HOME}/.locals.zsh"
fi

## SOURCE ALL OTHER ZSH FILES.
# Load all *.zsh files except *.link.zsh, *completion.zsh, and *ignore.zsh files.
for file in $(find -H "$OSZ_ROOT" -maxdepth 2 -name '*.zsh' -not -path '*.link.zsh' -not -path '*completion.zsh' -not -path '*ignore.zsh')
do
	source $file
done
# Initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit
# Load *completion.zsh files after autocomplete loads.
for file in $(find -H "$OSZ_ROOT" -maxdepth 2 -name '*completion.zsh')
do
	source $file
done
