local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    TelescopeNormal         = { fg = D.ui_muted, bg = P.bg },
    TelescopePromptNormal   = { fg = P.fg, bg = D.ui_surface },
    TelescopePromptBorder   = { fg = D.ui_border, bg = D.ui_surface },
    TelescopePromptPrefix   = { fg = P.blue, bg = D.ui_surface },
    TelescopeTitle          = { fg = P.fg, bold = true },
    TelescopePromptTitle    = { fg = P.fg, bg = D.ui_surface, bold = true },
    TelescopeResultsNormal  = { fg = D.ui_muted, bg = P.bg },
    TelescopeResultsBorder  = { fg = D.ui_border, bg = P.bg },
    TelescopeResultsTitle   = { fg = P.fg, bold = true },
    TelescopePreviewNormal  = { fg = P.fg, bg = D.ui_surface },
    TelescopePreviewBorder  = { fg = D.ui_border, bg = D.ui_surface },
    TelescopePreviewTitle   = { fg = P.fg, bg = D.ui_surface, bold = true },
    TelescopeSelection      = { fg = P.fg, bg = D.ui_surface },
    TelescopeSelectionCaret = { fg = P.blue, bg = D.ui_surface },
    TelescopeMatching       = { reverse = true },
    TelescopeMultiSelection = { fg = P.cyan },
    TelescopeMultiIcon      = { fg = P.cyan },
  }
end
