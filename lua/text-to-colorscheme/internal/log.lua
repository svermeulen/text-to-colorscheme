local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table; local _tl_table_unpack = unpack or table.unpack
local log = {}



local function format_message(...)
   local args = { ... }

   if #args == 1 then
      return tostring(args[1])
   end

   local first_arg = args[1]

   local full_message

   if type(first_arg) == "string" then
      table.remove(args, 1)
      full_message = string.format(first_arg, _tl_table_unpack(args))
   else
      full_message = ""

      for _, value in ipairs(args) do
         if #full_message > 0 then
            full_message = full_message .. ", "
         end
         full_message = full_message .. tostring(value)
      end
   end

   return full_message
end

function log.error(...)
   vim.api.nvim_err_writeln("[text-to-colorscheme] " .. format_message(...))
end

local function escape_for_command_line(message)
   message = message:gsub("\n", "\\n")
   message = vim.fn.escape(message, '"')
   return message
end

function log.info(...)
   if log.verbose then
      vim.cmd('echomsg "[text-to-colorscheme] ' .. escape_for_command_line(format_message(...)) .. '"')
   end
end

function log.debug(...)
   if log.verbose then
      vim.cmd('echomsg "[text-to-colorscheme] ' .. escape_for_command_line(format_message(...)) .. '"')
   end
end

return log
