local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    -- Semantic token types
    ["@lsp.type.namespace"]    = { fg = D.namespace_green },
    ["@lsp.type.type"]         = { fg = P.green },
    ["@lsp.type.class"]        = { fg = P.green },
    ["@lsp.type.interface"]    = { fg = P.green, italic = true },
    ["@lsp.type.struct"]       = { fg = P.green },
    ["@lsp.type.enum"]         = { fg = P.bright_magenta },
    ["@lsp.type.enumMember"]   = { fg = P.bright_magenta },
    ["@lsp.type.function"]     = { fg = P.yellow },
    ["@lsp.type.method"]       = { fg = P.yellow },
    ["@lsp.type.parameter"]    = { fg = D.param_blue },
    ["@lsp.type.variable"]     = { fg = P.fg },
    ["@lsp.type.property"]     = { fg = P.fg, italic = true },
    ["@lsp.type.macro"]        = { fg = P.red },
    ["@lsp.type.decorator"]    = { fg = P.bright_yellow },
    ["@lsp.type.keyword"]      = { fg = P.magenta },
    ["@lsp.type.operator"]     = { fg = D.operator_purple },
    ["@lsp.type.string"]       = { fg = P.orange },
    ["@lsp.type.number"]       = { fg = P.bright_magenta },
    ["@lsp.type.comment"]      = { fg = D.ui_muted, italic = true },

    -- Semantic token modifiers
    ["@lsp.mod.abstract"]      = { italic = true },

    -- Combined type + modifier (abstract class/interface)
    ["@lsp.typemod.class.abstract"]     = { fg = P.green, italic = true },
    ["@lsp.typemod.interface.abstract"] = { fg = P.green, italic = true },

    -- LSP UI elements
    LspInlayHint              = { fg = D.ui_muted, bg = P.bg, italic = true },
    LspSignatureActiveParameter = { fg = P.fg, bold = true },
    LspReferenceText          = { bg = D.ui_surface },
    LspReferenceRead          = { bg = D.ui_surface },
    LspReferenceWrite         = { bg = D.ui_surface },
    LspCodeLens               = { fg = D.ui_muted, italic = true },
    LspCodeLensSeparator      = { fg = P.bright_black },
    LspInfoBorder             = { fg = D.ui_border, bg = D.ui_surface },
  }
end
