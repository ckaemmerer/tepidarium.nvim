local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    ["@namespace.rust"]       = { fg = D.namespace_green },
    ["@type.qualifier.rust"]  = { fg = P.magenta },
    ["@attribute.rust"]       = { fg = P.bright_yellow },
    ["@function.macro.rust"]  = { fg = P.red },
    ["@string.special.rust"]  = { fg = D.special_string },
    ["@label.rust"]           = { fg = P.cyan },
    ["@lifetime.rust"]        = { fg = P.cyan },
    ["@variable.member.rust"] = { fg = P.fg, italic = true },
  }
end
