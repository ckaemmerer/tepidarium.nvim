local P = require("tepidarium.palette")
local H = require("tepidarium.color_helper")

local D = {
  namespace_green = H.darken(P.green, 35),
  param_blue      = H.blend(P.bright_blue, 0.25, P.fg),
  operator_purple = H.midpoint(P.magenta, P.blue),
  special_string  = H.midpoint(P.orange, P.red, 0.35),
  ui_surface      = H.lighten(P.bg, 8),
  ui_border       = H.lighten(P.bg, 15),
  ui_muted        = H.blend(P.fg, 0.40, P.bg),
}

return D
