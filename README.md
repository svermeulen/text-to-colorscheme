
# text-to-colorscheme

A neovim plugin that allows the user to generate new colorschemes by simply providing a text prompt (using OpenAI's ChatGPT API)

## Prerequisites

Neovim 0.8.0+

## Installation

Using `packer`

```lua
use { "svermeulen/text-to-colorscheme.nvim" }
```

## Basic Usage

Inside `init.lua`

```lua
vim.o.background = "dark"

require('text-to-colorscheme').setup {
  openai_api_key = "<OPENAI_API_KEY>",
}

vim.cmd([[colorscheme text-to-colorscheme]])
```

## Generating Theme

When a custom theme is not provided, the plugin will fallback to using a theme resembling [gruvbox](https://github.com/ellisonleao/gruvbox.nvim).

To generate a custom one instead, execute the command:

```
:T2CGenerate <text prompt>
```

Where `<text prompt>` is any text describing the kind of color scheme you want (eg: `jungle`, `western saloon`, `ocean deep`, `autumn leaves`, or something more imaginative!).  After doing this, it will take 5-10 seconds for the new color scheme to be generated, at which point it will be automatically loaded.

Note that `text-to-colorscheme` [currently only supports dark themes](https://github.com/svermeulen/text-to-colorscheme/issues/1)

## Saving Theme Persistently

After finding a theme that you want to keep, you can have this persist across vim sessions by running the command:

```
:T2CSave
```

This should present a popup vim buffer with the color palette that was generated.  You can then copy the contents of this buffer into your call to `require('text-to-colorscheme').setup`.  For example, if using a text prompt of 'jungle' and then running `T2CSave`, the change to `init.lua` might look like this:

```
require('text-to-colorscheme').setup {
  openai_api_key = "<OPENAI_API_KEY>",
  hex_palettes = {
     {
        name = "jungle",
        background_mode = "dark",
        background = "#1c2a1f",
        foreground = "#c1d3b7",
        accents = {
           "#6dbd5a",
           "#a3d16d",
           "#d1c75a",
           "#d1a35a",
           "#d15a5a",
           "#5ad1b3",
           "#5a8ad1",
        }
     },
     default_palette = "jungle",
  }
}
```

Note that in addition to adding to the `hex_palettes` list, we also need to set a value for `default_palette` above.

## Tweaking Theme

Sometimes, some text prompts do not always translate well to a new color scheme on the first try.  One approach to fixing this is to modify the text prompt and try again.  In some cases though, the generated color scheme is good, and just needs some minor adjustments around contrast, saturation, or color order. For these cases, `text-to-colorscheme` comes with the following commands that help you do this:

* `:T2CAddContrast X` - Call this if you want the foreground colors to be more or less distinct from the background colors.  A positive value here will modify the current color scheme to have the foreground more distinct from the background, and a negative value will cause the foreground and background to become more similar.

* `:T2CAddSaturation X` - Call this if you want to increase or reduce how intense the foreground colors are.  A lower value here means the color becomes more gray / washed-out.

* `:T2CShuffleAccents` - Call this if you want to change which highlight groups the various colors are applied to.  It will randomize the order of the accent colors.  This is useful to try a few times to see if it improves the look and feel.  If you want more refined control over the order, you can run `:T2CSave`, then save your theme, then control the order manually.  This is helpful in particular if you prefer error highlights to be on the reddish side (which you can do by ensuring the most red color is ordered last)

For example - it may be helpful to add commands like the following, when generating new color schemes:

```
vim.api.nvim_set_keymap('n', '<f9>', ':T2CAddContrast -0.1<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<f10>', ':T2CAddContrast 0.1<cr>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<f11>', ':T2CAddSaturation -0.1<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<f12>', ':T2CAddSaturation 0.1<cr>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<f8>', ':T2CShuffleAccents<cr>', {noremap = true, silent = true})
```

It will be clear after toggling these keys what the effect of these commands are on the color scheme.  Note that once you are satisfied with the changes, you will want to save your theme using the `:T2CSave` command.

## Advanced Configuration

Additional settings (and default values) for `text-to-colorscheme` are:

```lua
-- setup must be called before loading the colorscheme
-- Default options:
require("text-to-colorscheme").setup({
  gpt_model = "gpt-4", -- eg. or "gpt-3.5-turbo"
  openai_api_key = nil,
  undercurl = true,
  underline = true,
  verbose_logs = false, -- When true, will output logs to echom, to help debugging
  bold = true,
  italic = {
     strings = true,
     comments = true,
     operators = false,
     folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  save_as_hsv = false, -- When true, T2CSave will save colors as HSV instead of hex
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true,
  dim_inactive = false,
  minimum_generated_foreground_contrast = 50, -- This is used to touch up the generated theme to avoid generating foregrounds that match the background too closely
  transparent_mode = false,
  hsv_palettes = {},
  hex_palettes = {},
  overrides = {},
  default_palette = "urban autumn", -- aka gruvbox. Override to use something from hsv_palettes or hex_palettes
})
```

Note that the implementation of `text-to-colorscheme` was originally forked from the great [gruvbox.nvim plugin](https://github.com/ellisonleao/gruvbox.nvim) which is why it has similar options

## Highlight Group Overrides

If you don't like the color for a specific highlight group, you can override it in the setup. For example:

```lua
require("text-to-colorscheme").setup({
    overrides = {
        SignColumn = {bg = "#ff9900"}
    }
})
```

Please note that the override values must follow the attributes from the highlight group map, such as:

- **fg** - foreground color
- **bg** - background color
- **bold** - true or false for bold font
- **italic** - true or false for italic font

Other values can be seen in `:h synIDattr`
