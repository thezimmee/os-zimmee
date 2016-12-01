# OS Zimmee

Easy installation of a new MacOS machine.

## Inspiration

This project is inspired by:

- [GitHub guide to dotfiles](http://dotfiles.github.io/)
- [holman dotfiles](https://github.com/holman/dotfiles)
- [mathiasbynens dotfiles](https://github.com/mathiasbynens/dotfiles)

## More Resources

- [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)

## Installation

1. Install homebrew &amp; homebrew packages by running `bash homebrew/setup`.

2. Clone `os-zimmee` repo:

	```bash
	# The recursive flag pulls in submodules
	git clone --recursive https://github.com/thezimmee/os-zimmee.git
	```

3. Set up ZSH & iTerm:

	- Run `bash zsh/setup` script.
	- Import Solarized theme from `/iterm`.
	- Set up keyboard shortcuts in iTerm:
		- [Deletions](https://coderwall.com/p/ds2dha/word-line-deletion-and-navigation-shortcuts-in-iterm2)
		- [Selections](http://apple.stackexchange.com/questions/154292/iterm-going-one-word-backwards-and-forwards)

4. Set up MacOS preferences by running `macos/setup` script. _Make sure to [disable `capslock` on all keyboards](https://www.maketecheasier.com/disable-caps-lock-mac/)_.

5. Set up other apps by running `bash [app]/setup`. Make sure to set up:

	- git
	- Sublime
		- To install all Sublime packages, initiate the `Package Control: Advanced Install Package` command and paste this list of packages to install them all at once:

			```
			AutoFileName, BetterFindBuffer, BracketHighlighter, DistractionFreeWindow, DocBlockr, GitGutter, GitSavvy, Jade, LESS, MarkdownEditing, MarkdownTOC, Material Theme, MaxPane, MoveTab, OmniMarkdownPreview, Package Control, PackageResourceViewer, Sass, SideBarEnhancements, Solarized Color Scheme, Sublimerge Pro, Sync View Scroll, Terminal
			```

		- Make sure to update desired settings for Boxy theme.

	- Hammerspoon
		- Start Hammerspoon and make sure it launches at startup.
	- Karabiner-Elements
		- Start Karabiner-Elements and make sure it launches at startup.

6. Install the following apps from the App Store:

	- XCode
	- Snippy

7. Consider other apps to install:

	- Affinity Designer
	- Photoshop
	- Illustrator

## Keeping things fresh

- Update home brew with `bash ~/Projects/os-zimmee/homebrew/update`.
- Update prezto with `git pull && git submodule update --init --recursive`.
- Update apps from the App Store with `sudo softwareupdate -i -a`.
- Update global node packages with `npm update -g npm`.


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
- add command to toggle between amethyst and kwm
- add feature to disable an app from CONFIG__disabled_apps
- find keyboard shortcut to move window to next/prev space
- configure kwm:
	- Add ability to save layouts
	- Add notification for mode of current window (which is displayed when mode is toggled)
- Sort through desired macOS preferences
	- [Toggle function keys to on](https://github.com/nelsonjchen/fntoggle)
	- add desired macOS keyboard shortcuts
	- Change default xcode files to sublime
- Add a "repo list" to be able to update all my repos
- Configure hammerspoon
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
- update git repos
- Convert OSZ to javascript for use with shelljs?
- apps to install:
	- photoshop
	- illustrator
	- xcode
	- postman
	- forklift?
- other apps to consider:
	- amphetamine (like caffeine)
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
