
# text-to-colorscheme

text-to-colorscheme.nvim is a neovim plugin that allows the user to generate new colorschemes by simply providing a text prompt.

## Prerequisites

Neovim 0.8.0+

## Installation

Using `packer`

```lua
use { "svermeulen/text-to-colorscheme.nvim" }
```

## Basic Usage

Inside `init.vim`

```vim
set background=dark
colorscheme text-to-colorscheme
```

Inside `init.lua`

```lua
vim.o.background = "dark"
vim.cmd([[colorscheme text-to-colorscheme]])
```

# Configuration

