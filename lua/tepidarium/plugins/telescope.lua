local P = require("tepidarium.palette")

return function()
  return {
    FloatBorder             = { fg = P.bright_black, bg = P.bg },
    TelescopeBorder         = { fg = P.bright_black, bg = P.bg },
    TelescopePromptBorder   = { fg = P.bright_black, bg = P.bg },
    TelescopeResultsBorder  = { fg = P.bright_black, bg = P.bg },
    TelescopePreviewBorder  = { fg = P.bright_black, bg = P.bg },
    TelescopeNormal         = { fg = P.white, bg = P.bg },
    TelescopePromptNormal   = { fg = P.bright_white, bg = P.bg },
    TelescopeResultsNormal  = { fg = P.white, bg = P.bg },
    TelescopePreviewNormal  = { fg = P.bright_white, bg = P.bg },
    TelescopeSelection      = { fg = P.bright_white, bg = P.bright_black, bold = true },
    TelescopeSelectionCaret = { fg = P.blue, bg = P.bright_black },
    TelescopeMatching       = { fg = P.red, bold = true },  }
end
