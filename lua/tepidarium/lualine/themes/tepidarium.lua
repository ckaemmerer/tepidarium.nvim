local P = require("tepidarium.palette")

local M = {}

M.normal = {
  a = { bg = P.blue, fg = P.black },
  b = { bg = P.black, fg = P.blue },
  c = {
    bg = P.bg,
    fg = P.ui_muted,
  },
  x = {
    bg = P.bg,
    fg = P.ui_muted,
  },
}

M.insert = {
  a = { bg = P.green, fg = P.black },
  b = { bg = P.black, fg = P.green },
}

M.command = {
  a = { bg = P.yellow, fg = P.black },
  b = { bg = P.black, fg = P.yellow },
}

M.visual = {
  a = { bg = P.magenta, fg = P.black },
  b = { bg = P.black, fg = P.magenta },
}

M.replace = {
  a = { bg = P.red, fg = P.black },
  b = { bg = P.black, fg = P.red },
}

M.inactive = {
  a = { bg = P.black, fg = P.yellow },
  b = { bg = P.black, fg = P.black },
}

return M
