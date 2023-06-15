
require("text-to-colorscheme").load()

vim.api.nvim_command('command! -nargs=1 T2CGenerate lua require("text-to-colorscheme").generate_new_palette_and_apply(<f-args>)')
