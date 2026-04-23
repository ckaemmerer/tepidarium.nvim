local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    -- Identifiers
    ["@variable"]              = { fg = P.fg },
    ["@variable.builtin"]      = { fg = D.param_blue },
    ["@variable.parameter"]    = { fg = D.param_blue },
    ["@variable.member"]       = { fg = P.fg, italic = true },

    -- Constants
    ["@constant"]              = { fg = P.bright_magenta },
    ["@constant.builtin"]      = { fg = P.bright_magenta },
    ["@constant.macro"]        = { fg = P.red },

    -- Modules / Namespaces
    ["@module"]                = { fg = D.namespace_green },

    -- Strings
    ["@string"]                = { fg = P.orange },
    ["@string.documentation"]  = { fg = P.orange },
    ["@string.escape"]         = { fg = D.special_string },
    ["@string.special"]        = { fg = D.special_string },
    ["@string.regexp"]         = { fg = D.special_string },

    -- Numbers
    ["@number"]                = { fg = P.bright_magenta },
    ["@number.float"]          = { fg = P.bright_magenta },
    ["@boolean"]               = { fg = P.bright_magenta },
    ["@character"]             = { fg = P.orange },
    ["@character.special"]     = { fg = D.special_string },

    -- Types
    ["@type"]                  = { fg = P.green },
    ["@type.builtin"]          = { fg = P.green },
    ["@type.definition"]       = { fg = P.green },
    ["@type.qualifier"]        = { fg = P.magenta },

    -- Functions
    ["@function"]              = { fg = P.yellow },
    ["@function.builtin"]      = { fg = P.yellow },
    ["@function.call"]         = { fg = P.yellow },
    ["@function.macro"]        = { fg = P.red },
    ["@function.method"]       = { fg = P.yellow },
    ["@function.method.call"]  = { fg = P.yellow },
    ["@constructor"]           = { fg = P.yellow },

    -- Keywords
    ["@keyword"]               = { fg = P.magenta },
    ["@keyword.conditional"]   = { fg = P.magenta },
    ["@keyword.repeat"]        = { fg = P.magenta },
    ["@keyword.return"]        = { fg = P.magenta },
    ["@keyword.exception"]     = { fg = P.red },
    ["@keyword.import"]        = { fg = P.red },
    ["@keyword.operator"]      = { fg = D.operator_purple },
    ["@keyword.function"]      = { fg = P.magenta },
    ["@keyword.storage"]       = { fg = P.green },
    ["@keyword.directive"]     = { fg = P.red },
    ["@keyword.modifier"]      = { fg = P.magenta },

    -- Operators / Punctuation
    ["@operator"]              = { fg = D.operator_purple },
    ["@punctuation.bracket"]   = { fg = P.fg },
    ["@punctuation.delimiter"] = { fg = P.fg },
    ["@punctuation.special"]   = { fg = D.special_string },

    -- Comments
    ["@comment"]               = { fg = D.ui_muted, italic = true },
    ["@comment.documentation"] = { fg = D.ui_muted, italic = true },
    ["@comment.error"]         = { fg = P.red, bold = true },
    ["@comment.warning"]       = { fg = P.yellow, bold = true },
    ["@comment.todo"]          = { fg = P.orange, bold = true },
    ["@comment.note"]          = { fg = P.blue, bold = true },

    -- Attributes / Annotations
    ["@attribute"]             = { fg = P.bright_yellow },
    ["@attribute.builtin"]     = { fg = P.bright_yellow },

    -- Tags (HTML/XML)
    ["@tag"]                   = { fg = P.red },
    ["@tag.attribute"]         = { fg = P.yellow },
    ["@tag.delimiter"]         = { fg = P.fg },

    -- Labels
    ["@label"]                 = { fg = P.cyan },

    -- Markup (markdown etc)
    ["@markup.heading"]        = { fg = P.blue, bold = true },
    ["@markup.strong"]         = { bold = true },
    ["@markup.italic"]         = { italic = true },
    ["@markup.strikethrough"]  = { strikethrough = true },
    ["@markup.underline"]      = { underline = true },
    ["@markup.link"]           = { fg = P.blue, underline = true },
    ["@markup.link.url"]       = { fg = P.cyan, underline = true },
    ["@markup.raw"]            = { fg = P.orange },
    ["@markup.list"]           = { fg = P.magenta },
    ["@markup.math"]           = { fg = P.bright_magenta },
  }
end
