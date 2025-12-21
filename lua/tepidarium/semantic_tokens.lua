local P = require("tepidarium.palette")

return function()
  return {
    -- LSP diagnostics virtual text
    DiagnosticVirtualTextError = { bg = P.bg, fg = P.red },
    DiagnosticVirtualTextWarn  = { bg = P.bg, fg = P.yellow },
    DiagnosticVirtualTextInfo  = { bg = P.bg, fg = P.blue },
    DiagnosticVirtualTextHint  = { bg = P.bg, fg = P.cyan },

    -- Underlines
    DiagnosticUnderlineError = { sp = P.red, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = P.yellow, undercurl = true },
    DiagnosticUnderlineInfo  = { sp = P.blue, undercurl = true },
    DiagnosticUnderlineHint  = { sp = P.cyan, undercurl = true },

    -- LSP semantic tokens (fallbacks)
    LspInlayHint     = { fg = P.white, bg = P.bg, italic = true },
    LspSignatureActiveParameter = { bg = P.white, bold = true },

    -- References
    LspReferenceText  = { fg = P.white },
    LspReferenceRead  = { fg = P.white },
    LspReferenceWrite = { fg = P.white },

    -- Progress
    LspCodeLens       = { fg = P.white, italic = true },
    LspCodeLensSeparator = { fg = P.bright_black },
  }
end
