local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    ["@namespace.cpp"]       = { fg = D.namespace_green },
    ["@type.qualifier.cpp"]  = { fg = P.magenta },
    ["@keyword.import.cpp"]  = { fg = P.red },
    ["@constant.macro.cpp"]  = { fg = P.red },
    ["@operator.cpp"]        = { fg = D.operator_purple },
    ["@variable.member.cpp"] = { fg = P.fg, italic = true },
  }
end
