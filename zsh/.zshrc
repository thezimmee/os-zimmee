# .zshrc (with oh-my-zsh)
# -----------------------

# [[[ Config from oh-my-zsh

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
# export PATH="/usr/local/opt/ruby/bin:$PATH" # from old .zshrc

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
ZSH_THEME_RANDOM_CANDIDATES=(
  # KEEPERS:
  "intheloop"
  "juanghurtado"
  "steeef"

  # Jury is still out:
  "amuse"
  "aussiegeek"
  "avit"
  "bira"
  "blinks"
  "bureau"
  "candy"
  "crcandy"
  "darkblood"
  "dogenpunk"
  "dst"
  "dstufft"
  "duellj"
  "fino-time"
  "fino"
  "fox"
  "frisk"
  "frontcube"
  "funky"
  "gnzh"
  "itchy"
  "jispwoso"
  "jonathan"
  "josh"
  "jtriley"
  "junkfood"
  "kardan"
  "kphoen"
  "linuxonly"
  "mortalscumbag"
  "murilasso"
  "peepcode"
  "pmcqee"
  "re5et"
  "refined"
  "rgm"
  "rixius"
  "rkj-repos"
  "simonoff"
  "smt"
  "Soliah"
  "sporty_256"
  "strug"
  "suvash"
  "takashiyoshida"
  "tjkirch"
  "xiong-chiamiov"
  "xiong-chiamiov-plus"
  "ys"
)
# ZSH_THEME_RANDOM_IGNORED=(
#   "nanotech"
#   "apple"
# )

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=~/Projects/os-zimmee/zsh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source "$ZSH/oh-my-zsh.sh"

# ]]]

# [[[ User configuration

# Default ZSH environment.
export OSZ_ROOT="$HOME/Projects/os-zimmee"
source "$OSZ_ROOT/zsh/globals.zsh"
source "$OSZ_ROOT/zsh/aliases.zsh"

# Initialize env for os zimmee apps.
source "$OSZ_ROOT/araxis-merge/init.zsh"
source "$OSZ_ROOT/git/init.zsh"
source "$OSZ_ROOT/iterm/init.zsh"
source "$OSZ_ROOT/node/init.zsh"

# Source zsh files from other apps.
# for file in $(find -H "$OSZ_ROOT" -maxdepth 2 -name '*.zsh' -not -path '*/zsh/*')
# do
#   echo "FILE: $file"
#   # source $file
# done

# Enable completions.
autoload -Uz compinit && compinit

# Hook into direnv.
eval "$(direnv hook zsh)"

# ]]]