local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local pairs = _tl_compat and _tl_compat.pairs or pairs; local table = _tl_compat and _tl_compat.table or table
local class = require("text-to-colorscheme.internal.class")
local HsvColor = require("text-to-colorscheme.hsv_color")
local CustomHighlightDefinition = require("text-to-colorscheme.internal.custom_highlight_definition")
local HsvPalette = require("text-to-colorscheme.hsv_palette")
local UserSettings = require("text-to-colorscheme.user_settings")
local color_util = require("text-to-colorscheme.internal.color_util")

local GroupsProvider = {}



function GroupsProvider:__init()
end

function GroupsProvider:get_highlight_groups(palette, config, background_mode)
   local bg_brightness_increment = 0.07843137254902
   local fg_brightness_increment = 0.081372549019608

   local function transform(color, brightness_increment)
      if brightness_increment ~= nil then
         if background_mode == "light" then
            brightness_increment = brightness_increment * -1
         end
         return color_util.add_hsv_brightness(color, brightness_increment)
      end
      return color
   end

   local bg0 = palette.background
   local bg1 = transform(palette.background, 1 * bg_brightness_increment)
   local bg2 = transform(palette.background, 2 * bg_brightness_increment)
   local bg3 = transform(palette.background, 3 * bg_brightness_increment)
   local bg4 = transform(palette.background, 4 * bg_brightness_increment)

   local fg0 = transform(palette.foreground, 1 * fg_brightness_increment)
   local fg1 = palette.foreground
   local fg2 = transform(palette.foreground, -1 * fg_brightness_increment)
   local fg3 = transform(palette.foreground, -2 * fg_brightness_increment)
   local fg4 = transform(palette.foreground, -3 * fg_brightness_increment)
   local fg5 = transform(palette.foreground, -4 * fg_brightness_increment)

   local clr1 = palette.accents[1]
   local clr2 = palette.accents[2]
   local clr3 = palette.accents[3]
   local clr4 = palette.accents[4]
   local clr5 = palette.accents[5]
   local clr6 = palette.accents[6]
   local clr7 = palette.accents[7]

   local groups = {

      T2CClr1Sign = config.transparent_mode and { fg = clr1, reverse = config.invert_signs } or
      { fg = clr1, bg = bg1, reverse = config.invert_signs },
      T2CClr2Sign = config.transparent_mode and { fg = clr2, reverse = config.invert_signs } or
      { fg = clr2, bg = bg1, reverse = config.invert_signs },
      T2CClr3Sign = config.transparent_mode and { fg = clr3, reverse = config.invert_signs } or
      { fg = clr3, bg = bg1, reverse = config.invert_signs },
      T2CClr4Sign = config.transparent_mode and { fg = clr4, reverse = config.invert_signs } or
      { fg = clr4, bg = bg1, reverse = config.invert_signs },
      T2CClr5Sign = config.transparent_mode and { fg = clr5, reverse = config.invert_signs } or
      { fg = clr5, bg = bg1, reverse = config.invert_signs },
      T2CClr6Sign = config.transparent_mode and { fg = clr6, reverse = config.invert_signs } or
      { fg = clr6, bg = bg1, reverse = config.invert_signs },
      T2CClr7Sign = config.transparent_mode and { fg = clr7, reverse = config.invert_signs } or
      { fg = clr7, bg = bg1, reverse = config.invert_signs },






      Statement = { fg = clr1 },
      Conditional = { fg = clr1 },
      Repeat = { fg = clr1 },
      Label = { fg = clr1 },
      Exception = { fg = clr1 },
      Keyword = { fg = clr1 },
      StorageClass = { fg = clr1 },


      Constant = { fg = clr2 },
      Number = { fg = clr2 },
      Character = { fg = clr2 },
      String = { fg = clr2, italic = config.italic.strings },
      Boolean = { fg = clr2 },
      Float = { fg = clr2 },
      SpecialChar = { fg = color_util.hsv_lerp(clr2, clr7, 0.2) },


      Type = { fg = clr3 },
      Structure = { fg = clr3 },
      Typedef = { fg = clr3 },


      Function = { fg = clr4 },


      Operator = { fg = clr5, italic = config.italic.operators },


      Identifier = { fg = color_util.hsv_lerp(clr5, fg1, 0.85) },


      Special = { fg = clr6 },


      PreProc = { fg = clr7 },
      Include = { fg = clr7 },
      Define = { fg = clr7 },
      Macro = { fg = clr7 },
      PreCondit = { fg = clr7 },

      Error = { fg = clr7, bold = config.bold, reverse = config.inverse },
      ErrorMsg = { fg = clr7, bg = bg0, bold = config.bold, reverse = config.inverse },







      ["@keyword"] = { link = "Keyword" },


      ["@keyword.function"] = { link = "Keyword" },

      ["@keyword.return"] = { link = "Keyword" },


      ["@conditional"] = { link = "Conditional" },



      ["@repeat"] = { link = "Repeat" },

      ["@debug"] = { link = "Keyword" },

      ["@label"] = { link = "Label" },

      ["@include"] = { link = "Keyword" },

      ["@exception"] = { link = "Exception" },


      ["@storageclass"] = { link = "StorageClass" },


      ["@variable"] = { link = "Identifier" },

      ["@variable.builtin"] = { link = "Identifier" },

      ["@parameter"] = { link = "Identifier" },

      ["@field"] = { link = "Identifier" },

      ["@symbol"] = { link = "Identifier" },


      ["@constant"] = { link = "Identifier" },


      ["@string"] = { link = "String" },


      ["@string.regex"] = { link = "String" },

      ["@string.escape"] = { link = "SpecialChar" },

      ["@string.special"] = { link = "SpecialChar" },


      ["@character"] = { link = "Character" },

      ["@character.special"] = { link = "SpecialChar" },


      ["@boolean"] = { link = "Boolean" },

      ["@number"] = { link = "Number" },

      ["@float"] = { link = "Float" },


      ["@type"] = { fg = transform(clr3, 2 * fg_brightness_increment) },

      ["@type.builtin"] = { fg = transform(clr3, -1 * fg_brightness_increment) },

      ["@type.definition"] = { link = "Typedef" },

      ["@type.qualifier"] = { fg = clr3 },


      ["@function"] = { link = "Function" },

      ["@function.builtin"] = { link = "Function" },

      ["@function.call"] = { link = "Function" },

      ["@function.macro"] = { link = "Function" },

      ["@property"] = { link = "Function" },


      ["@method"] = { link = "Function" },

      ["@method.call"] = { link = "Function" },

      ["@constructor"] = { link = "Function" },

      ["@attribute"] = { link = "Function" },


      ["@operator"] = { link = "Operator" },

      ["@keyword.operator"] = { link = "Operator" },


      ["@preproc"] = { link = "PreProc" },

      ["@define"] = { link = "Define" },

      ["@constant.macro"] = { link = "Define" },


      ["@constant.builtin"] = { link = "Special" },


      ["@comment"] = { link = "Comment" },




      ["@punctuation.delimiter"] = { link = "Delimiter" },

      ["@punctuation.bracket"] = { link = "Delimiter" },

      ["@punctuation.special"] = { link = "Delimiter" },


      ["@namespace"] = { fg = fg1 },

      ["@none"] = { bg = nil, fg = nil },





      ["@text"] = { fg = fg1 },

      ["@text.strong"] = { bold = config.bold },

      ["@text.emphasis"] = { italic = config.italic.strings },

      ["@text.underline"] = { underline = config.underline },

      ["@text.strike"] = { strikethrough = config.strikethrough },

      ["@text.title"] = { link = "Title" },

      ["@text.literal"] = { link = "String" },


      ["@text.uri"] = { link = "Underlined" },

      ["@text.math"] = { link = "Special" },

      ["@text.environment"] = { link = "Macro" },

      ["@text.environment.name"] = { fg = clr3 },

      ["@text.reference"] = { link = "Constant" },


      ["@text.todo"] = { link = "Todo" },

      ["@text.note"] = { link = "SpecialComment" },

      ["@text.note.comment"] = { fg = clr5, bold = config.bold },

      ["@text.warning"] = { link = "WarningMsg" },

      ["@text.danger"] = { link = "ErrorMsg" },

      ["@text.danger.comment"] = { fg = bg1, bg = clr6, bold = config.bold },


      ["@text.diff.add"] = { link = "diffAdded" },

      ["@text.diff.delete"] = { link = "diffRemoved" },






      ["@tag"] = { link = "Tag" },

      ["@tag.attribute"] = { link = "Identifier" },

      ["@tag.delimiter"] = { link = "Delimiter" },
















      ["@punctuation"] = { link = "Delimiter" },
      ["@macro"] = { link = "Macro" },
      ["@structure"] = { link = "Structure" },



      ["@lsp.type.class"] = { link = "@constructor" },
      ["@lsp.type.comment"] = {},
      ["@lsp.type.decorator"] = { link = "@parameter" },
      ["@lsp.type.enum"] = { link = "@type" },
      ["@lsp.type.enumMember"] = { link = "@constant" },
      ["@lsp.type.function"] = { link = "@function" },
      ["@lsp.type.interface"] = { link = "@keyword" },
      ["@lsp.type.macro"] = { link = "@macro" },
      ["@lsp.type.method"] = { link = "@method" },
      ["@lsp.type.namespace"] = { link = "@namespace" },
      ["@lsp.type.parameter"] = { link = "@parameter" },
      ["@lsp.type.property"] = { link = "@property" },
      ["@lsp.type.struct"] = { link = "@constructor" },
      ["@lsp.type.type"] = { link = "@type" },
      ["@lsp.type.typeParameter"] = { link = "@type.definition" },
      ["@lsp.type.variable"] = { link = "@variable" },

      Normal = config.transparent_mode and { fg = fg1 } or { fg = fg1, bg = bg0 },
      NormalFloat = config.transparent_mode and { fg = fg1 } or { fg = fg1, bg = transform(bg1, 0.5 * bg_brightness_increment) },
      NormalNC = config.dim_inactive and { fg = fg0, bg = bg1 } or { link = "Normal" },
      CursorLine = { bg = bg1 },
      CursorColumn = { link = "CursorLine" },
      TabLineFill = { fg = bg4, bg = bg1, reverse = config.invert_tabline },
      TabLineSel = { fg = clr2, bg = bg1, reverse = config.invert_tabline },
      TabLine = { link = "TabLineFill" },
      MatchParen = { bg = bg3, bold = config.bold },
      ColorColumn = { bg = bg1 },
      Conceal = { fg = clr4 },
      CursorLineNr = { fg = clr3, bg = bg1 },
      NonText = { fg = bg2 },
      SpecialKey = { fg = fg4 },
      Visual = { bg = bg3, reverse = config.invert_selection },
      VisualNOS = { link = "Visual" },
      Search = { fg = clr6, bg = bg0, reverse = config.inverse },
      IncSearch = { fg = clr6, bg = bg0, reverse = config.inverse },
      CurSearch = { link = "IncSearch" },
      QuickFixLine = { fg = bg0, bg = clr3, bold = config.bold },
      Underlined = { fg = clr4, underline = config.underline },
      StatusLine = { fg = bg2, bg = fg1, reverse = config.inverse },
      StatusLineNC = { fg = bg1, bg = fg4, reverse = config.inverse },
      WinBar = { fg = fg4, bg = bg0 },
      WinBarNC = { fg = fg3, bg = bg1 },
      WinSeparator = config.transparent_mode and { fg = bg3 } or { fg = bg3, bg = bg0 },
      WildMenu = { fg = clr4, bg = bg2, bold = config.bold },
      Directory = { fg = clr4, bold = config.bold },
      Title = { fg = clr2, bold = config.bold },
      MoreMsg = { fg = clr3, bold = config.bold },
      ModeMsg = { fg = clr3, bold = config.bold },
      Question = { fg = clr1, bold = config.bold },
      WarningMsg = { fg = clr3, bold = config.bold },
      LineNr = { fg = bg4 },
      SignColumn = config.transparent_mode and { bg = nil } or { bg = bg1 },
      Folded = { fg = fg5, bg = bg1, italic = config.italic.folds },
      FoldColumn = config.transparent_mode and { fg = fg5 } or { fg = fg5, bg = bg1 },
      Cursor = { reverse = config.inverse },
      vCursor = { link = "Cursor" },
      iCursor = { link = "Cursor" },
      lCursor = { link = "Cursor" },
      Delimiter = { fg = fg3 },
      Comment = { fg = fg4, italic = config.italic.comments },

      Todo = { fg = bg0, bg = clr3, bold = config.bold, italic = config.italic.comments },
      Done = { fg = clr1, bold = config.bold, italic = config.italic.comments },

      Pmenu = { fg = fg1, bg = bg2 },
      PmenuSel = { fg = bg2, bg = clr4, bold = config.bold },
      PmenuSbar = { bg = bg2 },
      PmenuThumb = { bg = bg4 },
      DiffDelete = { fg = clr6, bg = bg0, reverse = config.inverse },
      DiffAdd = { fg = clr2, bg = bg0, reverse = config.inverse },
      DiffChange = { fg = clr7, bg = bg0, reverse = config.inverse },
      DiffText = { fg = clr3, bg = bg0, reverse = config.inverse },
      SpellCap = { undercurl = config.undercurl, sp = clr4 },
      SpellBad = { undercurl = config.undercurl, sp = clr6 },
      SpellLocal = { undercurl = config.undercurl, sp = clr7 },
      SpellRare = { undercurl = config.undercurl, sp = clr5 },
      Whitespace = { fg = bg2 },

      DiagnosticError = { fg = clr7 },
      DiagnosticSignError = { link = "T2CClr7Sign" },
      DiagnosticUnderlineError = { undercurl = config.undercurl, sp = clr7 },
      DiagnosticWarn = { fg = clr3 },
      DiagnosticSignWarn = { link = "T2CClr6Sign" },
      DiagnosticUnderlineWarn = { undercurl = config.undercurl, sp = clr3 },
      DiagnosticInfo = { fg = clr6 },
      DiagnosticSignInfo = { link = "T2CClr3Sign" },
      DiagnosticUnderlineInfo = { undercurl = config.undercurl, sp = clr6 },
      DiagnosticHint = { fg = clr1 },
      DiagnosticSignHint = { link = "T2CClr1Sign" },
      DiagnosticUnderlineHint = { undercurl = config.undercurl, sp = clr1 },
      DiagnosticFloatingError = { fg = clr7 },
      DiagnosticFloatingWarn = { fg = clr3 },
      DiagnosticFloatingInfo = { fg = clr6 },
      DiagnosticFloatingHint = { fg = clr1 },
      DiagnosticVirtualTextError = { fg = clr7 },
      DiagnosticVirtualTextWarn = { fg = clr3 },
      DiagnosticVirtualTextInfo = { fg = clr6 },
      DiagnosticVirtualTextHint = { fg = clr1 },
      LspReferenceRead = { fg = clr3, bold = config.bold },
      LspReferenceText = { fg = clr3, bold = config.bold },
      LspReferenceWrite = { fg = clr1, bold = config.bold },
      LspCodeLens = { fg = fg5 },
      LspSignatureActiveParameter = { link = "Search" },


      gitcommitSelectedFile = { fg = clr1 },
      gitcommitDiscardedFile = { fg = clr6 },

      GitSignsAdd = { link = "T2CClr5Sign" },
      GitSignsChange = { link = "T2CClr6Sign" },
      GitSignsDelete = { link = "T2CClr7Sign" },

      NvimTreeSymlink = { fg = clr7 },
      NvimTreeRootFolder = { fg = clr5, bold = true },
      NvimTreeFolderIcon = { fg = clr4, bold = true },
      NvimTreeFileIcon = { fg = clr4 },
      NvimTreeExecFile = { fg = clr2, bold = true },
      NvimTreeOpenedFile = { fg = clr6, bold = true },
      NvimTreeSpecialFile = { fg = clr3, bold = true, underline = true },
      NvimTreeImageFile = { fg = clr5 },
      NvimTreeIndentMarker = { fg = bg3 },
      NvimTreeGitDirty = { fg = clr3 },
      NvimTreeGitStaged = { fg = clr3 },
      NvimTreeGitMerge = { fg = clr5 },
      NvimTreeGitRenamed = { fg = clr5 },
      NvimTreeGitNew = { fg = clr3 },
      NvimTreeGitDeleted = { fg = clr6 },
      NvimTreeWindowPicker = { bg = clr7, fg = bg1 },

      debugPC = { bg = clr4, fg = bg1 },
      debugBreakpoint = { link = "T2CClr6Sign" },

      StartifyBracket = { fg = fg3 },
      StartifyFile = { fg = fg1 },
      StartifyNumber = { fg = clr4 },
      StartifyPath = { fg = fg5 },
      StartifySlash = { fg = fg5 },
      StartifySection = { fg = clr3 },
      StartifySpecial = { fg = bg2 },
      StartifyHeader = { fg = clr1 },
      StartifyFooter = { fg = bg2 },
      StartifyVar = { link = "StartifyPath" },
      StartifySelect = { link = "Title" },

      DirvishPathTail = { fg = clr7 },
      DirvishArg = { fg = clr3 },

      netrwDir = { fg = clr7 },
      netrwClassify = { fg = clr7 },
      netrwLink = { fg = fg5 },
      netrwSymLink = { fg = fg1 },
      netrwExe = { fg = clr3 },
      netrwComment = { fg = fg5 },
      netrwList = { fg = clr4 },
      netrwHelpCmd = { fg = clr7 },
      netrwCmdSep = { fg = fg3 },
      netrwVersion = { fg = clr2 },

      NERDTreeDir = { fg = clr7 },
      NERDTreeDirSlash = { fg = clr7 },
      NERDTreeOpenable = { fg = clr1 },
      NERDTreeClosable = { fg = clr1 },
      NERDTreeFile = { fg = fg1 },
      NERDTreeExecFile = { fg = clr3 },
      NERDTreeUp = { fg = fg5 },
      NERDTreeCWD = { fg = clr2 },
      NERDTreeHelp = { fg = fg1 },
      NERDTreeToggleOn = { fg = clr2 },
      NERDTreeToggleOff = { fg = clr6 },

      CocErrorSign = { link = "T2CClr7Sign" },
      CocWarningSign = { link = "T2CClr6Sign" },
      CocInfoSign = { link = "T2CClr3Sign" },
      CocHintSign = { link = "T2CClr1Sign" },
      CocErrorFloat = { fg = clr7 },
      CocWarningFloat = { fg = clr3 },
      CocInfoFloat = { fg = clr6 },
      CocHintFloat = { fg = clr1 },
      CocDiagnosticsError = { fg = clr7 },
      CocDiagnosticsWarning = { fg = clr3 },
      CocDiagnosticsInfo = { fg = clr6 },
      CocDiagnosticsHint = { fg = clr1 },
      CocSelectedText = { fg = clr2 },
      CocMenuSel = { link = "PmenuSel" },
      CocCodeLens = { fg = fg5 },
      CocErrorHighlight = { undercurl = config.undercurl, sp = clr7 },
      CocWarningHighlight = { undercurl = config.undercurl, sp = clr3 },
      CocInfoHighlight = { undercurl = config.undercurl, sp = clr6 },
      CocHintHighlight = { undercurl = config.undercurl, sp = clr1 },


      TelescopeNormal = { fg = fg1 },
      TelescopeSelection = { fg = clr4, bold = config.bold },
      TelescopeSelectionCaret = { fg = clr5 },
      TelescopeMultiSelection = { fg = fg5 },
      TelescopeBorder = { link = "TelescopeNormal" },
      TelescopePromptBorder = { link = "TelescopeNormal" },
      TelescopeResultsBorder = { link = "TelescopeNormal" },
      TelescopePreviewBorder = { link = "TelescopeNormal" },
      TelescopeMatching = { fg = clr6 },
      TelescopePromptPrefix = { fg = clr5 },
      TelescopePrompt = { link = "TelescopeNormal" },

      CmpItemAbbr = { fg = fg0 },
      CmpItemAbbrDeprecated = { fg = fg1 },
      CmpItemAbbrMatch = { fg = clr4, bold = config.bold },
      CmpItemAbbrMatchFuzzy = { undercurl = config.undercurl, sp = clr4 },
      CmpItemMenu = { fg = fg5 },
      CmpItemKindText = { fg = clr1 },
      CmpItemKindVariable = { fg = clr1 },
      CmpItemKindMethod = { fg = clr4 },
      CmpItemKindFunction = { fg = clr4 },
      CmpItemKindConstructor = { fg = clr3 },
      CmpItemKindUnit = { fg = clr4 },
      CmpItemKindField = { fg = clr4 },
      CmpItemKindClass = { fg = clr3 },
      CmpItemKindInterface = { fg = clr3 },
      CmpItemKindModule = { fg = clr4 },
      CmpItemKindProperty = { fg = clr4 },
      CmpItemKindValue = { fg = clr1 },
      CmpItemKindEnum = { fg = clr3 },
      CmpItemKindOperator = { fg = clr3 },
      CmpItemKindKeyword = { fg = clr5 },
      CmpItemKindEvent = { fg = clr5 },
      CmpItemKindReference = { fg = clr5 },
      CmpItemKindColor = { fg = clr5 },
      CmpItemKindSnippet = { fg = clr2 },
      CmpItemKindFile = { fg = clr4 },
      CmpItemKindFolder = { fg = clr4 },
      CmpItemKindEnumMember = { fg = clr7 },
      CmpItemKindConstant = { fg = clr1 },
      CmpItemKindStruct = { fg = clr3 },
      CmpItemKindTypeParameter = { fg = clr3 },
      diffAdded = { fg = clr2 },
      diffRemoved = { fg = clr6 },
      diffChanged = { fg = clr7 },
      diffFile = { fg = clr1 },
      diffNewFile = { fg = clr3 },
      diffOldFile = { fg = clr1 },
      diffLine = { fg = clr4 },
      diffIndexLine = { link = "diffChanged" },

      NavicIconsFile = { fg = clr4 },
      NavicIconsModule = { fg = clr1 },
      NavicIconsNamespace = { fg = clr4 },
      NavicIconsPackage = { fg = clr7 },
      NavicIconsClass = { fg = clr3 },
      NavicIconsMethod = { fg = clr4 },
      NavicIconsProperty = { fg = clr7 },
      NavicIconsField = { fg = clr5 },
      NavicIconsConstructor = { fg = clr4 },
      NavicIconsEnum = { fg = clr5 },
      NavicIconsInterface = { fg = clr2 },
      NavicIconsFunction = { fg = clr4 },
      NavicIconsVariable = { fg = clr5 },
      NavicIconsConstant = { fg = clr1 },
      NavicIconsString = { fg = clr2 },
      NavicIconsNumber = { fg = clr1 },
      NavicIconsBoolean = { fg = clr1 },
      NavicIconsArray = { fg = clr1 },
      NavicIconsObject = { fg = clr1 },
      NavicIconsKey = { fg = clr7 },
      NavicIconsNull = { fg = clr1 },
      NavicIconsEnumMember = { fg = clr3 },
      NavicIconsStruct = { fg = clr5 },
      NavicIconsEvent = { fg = clr3 },
      NavicIconsOperator = { fg = clr6 },
      NavicIconsTypeParameter = { fg = clr6 },
      NavicText = { link = "T2CWhite" },
      NavicSeparator = { link = "T2CWhite" },

      htmlTag = { fg = clr7, bold = config.bold },
      htmlEndTag = { fg = clr7, bold = config.bold },
      htmlTagName = { fg = clr4 },
      htmlArg = { fg = clr1 },
      htmlTagN = { fg = fg1 },
      htmlSpecialTagName = { fg = clr4 },
      htmlLink = { fg = fg4, underline = config.underline },
      htmlSpecialChar = { fg = clr6 },
      htmlBold = { fg = fg0, bg = bg0, bold = config.bold },
      htmlBoldUnderline = { fg = fg0, bg = bg0, bold = config.bold, underline = config.underline },
      htmlBoldItalic = { fg = fg0, bg = bg0, bold = config.bold, italic = true },
      htmlBoldUnderlineItalic = {
         fg = fg0,
         bg = bg0,
         bold = config.bold,
         italic = true,
         underline = config.underline,
      },
      htmlUnderline = { fg = fg0, bg = bg0, underline = config.underline },
      htmlUnderlineItalic = {
         fg = fg0,
         bg = bg0,
         italic = true,
         underline = config.underline,
      },
      htmlItalic = { fg = fg0, bg = bg0, italic = true },

      xmlTag = { fg = clr7, bold = config.bold },
      xmlEndTag = { fg = clr7, bold = config.bold },
      xmlTagName = { fg = clr4 },
      xmlEqual = { fg = clr4 },
      docbkKeyword = { fg = clr7, bold = config.bold },
      xmlDocTypeDecl = { fg = fg5 },
      xmlDocTypeKeyword = { fg = clr5 },
      xmlCdataStart = { fg = fg5 },
      xmlCdataCdata = { fg = clr5 },
      dtdFunction = { fg = fg5 },
      dtdTagName = { fg = clr5 },
      xmlAttrib = { fg = clr1 },
      xmlProcessingDelim = { fg = fg5 },
      dtdParamEntityPunct = { fg = fg5 },
      dtdParamEntityDPunct = { fg = fg5 },
      xmlAttribPunct = { fg = fg5 },
      xmlEntity = { fg = clr6 },
      xmlEntityPunct = { fg = clr6 },

      clojureKeyword = { fg = clr4 },
      clojureCond = { fg = clr1 },
      clojureSpecial = { fg = clr1 },
      clojureDefine = { fg = clr1 },
      clojureFunc = { fg = clr3 },
      clojureRepeat = { fg = clr3 },
      clojureCharacter = { fg = clr7 },
      clojureStringEscape = { fg = clr7 },
      clojureException = { fg = clr6 },
      clojureRegexp = { fg = clr7 },
      clojureRegexpEscape = { fg = clr7 },
      clojureRegexpCharClass = { fg = fg3, bold = config.bold },
      clojureRegexpMod = { link = "clojureRegexpCharClass" },
      clojureRegexpQuantifier = { link = "clojureRegexpCharClass" },
      clojureParen = { fg = fg3 },
      clojureAnonArg = { fg = clr3 },
      clojureVariable = { fg = clr4 },
      clojureMacro = { fg = clr1 },
      clojureMeta = { fg = clr3 },
      clojureDeref = { fg = clr3 },
      clojureQuote = { fg = clr3 },
      clojureUnquote = { fg = clr3 },

      cOperator = { fg = clr5 },
      cppOperator = { fg = clr5 },
      cStructure = { fg = clr1 },

      pythonBuiltin = { fg = clr1 },
      pythonBuiltinObj = { fg = clr1 },
      pythonBuiltinFunc = { fg = clr1 },
      pythonFunction = { fg = clr7 },
      pythonDecorator = { fg = clr6 },
      pythonInclude = { fg = clr4 },
      pythonImport = { fg = clr4 },
      pythonRun = { fg = clr4 },
      pythonCoding = { fg = clr4 },
      pythonOperator = { fg = clr6 },
      pythonException = { fg = clr6 },
      pythonExceptions = { fg = clr5 },
      pythonBoolean = { fg = clr5 },
      pythonDot = { fg = fg3 },
      pythonConditional = { fg = clr6 },
      pythonRepeat = { fg = clr6 },
      pythonDottedName = { fg = clr2, bold = config.bold },

      cssBraces = { fg = clr4 },
      cssFunctionName = { fg = clr3 },
      cssIdentifier = { fg = clr1 },
      cssClassName = { fg = clr2 },
      cssColor = { fg = clr4 },
      cssSelectorOp = { fg = clr4 },
      cssSelectorOp2 = { fg = clr4 },
      cssImportant = { fg = clr2 },
      cssVendor = { fg = fg1 },
      cssTextProp = { fg = clr7 },
      cssAnimationProp = { fg = clr7 },
      cssUIProp = { fg = clr3 },
      cssTransformProp = { fg = clr7 },
      cssTransitionProp = { fg = clr7 },
      cssPrintProp = { fg = clr7 },
      cssPositioningProp = { fg = clr3 },
      cssBoxProp = { fg = clr7 },
      cssFontDescriptorProp = { fg = clr7 },
      cssFlexibleBoxProp = { fg = clr7 },
      cssBorderOutlineProp = { fg = clr7 },
      cssBackgroundProp = { fg = clr7 },
      cssMarginProp = { fg = clr7 },
      cssListProp = { fg = clr7 },
      cssTableProp = { fg = clr7 },
      cssFontProp = { fg = clr7 },
      cssPaddingProp = { fg = clr7 },
      cssDimensionProp = { fg = clr7 },
      cssRenderProp = { fg = clr7 },
      cssColorProp = { fg = clr7 },
      cssGeneratedContentProp = { fg = clr7 },

      javaScriptBraces = { fg = fg1 },
      javaScriptFunction = { fg = clr7 },
      javaScriptIdentifier = { fg = clr6 },
      javaScriptMember = { fg = clr4 },
      javaScriptNumber = { fg = clr5 },
      javaScriptNull = { fg = clr5 },
      javaScriptParens = { fg = fg3 },

      typescriptReserved = { fg = clr7 },
      typescriptLabel = { fg = clr7 },
      typescriptFuncKeyword = { fg = clr7 },
      typescriptIdentifier = { fg = clr1 },
      typescriptBraces = { fg = fg1 },
      typescriptEndColons = { fg = fg1 },
      typescriptDOMObjects = { fg = fg1 },
      typescriptAjaxMethods = { fg = fg1 },
      typescriptLogicSymbols = { fg = fg1 },
      typescriptDocSeeTag = { link = "Comment" },
      typescriptDocParam = { link = "Comment" },
      typescriptDocTags = { link = "vimCommentTitle" },
      typescriptGlobalObjects = { fg = fg1 },
      typescriptParens = { fg = fg3 },
      typescriptOpSymbols = { fg = fg3 },
      typescriptHtmlElemProperties = { fg = fg1 },
      typescriptNull = { fg = clr5 },
      typescriptInterpolationDelimiter = { fg = clr7 },

      purescriptModuleKeyword = { fg = clr7 },
      purescriptModuleName = { fg = fg1 },
      purescriptWhere = { fg = clr7 },
      purescriptDelimiter = { fg = fg4 },
      purescriptType = { fg = fg1 },
      purescriptImportKeyword = { fg = clr7 },
      purescriptHidingKeyword = { fg = clr7 },
      purescriptAsKeyword = { fg = clr7 },
      purescriptStructure = { fg = clr7 },
      purescriptOperator = { fg = clr4 },
      purescriptTypeVar = { fg = fg1 },
      purescriptConstructor = { fg = fg1 },
      purescriptFunction = { fg = fg1 },
      purescriptConditional = { fg = clr1 },
      purescriptBacktick = { fg = clr1 },

      coffeeExtendedOp = { fg = fg3 },
      coffeeSpecialOp = { fg = fg3 },
      coffeeCurly = { fg = clr1 },
      coffeeParen = { fg = fg3 },
      coffeeBracket = { fg = clr1 },

      rubyStringDelimiter = { fg = clr2 },
      rubyInterpolationDelimiter = { fg = clr7 },
      rubyDefinedOperator = { link = "rubyKeyword" },

      objcTypeModifier = { fg = clr6 },
      objcDirective = { fg = clr4 },

      goDirective = { fg = clr7 },
      goConstants = { fg = clr5 },
      goDeclaration = { fg = clr6 },
      goDeclType = { fg = clr4 },
      goBuiltins = { fg = clr1 },

      luaIn = { fg = clr6 },
      luaFunction = { fg = clr7 },
      luaTable = { fg = clr1 },

      moonSpecialOp = { fg = fg3 },
      moonExtendedOp = { fg = fg3 },
      moonFunction = { fg = fg3 },
      moonObject = { fg = clr3 },

      javaAnnotation = { fg = clr4 },
      javaDocTags = { fg = clr7 },
      javaCommentTitle = { link = "vimCommentTitle" },
      javaParen = { fg = fg3 },
      javaParen1 = { fg = fg3 },
      javaParen2 = { fg = fg3 },
      javaParen3 = { fg = fg3 },
      javaParen4 = { fg = fg3 },
      javaParen5 = { fg = fg3 },
      javaOperator = { fg = clr1 },
      javaVarArg = { fg = clr2 },

      elixirDocString = { link = "Comment" },
      elixirStringDelimiter = { fg = clr2 },
      elixirInterpolationDelimiter = { fg = clr7 },
      elixirModuleDeclaration = { fg = clr3 },

      scalaNameDefinition = { fg = fg1 },
      scalaCaseFollowing = { fg = fg1 },
      scalaCapitalWord = { fg = fg1 },
      scalaTypeExtension = { fg = fg1 },
      scalaKeyword = { fg = clr6 },
      scalaKeywordModifier = { fg = clr6 },
      scalaSpecial = { fg = clr7 },
      scalaOperator = { fg = fg1 },
      scalaTypeDeclaration = { fg = clr3 },
      scalaTypeTypePostDeclaration = { fg = clr3 },
      scalaInstanceDeclaration = { fg = fg1 },
      scalaInterpolation = { fg = clr7 },

      markdownItalic = { fg = fg3, italic = true },
      markdownBold = { fg = fg3, bold = config.bold },
      markdownBoldItalic = { fg = fg3, bold = config.bold, italic = true },
      markdownH1 = { fg = clr2, bold = config.bold },
      markdownH2 = { fg = clr2, bold = config.bold },
      markdownH3 = { fg = clr3, bold = config.bold },
      markdownH4 = { fg = clr3, bold = config.bold },
      markdownH5 = { fg = clr3 },
      markdownH6 = { fg = clr3 },
      markdownCode = { fg = clr7 },
      markdownCodeBlock = { fg = clr7 },
      markdownCodeDelimiter = { fg = clr7 },
      markdownBlockquote = { fg = fg5 },
      markdownListMarker = { fg = fg5 },
      markdownOrderedListMarker = { fg = fg5 },
      markdownRule = { fg = fg5 },
      markdownHeadingRule = { fg = fg5 },
      markdownUrlDelimiter = { fg = fg3 },
      markdownLinkDelimiter = { fg = fg3 },
      markdownLinkTextDelimiter = { fg = fg3 },
      markdownHeadingDelimiter = { fg = clr1 },
      markdownUrl = { fg = clr5 },
      markdownUrlTitleDelimiter = { fg = clr2 },
      markdownLinkText = { fg = fg5, underline = config.underline },
      markdownIdDeclaration = { link = "markdownLinkText" },

      haskellType = { fg = clr4 },
      haskellIdentifier = { fg = clr7 },
      haskellSeparator = { fg = fg4 },
      haskellDelimiter = { fg = clr1 },
      haskellOperators = { fg = clr5 },
      haskellBacktick = { fg = clr1 },
      haskellStatement = { fg = clr5 },
      haskellConditional = { fg = clr5 },
      haskellLet = { fg = clr6 },
      haskellDefault = { fg = clr6 },
      haskellWhere = { fg = clr6 },
      haskellBottom = { fg = clr6, bold = config.bold },
      haskellImportKeywords = { fg = clr5, bold = config.bold },
      haskellDeclKeyword = { fg = clr1 },
      haskellDecl = { fg = clr1 },
      haskellDeriving = { fg = clr5 },
      haskellAssocType = { fg = clr7 },
      haskellNumber = { fg = clr7 },
      haskellPragma = { fg = clr6, bold = config.bold },
      haskellTH = { fg = clr7, bold = config.bold },
      haskellForeignKeywords = { fg = clr2 },
      haskellKeyword = { fg = clr6 },
      haskellFloat = { fg = clr7 },
      haskellInfix = { fg = clr5 },
      haskellQuote = { fg = clr2, bold = config.bold },
      haskellShebang = { fg = clr3, bold = config.bold },
      haskellLiquid = { fg = clr5, bold = config.bold },
      haskellQuasiQuoted = { fg = clr4, bold = config.bold },
      haskellRecursiveDo = { fg = clr5 },
      haskellQuotedType = { fg = clr6 },
      haskellPreProc = { fg = fg4 },
      haskellTypeRoles = { fg = clr6, bold = config.bold },
      haskellTypeForall = { fg = clr6 },
      haskellPatternKeyword = { fg = clr4 },

      jsonKeyword = { fg = clr2 },
      jsonQuote = { fg = clr2 },
      jsonBraces = { fg = fg1 },
      jsonString = { fg = fg1 },

      mailQuoted1 = { fg = clr7 },
      mailQuoted2 = { fg = clr5 },
      mailQuoted3 = { fg = clr3 },
      mailQuoted4 = { fg = clr2 },
      mailQuoted5 = { fg = clr6 },
      mailQuoted6 = { fg = clr1 },
      mailSignature = { link = "Comment" },

      csBraces = { fg = fg1 },
      csEndColon = { fg = fg1 },
      csLogicSymbols = { fg = fg1 },
      csParens = { fg = fg3 },
      csOpSymbols = { fg = fg3 },
      csInterpolationDelimiter = { fg = fg3 },
      csInterpolationAlignDel = { fg = clr7, bold = config.bold },
      csInterpolationFormat = { fg = clr7 },
      csInterpolationFormatDel = { fg = clr7, bold = config.bold },

      rustSigil = { fg = clr1 },
      rustEscape = { fg = clr7 },
      rustStringContinuation = { fg = clr7 },
      rustEnum = { fg = clr7 },
      rustStructure = { fg = clr7 },
      rustModPathSep = { fg = fg2 },
      rustCommentLineDoc = { link = "Comment" },
      rustDefault = { fg = clr7 },

      ocamlOperator = { fg = fg1 },
      ocamlKeyChar = { fg = clr1 },
      ocamlArrow = { fg = clr1 },
      ocamlInfixOpKeyword = { fg = clr6 },
      ocamlConstructor = { fg = clr1 },

      LspSagaCodeActionTitle = { link = "Title" },
      LspSagaCodeActionBorder = { fg = fg1 },
      LspSagaCodeActionContent = { fg = clr2, bold = config.bold },
      LspSagaLspFinderBorder = { fg = fg1 },
      LspSagaAutoPreview = { fg = clr1 },
      TargetWord = { fg = clr4, bold = config.bold },
      FinderSeparator = { fg = clr7 },
      LspSagaDefPreviewBorder = { fg = clr4 },
      LspSagaHoverBorder = { fg = clr1 },
      LspSagaRenameBorder = { fg = clr4 },
      LspSagaDiagnosticSource = { fg = clr1 },
      LspSagaDiagnosticBorder = { fg = clr5 },
      LspSagaDiagnosticHeader = { fg = clr2 },
      LspSagaSignatureHelpBorder = { fg = clr2 },
      SagaShadow = { fg = bg0 },


      DashboardShortCut = { fg = clr1 },
      DashboardHeader = { fg = clr7 },
      DashboardCenter = { fg = clr3 },
      DashboardFooter = { fg = clr5, italic = true },

      MasonHighlight = { fg = clr7 },
      MasonHighlightBlock = { fg = bg0, bg = clr4 },
      MasonHighlightBlockBold = { fg = bg0, bg = clr4, bold = true },
      MasonHighlightSecondary = { fg = clr3 },
      MasonHighlightBlockSecondary = { fg = bg0, bg = clr3 },
      MasonHighlightBlockBoldSecondary = { fg = bg0, bg = clr3, bold = true },
      MasonHeader = { link = "MasonHighlightBlockBoldSecondary" },
      MasonHeaderSecondary = { link = "MasonHighlightBlockBold" },
      MasonMuted = { fg = fg4 },
      MasonMutedBlock = { fg = bg0, bg = fg4 },
      MasonMutedBlockBold = { fg = bg0, bg = fg4, bold = true },

      LspInlayHint = { link = "comment" },

      CarbonFile = { fg = fg1 },
      CarbonExe = { fg = clr3 },
      CarbonSymlink = { fg = clr7 },
      CarbonBrokenSymlink = { fg = clr6 },
      CarbonIndicator = { fg = fg5 },
      CarbonDanger = { fg = clr6 },
      CarbonPending = { fg = clr3 },

      NoiceCursor = { link = "TermCursor" },

      NotifyDEBUGBorder = { fg = clr4 },
      NotifyDEBUGIcon = { fg = clr4 },
      NotifyDEBUGTitle = { fg = clr4 },
      NotifyERRORBorder = { fg = clr7 },
      NotifyERRORIcon = { fg = clr7 },
      NotifyERRORTitle = { fg = clr7 },
      NotifyINFOBorder = { fg = clr6 },
      NotifyINFOIcon = { fg = clr6 },
      NotifyINFOTitle = { fg = clr6 },
      NotifyTRACEBorder = { fg = clr2 },
      NotifyTRACEIcon = { fg = clr2 },
      NotifyTRACETitle = { fg = clr2 },
      NotifyWARNBorder = { fg = clr3 },
      NotifyWARNIcon = { fg = clr3 },
      NotifyWARNTitle = { fg = clr3 },


      TSRainbowRed = { fg = clr7 },
      TSRainbowOrange = { fg = clr4 },
      TSRainbowYellow = { fg = clr6 },
      TSRainbowGreen = { fg = clr2 },
      TSRainbowBlue = { fg = clr3 },
      TSRainbowViolet = { fg = clr5 },
      TSRainbowCyan = { fg = clr1 },
   }

   local terminal_groups = {
      bg0,
      clr6,
      clr2,
      clr3,
      clr4,
      clr5,
      clr7,
      fg3,
      fg4,
      clr6,
      clr2,
      clr3,
      clr4,
      clr5,
      clr7,
      fg1,
   }

   local fixed_groups = {}

   for key, info in pairs(groups) do
      fixed_groups[key] = {
         fg = info.fg and color_util.hsv_to_hex(info.fg) or nil,
         bg = info.bg and color_util.hsv_to_hex(info.bg) or nil,
         sp = info.sp and color_util.hsv_to_hex(info.sp) or nil,
         underline = info.underline,
         italic = info.italic,
         reverse = info.reverse,
         bold = info.bold,
         strikethrough = info.strikethrough,
         link = info.link,
         undercurl = info.undercurl,
      }
   end

   for key, value in pairs(config.overrides) do
      fixed_groups[key] = value
   end

   local fixed_terminal_groups = {}

   for _, value in ipairs(terminal_groups) do
      table.insert(fixed_terminal_groups, color_util.hsv_to_hex(value))
   end

   return fixed_groups, fixed_terminal_groups
end

class.setup(GroupsProvider, "GroupsProvider")
return GroupsProvider
