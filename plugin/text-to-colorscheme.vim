
command! -nargs=1 T2CGenerate lua require("text-to-colorscheme").generate_new_palette_and_apply(<f-args>)

function! s:GetT2CSelectValidCompletions(...)
  return luaeval("require(\"text-to-colorscheme\").get_all_palette_names()")
endfunction

command! -nargs=1 -complete=customlist,s:GetT2CSelectValidCompletions T2CSelect lua require("text-to-colorscheme").select_palette(<f-args>)

command! -nargs=1 T2CSetContrast lua require("text-to-colorscheme").set_contrast(<f-args>)
command! -nargs=1 T2CAddContrast lua require("text-to-colorscheme").add_contrast(<f-args>)

command! -nargs=1 T2CSetSaturation lua require("text-to-colorscheme").set_saturation_offset(<f-args>)
command! -nargs=1 T2CAddSaturation lua require("text-to-colorscheme").add_saturation_offset(<f-args>)

command! -nargs=0 T2CShuffleAccents lua require("text-to-colorscheme").shuffle_accents()
command! -nargs=0 T2CResetChanges lua require("text-to-colorscheme").reset_changes()

command! -nargs=0 T2CSave lua require("text-to-colorscheme").user_save_current_palette()

