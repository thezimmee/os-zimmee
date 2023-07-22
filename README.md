# OS Zimmee

OS Zimmee is my reusable setup for MacOS machines. It has everything I need to get up and running quickly on a new machine, and keeps my machine up to date.

## Install

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/thezimmee/os-zimmee/master/install)"
```

The above script installs git, clones, the repo, and installs everything else. If you've already cloned the repo,  you can run it locally:

```bash
bash ./<path to OSZ>/install
```

### Post install

**_Once the install script completes, review any `README` files in each app's directory for any manual steps to take._**

## Update

```bash
bash ./<path to OSZ>/update
```

## Uninstall

```bash
bash ./<path to OSZ>/uninstall
```