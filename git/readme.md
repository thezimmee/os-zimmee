# Git

## Setup

1. Create an SSH key:
	```bash
	ssh-keygen -t rsa -b 4096 -C "${GIT_EMAIL}"
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_rsa
	```

2. Add SSH key to github:
	```bash
	pbcopy < ~/.ssh/id_rsa.pub
	```

	Then paste into [GitHub account](https://github.com/account/ssh).

3. Set up git configuration by modifying `gitconfig.local`.

4. Symlink configuration files:
	```bash
	ln -s ${OSZ_ROOT}/git/gitignore.link ~/.gitignore-global
	ln -s ${OSZ_ROOT}/git/gitconfig.link ~/.gitconfig
	```