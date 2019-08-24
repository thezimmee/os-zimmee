# Command Chain

> Link commands together in a chain and run them sequentially.

## Usage

To create a new command (in a `*.sublime-commands` file) which selects all text and copies it to the clipboard:

```json
{
    "caption": "Select and Copy All",
    "command": "command_chain",
    "args": {
        "commands": [
            {"command": "select_all"},
            {"command": "copy"}
        ]
    }
}
```

To do the same with a keyboard shortcut:

```json
{
    "keys": ["super+ctrl+c"],
    "command": "command_chain",
    "args": {
        "commands": [
            {"command": "select_all"},
            {"command": "copy"}
        ]
    }
}
```
