# cwd_switcher.nvim

## Required dependencies
- [nvim-lua/plnary.nvim](https://github.com/nvim-lua/plenary.nvim) is required.

## Setup
Mark the path by
```lua
:lua require("cwd_switcher").mark_this()
```

To Show marked path
```lua
:lua require("cwd_switcher").show()
```

To delete the path from marked path
```
Press 'd' on floating window
(Note: As of now only one line will be considered to delete multiple selection will not delete all)
```

