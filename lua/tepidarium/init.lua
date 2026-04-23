local function apply(groups)
  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end
end

local M = {}

function M.load()
  vim.o.termguicolors = true
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "tepidarium"

  -- Core groups (order matters: later overrides earlier)
  apply(require("tepidarium.groups.editor")())
  apply(require("tepidarium.groups.syntax")())
  apply(require("tepidarium.groups.diagnostics")())
  apply(require("tepidarium.groups.lsp")())
  apply(require("tepidarium.groups.treesitter")())

  -- Language-specific overrides
  apply(require("tepidarium.languages.python")())
  apply(require("tepidarium.languages.java")())
  apply(require("tepidarium.languages.cpp")())
  apply(require("tepidarium.languages.rust")())

  -- Plugin highlights
  apply(require("tepidarium.plugins.telescope")())
  apply(require("tepidarium.plugins.yazi")())
end

return M
