# Homebrew

## Setup Steps

1. Run the [documented install script](https://brew.sh/):
	```bash
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	```

2. Opt out of homebrew analytics:
	```bash
	export HOMEBREW_NO_ANALYTICS=1
	brew analytics off
	```

3. Update homebrew (and fix any issues listed by brew doctor):
	```bash
	brew update && brew upgrade && brew doctor
	```

4. Install each homebrew tap (from config):
	```bash
	brew tap <tap>
	```

5. Install each homebrew app (from config):
	```bash
	brew install <app>
	brew cask install <cask app>
	```