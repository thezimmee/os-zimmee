# Git

This script does the following:

1. Sets up your git configuration files.
2. Optionally creates an SSH key.

## Install

1. Run the install script:

	```bash
	bash $OSZ_ROOT/git/install
	```

2. If needed, add your SSH key to GitHub:

	```bash
	pbcopy < ~/.ssh/id_ed25519.pub
	```

	Then paste into your [GitHub account](https://github.com/account/ssh).

3. Modify `~/.gitconfig-local` as needed.

## Uninstall

```bash
bash $OSZ_ROOT/git/uninstall
```
