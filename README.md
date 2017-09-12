# OS Zimmee

OS Zimmee stores all my custom configurations and settings to get running on my mac machine. It started as a collection of all my dotfiles, and quickly expanded to included settings for all apps I use regularly.

<!-- MarkdownTOC -->

1. [Installing and updating](#installing-and-updating)
	1. [App installation](#app-installation)
	1. [Full / fresh installation](#full--fresh-installation)
1. [Updating / keeping things fresh](#updating--keeping-things-fresh)
	1. [The update everything command](#the-update-everything-command)
	1. [Adding new apps](#adding-new-apps)
1. [Issues](#issues)

<!-- /MarkdownTOC -->

<a name="installing-and-updating"></a>
## Installing and updating

<a name="app-installation"></a>
### App installation

`bash {{app folder}}/setup`

That's it!

<a name="full--fresh-installation"></a>
### Full / fresh installation

1. Install homebrew &amp; homebrew packages by running `bash homebrew/setup`.

2. Clone `os-zimmee` repo:

	```bash
	# The recursive flag pulls in submodules
	git clone --recursive https://github.com/thezimmee/os-zimmee.git
	```

3. Each directory in `os-zimmee` represents an app. Set up each app by running the setup script for that app:

	```bash
	{{os-zimmee path}}/{{app folder}}/setup
	```

4. Finish manual setup for each of the following apps:

	- macOS: Run `macos/setup` to set up macOS preferences and [disable `capslock` on all keyboards](https://www.maketecheasier.com/disable-caps-lock-mac/)_.
	- iTerm:
		+ Import Solarized theme from `/iterm`.
		+ Set up the following keyboard shortcuts in iTerm:
			* [Deletions](https://coderwall.com/p/ds2dha/word-line-deletion-and-navigation-shortcuts-in-iterm2)
			* [Selections](http://apple.stackexchange.com/questions/154292/iterm-going-one-word-backwards-and-forwards)
	- Sublime Text:
		+ Open `${OS_ZIMMEE}/sublime/Packages/User/Package Control.sublime-settings`.
		+ Copy to your clipboard a comma-delimited list of all packages in the `installed_packages` property.
		+ In Sublime Text, run the `Package Control: Advanced Install Package` command and paste the list of packages to install them all at once.
	- Hammerspoon: Start it and make sure it launches at startup.
	- Karabiner-elements: Start it and make sure it launches at startup.

<a name="updating--keeping-things-fresh"></a>
## Updating / keeping things fresh

<a name="the-update-everything-command"></a>
### The update everything command

```bash
update
```

This command is simply an alias that runs the update script located at: `bash {{os-zimmee path}}/update`. The update script will ask you if you want to do each of the following:

- Update homebrew.
- Update npm packages.
- Try to update apps from the app store.
- Update apps, such as prezto, that were installed by cloning a repo.

Easy enough?

<a name="adding-new-apps"></a>
### Adding new apps

Use `mas` to install other App Store apps.

```bash
# lists installed apps and their app ID
mas list
# find app and app ID
mas search <app>
# install app
mas install <app-id>
# list outdated apps
mas outdated
# upgrade all apps
mas upgrade
# sign in to App Store
mas signin <email>
```

#### Other apps you may want to install:

- Photoshop
- Illustrator

<a name="issues"></a>
## Issues

If you run into any issues, please [open an issue](https://github.com/thezimmee/os-zimmee/issues).
