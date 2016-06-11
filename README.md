# OS Zimmee

This is my attempt to create a simple way to:

1. Manage dotfiles
2. Manage OS configuration & preferences
3. Easily install all configuration to a new user

## Inspiration

This project is heavily inspired by:

- [GitHub guide to dotfiles](http://dotfiles.github.io/)
- [holman dotfiles](https://github.com/holman/dotfiles)
- [mathiasbynens dotfiles](https://github.com/mathiasbynens/dotfiles)

## More Resources

- [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)

## Installation

1. Clone
```sh
git clone https://github.com/thezimmee/os-zimmee.git ~/YOUR_DIRECTORY
cd ~/YOUR_DIRECTORY
```
2. Customize as desired
3. Run `bootstrap` script
4. Run `update-system` script regularly

## Usage

### Organization

The project is structured by topic, which makes it simple to add/remove apps or sets of config files. It also makes it easy to clone other helpful repos and consume them.

### Scripts

#### **`script/bootstrap`:**

Sets up OS Zimmee on a fresh system or user. Specifically:

1. Sets defaults for OSX with `osx/set-defaults.sh`
2. Installs homebrew with `homebrew/install.sh`
3. Installs all other apps and configurations with `PATH/install.sh`

#### **`script/update-system`:

Updates 

### Special file types

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
- `**/\*.link`: Files ending in `*.link` get symlinked into your `$HOME` directory. This allows you to keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run `script/bootstrap`.
- `***.ignore`: Files or folders ending in `*.ignore` are ignored by zsh.

## Issues

If you run into any issues, please [open an issue](https://github.com/thezimmee/os-zimmee/issues) and I'll see what I can do.
