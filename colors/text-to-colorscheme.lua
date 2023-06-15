
require("text-to-colorscheme").load()

vim.api.nvim_command('command! -nargs=1 T2CGenerate lua require("text-to-colorscheme").generate_new_palette_and_apply(<f-args>)')

vim.api.nvim_command('command! -nargs=1 T2CSetContrast lua require("text-to-colorscheme").set_contrast(<f-args>)')
vim.api.nvim_command('command! -nargs=1 T2CAddContrast lua require("text-to-colorscheme").add_contrast(<f-args>)')

vim.api.nvim_command('command! -nargs=1 T2CSetSaturation lua require("text-to-colorscheme").set_saturation_offset(<f-args>)')
vim.api.nvim_command('command! -nargs=1 T2CAddSaturation lua require("text-to-colorscheme").add_saturation_offset(<f-args>)')

vim.api.nvim_command('command! -nargs=0 T2CSave lua require("text-to-colorscheme").user_save_current_palette()')
