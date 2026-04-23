local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    ["@string.special.python"]    = { fg = D.special_string },
    ["@attribute.python"]         = { fg = P.bright_yellow },
    ["@type.builtin.python"]      = { fg = P.green },
    ["@variable.builtin.python"]  = { fg = D.param_blue, italic = true },
    ["@constructor.python"]       = { fg = P.yellow },
  }
end
