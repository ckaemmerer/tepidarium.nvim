local function apply(groups)
  for name, spec in pairs(groups) do vim.api.nvim_set_hl(0, name, spec) end
end

local M = {}
function M.load()
  vim.o.termguicolors = true
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
  vim.g.colors_name = "tepidarium"

  apply(require("tepidarium.editor")())
  apply(require("tepidarium.semantic_tokens")())
  apply(require("tepidarium.plugins.treesitter")())
  apply(require("tepidarium.plugins.lsp")())
  apply(require("tepidarium.plugins.telescope")())
end

return M
