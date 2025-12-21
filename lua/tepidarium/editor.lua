local P = require("tepidarium.palette")

return function()
  return {
    Normal        = { fg = P.fg, bg = P.bg },
    NormalNC      = { fg = P.bright_black, bg = P.bg },
    Comment       = { fg = P.white, italic = true },
    CursorLine    = { bg = P.bg },
    CursorLineNr  = { fg = P.yellow, bold = true },
    LineNr        = { fg = P.white },
    Visual        = { bg = P.bright_black },
    Search        = { bg = P.yellow, fg = P.bg },
    IncSearch     = { bg = P.orange, fg = P.bg },
    MatchParen    = { fg = P.cyan, bold = true },
    Pmenu         = { bg = P.bright_black, fg = P.fg },
    PmenuSel      = { bg = P.blue, fg = P.bg, bold = true },
    StatusLine    = { bg = P.bg, fg = P.fg },
    StatusLineNC  = { bg = P.bg, fg = P.white },
    VertSplit     = { fg = P.bright_black },
    Title         = { fg = P.blue, bold = true },
    Directory     = { fg = P.blue },
    ErrorMsg      = { fg = P.red, bold = true },
    WarningMsg    = { fg = P.orange },
    MoreMsg       = { fg = P.green },
    NonText       = { fg = P.bright_black },
    Whitespace    = { fg = P.bright_black },
    DiagnosticError = { fg = P.red },
    DiagnosticWarn  = { fg = P.orange },
    DiagnosticInfo  = { fg = P.blue },
    DiagnosticHint  = { fg = P.cyan },
    DiagnosticOk    = { fg = P.green },
  }
end
