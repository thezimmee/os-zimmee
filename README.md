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

1. You should really fork this to make it your own.

2. Then install with the following command:
	```sh
	export OSZ_ROOT=PATH/TO/OSZ/ROOT && export OSZ_REPO=YOUR_FORKED_REPO_URL && sh -c "`curl -fsSL https://raw.githubusercontent.com/thezimmee/os-zimmee/master/install-remote`"
	```
	This command does the following:
	
		- Sets `$OSZ_ROOT` to the directory you wish to install OSZ to.
		- Sets `$OSZ_REPO` to the URL of your forked repo.
		- Runs the `install-remote` script.
	
	If you do not set `$OSZ_ROOT` or `$OSZ_REPO`, the `install-remote` script will install Homebrew and git without cloning your repo, which you can do manually at a later time.

3. Once you have cloned your OSZ repo, customize the settings found in `$OSZ_ROOT/config` to your liking. _NOTE: You will also want to review all `bootstrap`, `install`, `setup`, and `uninstall` scripts in the repo to know exactly what they are doing, and to customize them to your liking._

4. Finally, run the `$OSZ_ROOT/bootstrap` sciprt with `./PATH_TO_YOUR_OSZROOT/bootstrap` and follow the prompts to install OSZ.

## Usage

### Organization

The project is structured by topic, which makes it simple to add/remove apps or sets of config files. It should also easy to clone other helpful repos and consume them.

## Post Installation Steps

There are some steps that either couldn't or haven't yet been automated. After installing OSZ, make sure to take these post-installation steps for each app.

### The "hyper" key (capslock)

Make sure to do the following to ensure the "hyper" key works:

- [Disable `capslock` in macOS preferences](https://pqrs.org/osx/karabiner/seil.html.en#usage)
- [Make sure `capslock` is set to `80` (which is the `f19` key)](https://pqrs.org/osx/karabiner/seil.html.en#commandlineinterface)

### Installing Sublime Packages

To install all Sublime packages, initiate the `Package Control: Advanced Install Package` command and paste this list of packages to install them all at once:

```
AutoFileName, BetterFindBuffer, BracketHighlighter, DistractionFreeWindow, DocBlockr, GitGutter, GitSavvy, Jade, LESS, MarkdownEditing, Markdown Preview, MarkdownTOC, Material Theme, MaxPane, MoveTab, Package Control, PackageResourceViewer, Sass, SideBarEnhancements, Solarized Color Scheme, Sublimerge Pro, Sync View Scroll, Terminal
```

### iTerm preferences

All preferences are stored in `$OSZ_ROOT/iTerm`, but need to be manually loaded in iTerm preferences.

### Amethyst spaces support

To enable spaces support in Amethyst, activate Mission Control's keyboard shortcuts for switching to specific Desktops, which is in the keyboard shortcuts tab of the keyboard preferences pane.

### Other apps to consider installing:

- [palua](http://osx.iusethis.com/app/palua)
- Photoshop
- Illustrator
- Snippy
- Blisk
- Parallels

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
