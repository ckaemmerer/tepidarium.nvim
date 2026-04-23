local P = require("tepidarium.palette")

return function()
  return {
    ["@type.qualifier.java"]               = { fg = P.green, italic = true },
    ["@attribute.java"]                    = { fg = P.bright_yellow },
    ["@constant.java"]                     = { fg = P.bright_magenta },
    ["@lsp.typemod.class.abstract.java"]   = { fg = P.green, italic = true },
    javaAnnotation                         = { fg = P.bright_yellow },
  }
end
