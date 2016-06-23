# OS Zimmee

This is my attempt at automating all of macOS and app configuration.

## Inspiration

This project is heavily inspired by:

- [GitHub guide to dotfiles](http://dotfiles.github.io/)
- [holman dotfiles](https://github.com/holman/dotfiles)
- [mathiasbynens dotfiles](https://github.com/mathiasbynens/dotfiles)

## More Resources

- [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)

## Installation

1. If you already have git, clone:
	```sh
	git clone https://github.com/thezimmee/os-zimmee.git ~/YOUR_DIRECTORY
	cd ~/YOUR_DIRECTORY
	```

<!-- 2. Otherwise, install using curl:
	```sh
	sh -c "`curl -fsSL https://raw.github.com/thezimmee/os-zimmee/master/homebrew/install-remote`"
	```

	This will automatically install git with Homebrew and clone the repo. -->

3. Customize the settings found in `$OSZ_ROOT/config`.

4. Run `$OSZ_ROOT/install`.

## Usage

### Organization

The project is structured by topic, which makes it simple to add/remove apps or sets of config files. It should also easy to clone other helpful repos and consume them.

<!-- ### Special file types

Files with the following conventions have special meaning:

- `bin/`: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- `Brewfile`: List of applications which will be installed by [Homebrew Cask](http://caskroom.io).
- `\*\*/\*.zsh`: Any file ending in `.zsh` will be loaded into your
  zsh environment.
- `**/path.zsh`: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or something similar.
- `**/completion.zsh`: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- `**/\*.link`: Any file or folder ending in `*.link` will get symlinked into your `$HOME` directory. This keeps them versioned but also sets them to your home directory.
- `***.ignore`: Files or folders ending in `*.ignore` are ignored by zsh. -->

## Issues

This project is very young. If you run into any issues, please [open an issue](https://github.com/thezimmee/os-zimmee/issues) and I'll see what I can do.

<!--
## TODO
- Opt out of brew anonymous stats (https://git.io/brew-analytics)
- Update my macOS preferences
	- [Toggle function keys to on](https://github.com/nelsonjchen/fntoggle)
	- macOS keyboard shortcuts
	- Change default xcode files to sublime
- Functions to add:
	- check if program exists (http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script)
- Install node & packages
	- npm
	- gulp
	- npm diff-so-fancy
	- http-server
	- nodemon?
	- release-it?
	- spot?
	- svgo?
	- tldr?
	- underscore-cli?
	- vtop?
	- shelljs & shx
- Add fuzzy-history to zsh
- Add ability to run install with no questions?
- kwm / hammerspoon:
	- Add ability to save layouts
	- Add notification for mode of current window (which is displayed when mode is toggled)
- update git repos
- Convert OSZ to javascript for use with shelljs?
- apps to install:
	- photoshop
	- illustrator
	- xcode
	- postman
- other apps to consider:
	- amethyst
	- moom
	- audacity
	- filezilla
	- hooner
	- musescore 2
	- noejectdelay utility
	- palua
	- prepros
	- shortcat
	- skitch
	- snippy
	- browserstack
	- snippy
	- vivaldi
	- blisk
	- watchguard mobile vpn
	- airdroid
 -->