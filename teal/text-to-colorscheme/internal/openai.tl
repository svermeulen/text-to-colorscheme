
local class <const> = require("text-to-colorscheme.internal.class")
local UserSettings <const> = require("text-to-colorscheme.user_settings")
local log <const> = require("text-to-colorscheme.internal.log")
local asserts <const> = require("text-to-colorscheme.internal.asserts")
local HexPalette <const> = require("text-to-colorscheme.hex_palette")
local builtin_palettes_provider <const> = require("text-to-colorscheme.internal.builtin_palettes_provider")
local color_util <const> = require("text-to-colorscheme.internal.color_util")

local record OpenAiResponse
   record ChoiceMessage
      content:string
      role:string
   end

   record Choice
      finish_reason:string
      index:integer
      message:ChoiceMessage
   end

   record UsageInfo
      completion_tokens:integer
      prompt_tokens:integer
      total_tokens:integer
   end

   choices:{Choice}
   id:string
   model:string
   object:string
   usage:UsageInfo
end

local record OpenAi
   metamethod __call: function(self: OpenAi): OpenAi
end

function OpenAi:__init()
end

local function get_example_messages():{string:string}
   local result:{string:string} = {}

   for _, hsv_int_palette in ipairs(builtin_palettes_provider()) do
      local hsv_palette = color_util.hsv_palette_int_to_hsv_palette(hsv_int_palette)

      local format_args = {
         color_util.hsv_to_hex(hsv_palette.background),
         color_util.hsv_to_hex(hsv_palette.foreground),
      }
      for _, accent in ipairs(hsv_palette.accents) do
         table.insert(format_args, color_util.hsv_to_hex(accent))
      end
      result[hsv_palette.name] = string.format([[return {
  background = \"%s\",
  foreground = \"%s\",
  accents = {
     \"%s\",
     \"%s\",
     \"%s\",
     \"%s\",
     \"%s\",
     \"%s\",
     \"%s\",
  },
}
]], table.unpack(format_args))
   end

   return result
end

function OpenAi:_construct_curl_command(api_key:string, theme_prompt:string, user_settings:UserSettings):{string}

   local function escape_newlines(value:string):string
      local result, _ = value:gsub("\n", "\\n")
      return result
   end

   local system_instruction = [[You are a color palette generator.  You will be given a text theme and you will respond with the color palette that best matches that theme.  The format of the response should be Lua code.  For example:

-------
return {
  background = \"<hex color>\",
  foreground = \"<hex color>\",
  accents = {
     \"<hex color>\",
     \"<hex color>\",
     \"<hex color>\",
     \"<hex color>\",
     \"<hex color>\",
     \"<hex color>\",
     \"<hex color>\",
  },
}
-------

It is important that the accent colors all be visually distinct from each other.  Return only the new lua code and nothing else.
]]

   local example_messages:{string:string} = get_example_messages()

   local example_prompts_and_answers = ""

   for key, value in pairs(example_messages) do
      example_prompts_and_answers = example_prompts_and_answers .. [[
      {
         "role": "user",
         "content": "]] .. key .. [["
      },
      {
         "role": "assistant",
         "content": "]] .. escape_newlines(value) .. [["
      },]]
   end

   return {
    'curl',
    '-XPOST',
    '-H', 'Content-Type: application/json',
    '-H', 'Authorization: Bearer ' .. api_key,
    '-d', [[{
      "model": "]] .. user_settings.gpt_model .. [[",
      "temperature": 0,
      "messages": [
        {
          "role": "system",
          "content": "]] .. escape_newlines(system_instruction) .. [["
        },]] .. example_prompts_and_answers .. [[
        {
          "role": "user",
          "content": "]] .. theme_prompt .. [["
        }
      ]
      }]],
    'https://api.openai.com/v1/chat/completions'
  }
end

function OpenAi:generate_new_palette(api_key:string, theme_prompt:string, user_settings:UserSettings, callback:function(HexPalette))
   asserts.that(theme_prompt ~= nil and api_key ~= nil, "Invalid parameters provided to generate_new_palette")
   asserts.that(user_settings.gpt_model ~= nil)

   log.info("Sending request to OpenAI...")

   local all_data = {}
   local ellipses_index = 1
   local ellipses_frames = { '.', '..', '...' }

   local function output_progress()
      local progress_message = "[text-to-colorscheme] Generating color scheme matching theme '" .. theme_prompt .. "'" .. ellipses_frames[ellipses_index]
      vim.api.nvim_echo({{progress_message, "Normal"}}, false, {})

      ellipses_index = (ellipses_index % 3) + 1
   end

   local function onread(_:integer, data:{string}, _:string)
      if data then
         table.insert(all_data, table.concat(data, "\n"))
      end
   end

   local progress_timer = vim.loop.new_timer()

   local function onexit(code:integer)
      progress_timer:stop()
      if code == 0 then
         local all_data_str = table.concat(all_data, "")
         local response:OpenAiResponse = vim.fn.json_decode(all_data_str) as OpenAiResponse

         if response then
            local lua_str = response.choices[1].message.content
            log.debug("Received lua back from openai: '%s'", lua_str)
            local obj_provider = load(lua_str)
            asserts.that(obj_provider ~= nil)
            local result = obj_provider() as HexPalette
            asserts.that(result ~= nil)
            asserts.that(result.name == nil)
            asserts.that(color_util.is_valid_hex_color(result.background))
            asserts.that(color_util.is_valid_hex_color(result.foreground))
            asserts.that(#result.accents == 7)
            result.name = theme_prompt
            -- TODO - handle light mode too
            result.background_mode = "dark"
            callback(result)
         else
            log.error("Unexpected response received from OpenAI")
         end
      else
         log.error("Failure when communicating with OpenAI API.  Curl command exited with code '%s'", code)
      end
   end

   local progress_output_interval_msecs = 250
   progress_timer:start(progress_output_interval_msecs, progress_output_interval_msecs, function()
      vim.schedule(output_progress)
   end)

   local curl_command = self:_construct_curl_command(api_key, theme_prompt, user_settings)

   -- if log.verbose then
   --    log.debug("Executing curl command: %s", vim.inspect(curl_command))
   -- end

   local job_id = vim.fn.jobstart(curl_command, {
      on_stdout = onread,
      on_exit = function(_:integer, code:integer, _:string)
         vim.schedule(function()
            onexit(code)
         end)
      end
   })

   if job_id > 0 then
      log.info("Sent request to OpenAI.  Waiting for response...")
   else
      log.error("Failed to start OpenAI request job")
   end
end

class.setup(OpenAi, "OpenAi")
return OpenAi
