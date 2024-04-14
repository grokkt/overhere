# overhere.nvim

A basic plugin that points you to where your cursor is when switching windows/buffers

- image

### Installation
```lua
require('grokkt/overhere').overhere({})
```

### Example / default options
```lua
require('grokkt/overhere').overhere({
   hl_opts = {
        fg = nil, -- or hex color string ex "#FF0000"
        bg = "#004a3c",
        bold = false,
        italic = false,
        underline = false
   },
   win_enter = true,
   buf_enter = true,
   buf_win_enter = true,
   clear_after_ms = 250
})
```

