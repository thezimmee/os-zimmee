# OS Zimmee

OS Zimmee is my reusable setup for my MacOS machine. It is everything I need to get up and running fast on a new machine, and keeps my machine fresh and up to date.

<!-- MarkdownTOC -->

1. [Install](#install)
	1. [Post install steps](#post-install-steps)
	1. [Individual app installation](#individual-app-installation)
1. [Updating / keeping things fresh](#updating--keeping-things-fresh)
1. [Working with App Store apps from the command line](#working-with-app-store-apps-from-the-command-line)
1. [Apps you may wish to install manually](#apps-you-may-wish-to-install-manually)
1. [Issues](#issues)

<!-- /MarkdownTOC -->

<a name="install"></a>
## Install

```bash
curl -s https://raw.githubusercontent.com/thezimmee/os-zimmee/master/install | bash
```

Then run the [post install steps](#post-install-steps). The above script does the following:

1. Sets up Homebrew.
2. Sets up git.
3. Clones the OS Zimmee repo to your desired local directory.
4. Installs Homebrew apps.
5. Optionally sets up each app.

<a name="post-install-steps"></a>
### Post install steps

There are some manual steps you may need to do after the install script is complete:

- Review all keyboard shortcuts in the `keyboard` preferences and update as follows:
	- Disable capslock modifier key in keyboard preferences.
	- Change spotlight shortcut to ctrl+alt+space.
	- Go through other keyboard shortcuts and modify as desired.
- Start Alfred, Hammerspoon, and Karabiner-Elements and make sure they start on login.
- Set up iTerm sync folder in iTerm's general preferences.
- Set up Alfred sync folder in Alfred's advanced preferences.

<a name="individual-app-installation"></a>
### Individual app installation

`bash <os-zimmee root>/<app folder>/setup`

<a name="updating--keeping-things-fresh"></a>
## Updating / keeping things fresh

```bash
update
```

This updates Homebrew, Homebrew apps, NPM packages, MacOS apps, and other apps/packages consumed by OS Zimmee. Easy enough?

<a name="working-with-app-store-apps-from-the-command-line"></a>
## Working with App Store apps from the command line

Use `mas` to install App Store apps.

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

<a name="apps-you-may-wish-to-install-manually"></a>
## Apps you may wish to install manually

- Photoshop
- Illustrator

<a name="issues"></a>
## Issues

If you run into any issues, please [open an issue](https://github.com/thezimmee/os-zimmee/issues).
