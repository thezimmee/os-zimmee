# Cycle Setting Command

> Cycle through settings with multiple values.

## Usage

Create a key binding:

```
{
    "keys": ["super+shift+;"],
    "command": "cycle_setting",
    "args": {
    	"setting": "draw_white_space",
    	"values": ["all", "selection"]
    }
}
```

Credit: [Alexis from StackOverflow](https://stackoverflow.com/questions/29089819/how-to-set-key-bindings-in-sublime-that-change-values-of-settings#answer-47507750)
