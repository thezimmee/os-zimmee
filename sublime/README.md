# Sublime Text

## Install

1. Run the install script:

    ```bash
    bash $OSZ_ROOT/sublime/install
    ```

2. Install package control from Sublime's command palette.

3. Sublime should automatically install packages after installing package control. If the packages do not automatically install, do the following:

    1. After package control is installed, open [Package Control.sublime-settings](~/Projects/os-zimmee/sublime/Packages/User/Package\ Control.sublime-settings).
    2. Create a comma-delimited list from the `installed_packages` property.
    3. Type `advanced install` in the command prompt and paste the comma-delimited list of packages.

## Uninstall

```bash
bash $OSZ_ROOT/sublime/uninstall
```
