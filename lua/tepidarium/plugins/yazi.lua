local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    YaziFloat        = { fg = P.fg, bg = D.ui_surface },
    YaziBorder       = { fg = D.ui_border, bg = D.ui_surface },
    YaziSelectedFile = { fg = P.blue },
  }
end
