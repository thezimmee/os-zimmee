# Moom

## Install

```bash
bash $OSZ_ROOT/moom/install
```

## Export

This saves/exports current Moom preferences.

```bash
bash $OSZ_ROOT/moom/export
```

## How to sync

See ["Can I sync Moom's settings across Macs?"](https://manytricks.com/osticket/kb/faq.php?id=53).

TLDR:

You can, manually. Do this:

1. Quit Moom on source Mac and target Mac.

2. On source Mac, save/back up Moom preferences:

    ```bash
    defaults export com.manytricks.Moom ~/Projects/os-zimmee/moom/Moom.plist
    ```

3. On target Mac, copy Moom preferences to app:

    ```bash
    defaults import com.manytricks.Moom ~/Projects/os-zimmee/moom/Moom.plist
    ```
