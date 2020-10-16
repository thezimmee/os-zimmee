##
# aliases.zsh
# -----------
# @description All aliases should go here.
##

# Command to run OSZ update script.
update () {
	bash "${OSZ_ROOT}/update"
}

# Project folder alias so we can `c [tab]` to it.
setopt AUTO_CD # auto cd by typing the path.
projects="${HOME}/Projects"
alias p=cd ${HOME}/Projects

# reload zsh
alias reload='. $HOME/.zshrc'

### Hygen ###
alias gen="hygen"

### MARQETA ###
alias amc="cd ~/Projects/marqeta/wam && echo '[i] Using mock data...' && USE_MOCKS=true npm run amcql"
alias amcprod="cd ~/Projects/marqeta/wam && echo '[!!] Using live data' && npm run amcql"

# Command to compare two directories with sublimerge.
# compare () {
# 	subl --command 'sublimerge_compare_paths {"paths": ["$1", "$2"]}'
# }
# alias compare=compare

# Change default browser.
alias chrome='open -a "/Applications/Google Chrome.app" --args --make-default-browser'
alias canary='open -a "/Applications/Google Chrome Canary.app" --args --make-default-browser'
alias firefox='open -a "Firefox" --args --setDefaultBrowser'
alias firefoxdev='open -a "FirefoxDeveloperEdition" --args --setDefaultBrowser'
alias safari='open -a "Safari" --args --make-default-browser'
