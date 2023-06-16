
local record log
   verbose:boolean
end

local function format_message(...:any):string
   local args = {...}

   if #args == 1 then
      return tostring(args[1])
   end

   local first_arg = args[1]

   local full_message:string

   if first_arg is string then
      table.remove(args, 1)
      full_message = string.format(first_arg, table.unpack(args))
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

function log.error(...:any)
   vim.api.nvim_err_writeln("[text-to-colorscheme] " .. format_message(...))
end

local function escape_for_command_line(message:string):string
   message = message:gsub("\n", "\\n")
   message = vim.fn.escape(message, '"')
   return message
end

function log.notify(...:any)
   vim.cmd('echomsg "' .. escape_for_command_line(format_message(...)) .. '"')
end

function log.info(...:any)
   if log.verbose then
      vim.cmd('echomsg "[text-to-colorscheme] ' .. escape_for_command_line(format_message(...)) .. '"')
   end
end

function log.debug(...:any)
   if log.verbose then
      vim.cmd('echomsg "[text-to-colorscheme] ' .. escape_for_command_line(format_message(...)) .. '"')
   end
end

return log
