local P = require("tepidarium.palette")

return function()
  return {
    DiagnosticError = { fg = P.red },
    DiagnosticWarn  = { fg = P.yellow },
    DiagnosticInfo  = { fg = P.blue },
    DiagnosticHint  = { fg = P.cyan },
    DiagnosticOk    = { fg = P.green },

    DiagnosticVirtualTextError = { fg = P.red, bg = P.bg },
    DiagnosticVirtualTextWarn  = { fg = P.yellow, bg = P.bg },
    DiagnosticVirtualTextInfo  = { fg = P.blue, bg = P.bg },
    DiagnosticVirtualTextHint  = { fg = P.cyan, bg = P.bg },

    DiagnosticUnderlineError = { sp = P.red, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = P.yellow, undercurl = true },
    DiagnosticUnderlineInfo  = { sp = P.blue, undercurl = true },
    DiagnosticUnderlineHint  = { sp = P.cyan, undercurl = true },

    DiagnosticSignError = { fg = P.red },
    DiagnosticSignWarn  = { fg = P.yellow },
    DiagnosticSignInfo  = { fg = P.blue },
    DiagnosticSignHint  = { fg = P.cyan },

    DiagnosticFloatingError = { fg = P.red },
    DiagnosticFloatingWarn  = { fg = P.yellow },
    DiagnosticFloatingInfo  = { fg = P.blue },
    DiagnosticFloatingHint  = { fg = P.cyan },
  }
end
