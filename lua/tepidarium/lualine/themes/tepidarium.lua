local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

local M = {}

M.normal = {
  a = { bg = P.blue, fg = P.bg },
  b = { bg = P.bright_black, fg = P.blue },
  c = { bg = P.bg, fg = D.ui_muted },
  x = { bg = P.bg, fg = D.ui_muted },
}

M.insert = {
  a = { bg = P.green, fg = P.bg },
  b = { bg = P.bright_black, fg = P.green },
}

M.command = {
  a = { bg = P.yellow, fg = P.bg },
  b = { bg = P.bright_black, fg = P.yellow },
}

M.visual = {
  a = { bg = P.magenta, fg = P.bg },
  b = { bg = P.bright_black, fg = P.magenta },
}

M.replace = {
  a = { bg = P.red, fg = P.bg },
  b = { bg = P.bright_black, fg = P.red },
}

M.inactive = {
  a = { bg = P.bright_black, fg = D.ui_muted },
  b = { bg = P.bg, fg = P.bright_black },
}

return M
