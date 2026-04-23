# Tepidarium Colorscheme Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the tepidarium.nvim colorscheme with proper treesitter support, semantic tokens, language-specific overrides (Python/Java/C++/Rust), and plugin highlights (Telescope, yazi.nvim), using a derived palette architecture for easy color tuning.

**Architecture:** Base palette from kitty.conf → derived palette computed via color_helper utilities → grouped highlight modules (editor, syntax, diagnostics, lsp, treesitter) → language-specific overrides → plugin highlights. All loaded by init.lua in order, later groups override earlier ones.

**Tech Stack:** Neovim 0.12.1, Lua, nvim_set_hl API, treesitter highlight captures, LSP semantic tokens

**Spec:** `docs/superpowers/specs/2026-04-23-tepidarium-colorscheme-design.md`

---

### Task 1: Fix color_helper.lua

Fix the broken import and clean up redundant code.

**Files:**
- Modify: `lua/tepidarium/color_helper.lua`

- [ ] **Step 1: Fix the broken palette import**

In `lua/tepidarium/color_helper.lua`, replace the broken reference on line 12:

```lua
-- Change this:
local palette = require("tepidarium.colorscheme.palette")
return palette.background

-- To this:
local palette = require("tepidarium.palette")
return palette.bg
```

The full updated `get_blend_background` function:

```lua
local function get_blend_background(background)
  if background ~= nil and background ~= "NONE" then
    return background
  end
  local palette = require("tepidarium.palette")
  return palette.bg
end
```

- [ ] **Step 2: Add a `darken` convenience function**

Add after the existing `lighten` function (after line 58):

```lua
---@param hex HexColor | "NONE"
---@param amt number
function M.darken(hex, amt)
  return M.lighten(hex, -amt)
end
```

- [ ] **Step 3: Add a `midpoint` function for blending two colors**

Add after the `darken` function:

```lua
---@param hex1 HexColor
---@param hex2 HexColor
---@param ratio? number -- 0.0 = hex1, 1.0 = hex2, default 0.5
function M.midpoint(hex1, hex2, ratio)
  ratio = ratio or 0.5
  local rgb1 = hex_to_rgb(hex1)
  local rgb2 = hex_to_rgb(hex2)
  return rgb_to_hex({
    r = math.floor(rgb1.r + (rgb2.r - rgb1.r) * ratio),
    g = math.floor(rgb1.g + (rgb2.g - rgb1.g) * ratio),
    b = math.floor(rgb1.b + (rgb2.b - rgb1.b) * ratio),
  })
end
```

- [ ] **Step 4: Verify the module loads without error**

Run: `nvim --headless -c "lua print(vim.inspect(require('tepidarium.color_helper')))" -c "q" 2>&1`

Expected: Table with `lighten`, `darken`, `midpoint`, `rgba`, `blend`, `extend_hex` keys printed, no errors.

- [ ] **Step 5: Commit**

```bash
git add lua/tepidarium/color_helper.lua
git commit -m "fix: repair color_helper imports and add darken/midpoint utilities"
```

---

### Task 2: Rebuild palette.lua from kitty source of truth

Replace all hex values with kitty.conf values and keep orange/purple extras.

**Files:**
- Modify: `lua/tepidarium/palette.lua`

- [ ] **Step 1: Rewrite palette.lua**

Replace the entire contents of `lua/tepidarium/palette.lua` with:

```lua
local P = {
  bg             = "#191311",
  fg             = "#eaddcb",
  black          = "#191311",
  bright_black   = "#3b322f",
  red            = "#c63d3b",
  bright_red     = "#f87775",
  green          = "#72b134",
  bright_green   = "#b4e981",
  yellow         = "#d5c63b",
  bright_yellow  = "#fff28c",
  blue           = "#3c72c5",
  bright_blue    = "#99bef9",
  magenta        = "#c751b0",
  bright_magenta = "#faa8ea",
  cyan           = "#34b0b1",
  bright_cyan    = "#a5eff0",
  white          = "#ededed",
  orange         = "#cc8137",
  purple         = "#9f55c2",
}

return P
```

- [ ] **Step 2: Verify the module loads**

Run: `nvim --headless -c "lua local P = require('tepidarium.palette'); print(P.bg, P.fg, P.orange)" -c "q" 2>&1`

Expected: `#191311	#eaddcb	#cc8137`

- [ ] **Step 3: Commit**

```bash
git add lua/tepidarium/palette.lua
git commit -m "fix: rebuild palette from kitty.conf source of truth"
```

---

### Task 3: Create palette_derived.lua

Computed shades using color_helper functions, derived from the base palette.

**Files:**
- Create: `lua/tepidarium/palette_derived.lua`

- [ ] **Step 1: Create palette_derived.lua**

Create `lua/tepidarium/palette_derived.lua`:

```lua
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
```

- [ ] **Step 2: Verify derived values compute without error**

Run: `nvim --headless -c "lua local D = require('tepidarium.palette_derived'); for k,v in pairs(D) do print(k, v) end" -c "q" 2>&1`

Expected: Seven key-value pairs printed, all hex color strings starting with `#`, no errors.

- [ ] **Step 3: Commit**

```bash
git add lua/tepidarium/palette_derived.lua
git commit -m "feat: add derived palette with computed semantic shades"
```

---

### Task 4: Create groups/editor.lua

Neovim built-in editor highlights — UI chrome, cursor, selections, pmenu, floats.

**Files:**
- Create: `lua/tepidarium/groups/editor.lua`
- Delete (later, in Task 12): `lua/tepidarium/editor.lua`

- [ ] **Step 1: Create the groups directory**

Run: `mkdir -p lua/tepidarium/groups`

- [ ] **Step 2: Create groups/editor.lua**

Create `lua/tepidarium/groups/editor.lua`:

```lua
local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    Normal       = { fg = P.fg, bg = P.bg },
    NormalNC     = { fg = D.ui_muted, bg = P.bg },
    NormalFloat  = { fg = P.fg, bg = D.ui_surface },
    FloatBorder  = { fg = D.ui_border, bg = D.ui_surface },
    FloatTitle   = { fg = P.fg, bg = D.ui_surface, bold = true },
    Comment      = { fg = D.ui_muted, italic = true },
    CursorLine   = { bg = P.bg },
    CursorLineNr = { fg = P.yellow, bold = true },
    LineNr       = { fg = D.ui_muted },
    Visual       = { bg = P.bright_black },
    Search       = { reverse = true },
    IncSearch    = { reverse = true },
    CurSearch    = { reverse = true },
    MatchParen   = { fg = P.cyan, bold = true },
    Pmenu        = { fg = P.fg, bg = D.ui_surface },
    PmenuSel     = { fg = P.fg, bg = P.blue, bold = true },
    PmenuSbar    = { bg = D.ui_surface },
    PmenuThumb   = { bg = D.ui_border },
    StatusLine   = { fg = P.fg, bg = P.bg },
    StatusLineNC = { fg = D.ui_muted, bg = P.bg },
    WinSeparator = { fg = D.ui_border },
    VertSplit    = { fg = D.ui_border },
    Title        = { fg = P.blue, bold = true },
    Directory    = { fg = P.blue },
    ErrorMsg     = { fg = P.red, bold = true },
    WarningMsg   = { fg = P.yellow },
    MoreMsg      = { fg = P.green },
    Question     = { fg = P.green },
    NonText      = { fg = P.bright_black },
    Whitespace   = { fg = P.bright_black },
    SpecialKey   = { fg = P.bright_black },
    Folded       = { fg = D.ui_muted, bg = D.ui_surface },
    FoldColumn   = { fg = D.ui_muted, bg = P.bg },
    SignColumn    = { bg = P.bg },
    ColorColumn  = { bg = D.ui_surface },
    CursorColumn = { bg = D.ui_surface },
    WildMenu     = { fg = P.fg, bg = P.blue, bold = true },
    WinBar       = { fg = P.fg, bg = P.bg, bold = true },
    WinBarNC     = { fg = D.ui_muted, bg = P.bg },
    TabLine      = { fg = D.ui_muted, bg = P.bg },
    TabLineFill  = { bg = P.bg },
    TabLineSel   = { fg = P.fg, bg = D.ui_surface, bold = true },
    DiffAdd      = { fg = P.green },
    DiffChange   = { fg = P.yellow },
    DiffDelete   = { fg = P.red },
    DiffText     = { fg = P.yellow, bold = true },
    SpellBad     = { sp = P.red, undercurl = true },
    SpellCap     = { sp = P.yellow, undercurl = true },
    SpellRare    = { sp = P.cyan, undercurl = true },
    SpellLocal   = { sp = P.green, undercurl = true },
  }
end
```

- [ ] **Step 3: Verify the module loads**

Run: `nvim --headless -c "lua local g = require('tepidarium.groups.editor')(); print(g.Normal.fg, g.Normal.bg)" -c "q" 2>&1`

Expected: `#eaddcb	#191311`

- [ ] **Step 4: Commit**

```bash
git add lua/tepidarium/groups/editor.lua
git commit -m "feat: add groups/editor.lua with full editor highlights"
```

---

### Task 5: Create groups/syntax.lua

Vim legacy syntax groups — the base highlight groups that treesitter builds on.

**Files:**
- Create: `lua/tepidarium/groups/syntax.lua`
- Delete (later, in Task 12): `lua/tepidarium/syntax.lua`

- [ ] **Step 1: Create groups/syntax.lua**

Create `lua/tepidarium/groups/syntax.lua`:

```lua
local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    Comment      = { fg = D.ui_muted, italic = true },
    Constant     = { fg = P.bright_magenta },
    String       = { fg = P.orange },
    Character    = { fg = P.orange },
    Number       = { fg = P.bright_magenta },
    Boolean      = { fg = P.bright_magenta },
    Float        = { fg = P.bright_magenta },
    Identifier   = { fg = P.fg },
    Function     = { fg = P.yellow },
    Statement    = { fg = P.magenta },
    Conditional  = { fg = P.magenta },
    Repeat       = { fg = P.magenta },
    Label        = { fg = P.magenta },
    Operator     = { fg = D.operator_purple },
    Keyword      = { fg = P.magenta },
    Exception    = { fg = P.red },
    PreProc      = { fg = P.red },
    Include      = { fg = P.red },
    Define       = { fg = P.red },
    Macro        = { fg = P.red },
    PreCondit    = { fg = P.red },
    Type         = { fg = P.green },
    StorageClass = { fg = P.green },
    Structure    = { fg = P.green },
    Typedef      = { fg = P.green },
    Special      = { fg = P.purple },
    SpecialChar  = { fg = D.special_string },
    Delimiter    = { fg = P.fg },
    SpecialComment = { fg = D.ui_muted, italic = true },
    Underlined   = { underline = true },
    Bold         = { bold = true },
    Italic       = { italic = true },
    Error        = { fg = P.red },
    Todo         = { fg = P.orange, bg = P.bg, bold = true },
  }
end
```

- [ ] **Step 2: Verify the module loads**

Run: `nvim --headless -c "lua local g = require('tepidarium.groups.syntax')(); print(g.Function.fg, g.Operator.fg)" -c "q" 2>&1`

Expected: `#d5c63b` followed by the computed operator_purple hex value, no errors.

- [ ] **Step 3: Commit**

```bash
git add lua/tepidarium/groups/syntax.lua
git commit -m "feat: add groups/syntax.lua with legacy vim syntax highlights"
```

---

### Task 6: Create groups/diagnostics.lua

Diagnostic highlights — virtual text, underlines, signs.

**Files:**
- Create: `lua/tepidarium/groups/diagnostics.lua`

- [ ] **Step 1: Create groups/diagnostics.lua**

Create `lua/tepidarium/groups/diagnostics.lua`:

```lua
local P = require("tepidarium.palette")

return function()
  return {
    DiagnosticError = { fg = P.red },
    DiagnosticWarn  = { fg = P.yellow },
    DiagnosticInfo  = { fg = P.blue },
    DiagnosticHint  = { fg = P.cyan },
    DiagnosticOk    = { fg = P.green },

    DiagnosticVirtualTextError = { fg = P.red, bg = P.bg },
    DiagnosticVirtualTextWarn  = { fg = P.yellow, bg = P.bg },
    DiagnosticVirtualTextInfo  = { fg = P.blue, bg = P.bg },
    DiagnosticVirtualTextHint  = { fg = P.cyan, bg = P.bg },

    DiagnosticUnderlineError = { sp = P.red, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = P.yellow, undercurl = true },
    DiagnosticUnderlineInfo  = { sp = P.blue, undercurl = true },
    DiagnosticUnderlineHint  = { sp = P.cyan, undercurl = true },

    DiagnosticSignError = { fg = P.red },
    DiagnosticSignWarn  = { fg = P.yellow },
    DiagnosticSignInfo  = { fg = P.blue },
    DiagnosticSignHint  = { fg = P.cyan },

    DiagnosticFloatingError = { fg = P.red },
    DiagnosticFloatingWarn  = { fg = P.yellow },
    DiagnosticFloatingInfo  = { fg = P.blue },
    DiagnosticFloatingHint  = { fg = P.cyan },
  }
end
```

- [ ] **Step 2: Verify the module loads**

Run: `nvim --headless -c "lua local g = require('tepidarium.groups.diagnostics')(); print(g.DiagnosticError.fg)" -c "q" 2>&1`

Expected: `#c63d3b`

- [ ] **Step 3: Commit**

```bash
git add lua/tepidarium/groups/diagnostics.lua
git commit -m "feat: add groups/diagnostics.lua with diagnostic highlights"
```

---

### Task 7: Create groups/lsp.lua

LSP semantic tokens, inlay hints, code lens, references, and LSP UI chrome.

**Files:**
- Create: `lua/tepidarium/groups/lsp.lua`
- Delete (later, in Task 12): `lua/tepidarium/semantic_tokens.lua`

- [ ] **Step 1: Create groups/lsp.lua**

Create `lua/tepidarium/groups/lsp.lua`:

```lua
local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    -- Semantic token types
    ["@lsp.type.namespace"]    = { fg = D.namespace_green },
    ["@lsp.type.type"]         = { fg = P.green },
    ["@lsp.type.class"]        = { fg = P.green },
    ["@lsp.type.interface"]    = { fg = P.green, italic = true },
    ["@lsp.type.struct"]       = { fg = P.green },
    ["@lsp.type.enum"]         = { fg = P.bright_magenta },
    ["@lsp.type.enumMember"]   = { fg = P.bright_magenta },
    ["@lsp.type.function"]     = { fg = P.yellow },
    ["@lsp.type.method"]       = { fg = P.yellow },
    ["@lsp.type.parameter"]    = { fg = D.param_blue },
    ["@lsp.type.variable"]     = { fg = P.fg },
    ["@lsp.type.property"]     = { fg = P.fg, italic = true },
    ["@lsp.type.macro"]        = { fg = P.red },
    ["@lsp.type.decorator"]    = { fg = P.bright_yellow },
    ["@lsp.type.keyword"]      = { fg = P.magenta },
    ["@lsp.type.operator"]     = { fg = D.operator_purple },
    ["@lsp.type.string"]       = { fg = P.orange },
    ["@lsp.type.number"]       = { fg = P.bright_magenta },
    ["@lsp.type.comment"]      = { fg = D.ui_muted, italic = true },

    -- Semantic token modifiers
    ["@lsp.mod.abstract"]      = { italic = true },

    -- Combined type + modifier (abstract class/interface)
    ["@lsp.typemod.class.abstract"]     = { fg = P.green, italic = true },
    ["@lsp.typemod.interface.abstract"] = { fg = P.green, italic = true },

    -- LSP UI elements
    LspInlayHint              = { fg = D.ui_muted, bg = P.bg, italic = true },
    LspSignatureActiveParameter = { fg = P.fg, bold = true },
    LspReferenceText          = { bg = D.ui_surface },
    LspReferenceRead          = { bg = D.ui_surface },
    LspReferenceWrite         = { bg = D.ui_surface },
    LspCodeLens               = { fg = D.ui_muted, italic = true },
    LspCodeLensSeparator      = { fg = P.bright_black },
    LspInfoBorder             = { fg = D.ui_border, bg = D.ui_surface },
  }
end
```

- [ ] **Step 2: Verify the module loads**

Run: `nvim --headless -c "lua local g = require('tepidarium.groups.lsp')(); print(g['@lsp.type.function'].fg)" -c "q" 2>&1`

Expected: `#d5c63b`

- [ ] **Step 3: Commit**

```bash
git add lua/tepidarium/groups/lsp.lua
git commit -m "feat: add groups/lsp.lua with semantic tokens and LSP UI highlights"
```

---

### Task 8: Create groups/treesitter.lua

Shared treesitter captures that apply across all languages.

**Files:**
- Create: `lua/tepidarium/groups/treesitter.lua`
- Delete (later, in Task 12): `lua/tepidarium/plugins/treesitter.lua`

- [ ] **Step 1: Create groups/treesitter.lua**

Create `lua/tepidarium/groups/treesitter.lua`:

```lua
local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    -- Identifiers
    ["@variable"]              = { fg = P.fg },
    ["@variable.builtin"]      = { fg = D.param_blue },
    ["@variable.parameter"]    = { fg = D.param_blue },
    ["@variable.member"]       = { fg = P.fg, italic = true },

    -- Constants
    ["@constant"]              = { fg = P.bright_magenta },
    ["@constant.builtin"]      = { fg = P.bright_magenta },
    ["@constant.macro"]        = { fg = P.red },

    -- Modules / Namespaces
    ["@module"]                = { fg = D.namespace_green },

    -- Strings
    ["@string"]                = { fg = P.orange },
    ["@string.documentation"]  = { fg = P.orange },
    ["@string.escape"]         = { fg = D.special_string },
    ["@string.special"]        = { fg = D.special_string },
    ["@string.regexp"]         = { fg = D.special_string },

    -- Numbers
    ["@number"]                = { fg = P.bright_magenta },
    ["@number.float"]          = { fg = P.bright_magenta },
    ["@boolean"]               = { fg = P.bright_magenta },
    ["@character"]             = { fg = P.orange },
    ["@character.special"]     = { fg = D.special_string },

    -- Types
    ["@type"]                  = { fg = P.green },
    ["@type.builtin"]          = { fg = P.green },
    ["@type.definition"]       = { fg = P.green },
    ["@type.qualifier"]        = { fg = P.magenta },

    -- Functions
    ["@function"]              = { fg = P.yellow },
    ["@function.builtin"]      = { fg = P.yellow },
    ["@function.call"]         = { fg = P.yellow },
    ["@function.macro"]        = { fg = P.red },
    ["@function.method"]       = { fg = P.yellow },
    ["@function.method.call"]  = { fg = P.yellow },
    ["@constructor"]           = { fg = P.yellow },

    -- Keywords
    ["@keyword"]               = { fg = P.magenta },
    ["@keyword.conditional"]   = { fg = P.magenta },
    ["@keyword.repeat"]        = { fg = P.magenta },
    ["@keyword.return"]        = { fg = P.magenta },
    ["@keyword.exception"]     = { fg = P.red },
    ["@keyword.import"]        = { fg = P.red },
    ["@keyword.operator"]      = { fg = D.operator_purple },
    ["@keyword.function"]      = { fg = P.magenta },
    ["@keyword.storage"]       = { fg = P.green },
    ["@keyword.directive"]     = { fg = P.red },
    ["@keyword.modifier"]      = { fg = P.magenta },

    -- Operators / Punctuation
    ["@operator"]              = { fg = D.operator_purple },
    ["@punctuation.bracket"]   = { fg = P.fg },
    ["@punctuation.delimiter"] = { fg = P.fg },
    ["@punctuation.special"]   = { fg = D.special_string },

    -- Comments
    ["@comment"]               = { fg = D.ui_muted, italic = true },
    ["@comment.documentation"] = { fg = D.ui_muted, italic = true },
    ["@comment.error"]         = { fg = P.red, bold = true },
    ["@comment.warning"]       = { fg = P.yellow, bold = true },
    ["@comment.todo"]          = { fg = P.orange, bold = true },
    ["@comment.note"]          = { fg = P.blue, bold = true },

    -- Attributes / Annotations
    ["@attribute"]             = { fg = P.bright_yellow },
    ["@attribute.builtin"]     = { fg = P.bright_yellow },

    -- Tags (HTML/XML)
    ["@tag"]                   = { fg = P.red },
    ["@tag.attribute"]         = { fg = P.yellow },
    ["@tag.delimiter"]         = { fg = P.fg },

    -- Labels
    ["@label"]                 = { fg = P.cyan },

    -- Markup (markdown etc)
    ["@markup.heading"]        = { fg = P.blue, bold = true },
    ["@markup.strong"]         = { bold = true },
    ["@markup.italic"]         = { italic = true },
    ["@markup.strikethrough"]  = { strikethrough = true },
    ["@markup.underline"]      = { underline = true },
    ["@markup.link"]           = { fg = P.blue, underline = true },
    ["@markup.link.url"]       = { fg = P.cyan, underline = true },
    ["@markup.raw"]            = { fg = P.orange },
    ["@markup.list"]           = { fg = P.magenta },
    ["@markup.math"]           = { fg = P.bright_magenta },
  }
end
```

- [ ] **Step 2: Verify the module loads**

Run: `nvim --headless -c "lua local g = require('tepidarium.groups.treesitter')(); print(g['@variable'].fg, g['@function'].fg)" -c "q" 2>&1`

Expected: `#eaddcb	#d5c63b`

- [ ] **Step 3: Commit**

```bash
git add lua/tepidarium/groups/treesitter.lua
git commit -m "feat: add groups/treesitter.lua with shared treesitter captures"
```

---

### Task 9: Create language override files

Language-specific treesitter/semantic token overrides for Python, Java, C++, and Rust.

**Files:**
- Create: `lua/tepidarium/languages/python.lua`
- Create: `lua/tepidarium/languages/java.lua`
- Create: `lua/tepidarium/languages/cpp.lua`
- Create: `lua/tepidarium/languages/rust.lua`

- [ ] **Step 1: Create the languages directory**

Run: `mkdir -p lua/tepidarium/languages`

- [ ] **Step 2: Create languages/python.lua**

Create `lua/tepidarium/languages/python.lua`:

```lua
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
```

- [ ] **Step 3: Create languages/java.lua**

Create `lua/tepidarium/languages/java.lua`:

```lua
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
```

- [ ] **Step 4: Create languages/cpp.lua**

Create `lua/tepidarium/languages/cpp.lua`:

```lua
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
```

- [ ] **Step 5: Create languages/rust.lua**

Create `lua/tepidarium/languages/rust.lua`:

```lua
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
    ["@variable.member.rust"] = { fg = P.fg, italic = true },
  }
end
```

- [ ] **Step 6: Verify all language modules load**

Run: `nvim --headless -c "lua for _, l in ipairs({'python','java','cpp','rust'}) do local ok, g = pcall(require, 'tepidarium.languages.'..l); print(l, ok) end" -c "q" 2>&1`

Expected:
```
python	true
java	true
cpp	true
rust	true
```

- [ ] **Step 7: Commit**

```bash
git add lua/tepidarium/languages/
git commit -m "feat: add language-specific overrides for Python, Java, C++, Rust"
```

---

### Task 10: Update plugins/telescope.lua

Rewrite telescope highlights to match the monochrome + accent UI spec.

**Files:**
- Modify: `lua/tepidarium/plugins/telescope.lua`

- [ ] **Step 1: Rewrite plugins/telescope.lua**

Replace the entire contents of `lua/tepidarium/plugins/telescope.lua` with:

```lua
local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    TelescopeNormal         = { fg = D.ui_muted, bg = P.bg },
    TelescopePromptNormal   = { fg = P.fg, bg = D.ui_surface },
    TelescopePromptBorder   = { fg = D.ui_border, bg = D.ui_surface },
    TelescopePromptPrefix   = { fg = P.blue, bg = D.ui_surface },
    TelescopePromptTitle    = { fg = P.fg, bg = D.ui_surface, bold = true },
    TelescopeResultsNormal  = { fg = D.ui_muted, bg = P.bg },
    TelescopeResultsBorder  = { fg = D.ui_border, bg = P.bg },
    TelescopeResultsTitle   = { fg = P.fg, bold = true },
    TelescopePreviewNormal  = { fg = P.fg, bg = D.ui_surface },
    TelescopePreviewBorder  = { fg = D.ui_border, bg = D.ui_surface },
    TelescopePreviewTitle   = { fg = P.fg, bg = D.ui_surface, bold = true },
    TelescopeSelection      = { fg = P.fg, bg = D.ui_surface },
    TelescopeSelectionCaret = { fg = P.blue, bg = D.ui_surface },
    TelescopeMatching       = { reverse = true },
    TelescopeMultiSelection = { fg = P.cyan },
    TelescopeMultiIcon      = { fg = P.cyan },
  }
end
```

- [ ] **Step 2: Verify the module loads**

Run: `nvim --headless -c "lua local g = require('tepidarium.plugins.telescope')(); print(g.TelescopeMatching.reverse)" -c "q" 2>&1`

Expected: `true`

- [ ] **Step 3: Commit**

```bash
git add lua/tepidarium/plugins/telescope.lua
git commit -m "feat: rewrite telescope highlights with monochrome + accent UI"
```

---

### Task 11: Create plugins/yazi.lua

Highlights for mikavilpas/yazi.nvim.

**Files:**
- Create: `lua/tepidarium/plugins/yazi.lua`

- [ ] **Step 1: Create plugins/yazi.lua**

Create `lua/tepidarium/plugins/yazi.lua`:

```lua
local P = require("tepidarium.palette")
local D = require("tepidarium.palette_derived")

return function()
  return {
    YaziFloat        = { fg = P.fg, bg = D.ui_surface },
    YaziBorder       = { fg = D.ui_border, bg = D.ui_surface },
    YaziSelectedFile = { fg = P.blue },
  }
end
```

- [ ] **Step 2: Verify the module loads**

Run: `nvim --headless -c "lua local g = require('tepidarium.plugins.yazi')(); print(g.YaziFloat.bg)" -c "q" 2>&1`

Expected: The computed `ui_surface` hex value (a slightly lightened bg), no errors.

- [ ] **Step 3: Commit**

```bash
git add lua/tepidarium/plugins/yazi.lua
git commit -m "feat: add yazi.nvim plugin highlights"
```

---

### Task 12: Fix lualine theme and clean up old files

Fix the broken `P.background` reference in lualine, remove old files replaced by the new structure.

**Files:**
- Modify: `lua/tepidarium/lualine/themes/tepidarium.lua`
- Delete: `lua/tepidarium/editor.lua`
- Delete: `lua/tepidarium/syntax.lua`
- Delete: `lua/tepidarium/semantic_tokens.lua`
- Delete: `lua/tepidarium/plugins/treesitter.lua`

- [ ] **Step 1: Fix lualine theme**

In `lua/tepidarium/lualine/themes/tepidarium.lua`, replace every occurrence of `P.background` with `P.bg`:

Line 9: `bg = P.background,` → `bg = P.bg,`
Line 15: `bg = P.background,` → `bg = P.bg,`

- [ ] **Step 2: Verify lualine loads**

Run: `nvim --headless -c "lua local ok, m = pcall(require, 'tepidarium.lualine.themes.tepidarium'); print(ok, m.normal.c.bg)" -c "q" 2>&1`

Expected: `true	#191311`

- [ ] **Step 3: Remove old files**

Run:
```bash
git rm lua/tepidarium/editor.lua
git rm lua/tepidarium/syntax.lua
git rm lua/tepidarium/semantic_tokens.lua
git rm lua/tepidarium/plugins/treesitter.lua
```

- [ ] **Step 4: Commit**

```bash
git add lua/tepidarium/lualine/themes/tepidarium.lua
git commit -m "fix: repair lualine theme and remove old highlight files"
```

---

### Task 13: Rewrite init.lua with new load order

Replace the loader with the new module structure and load order.

**Files:**
- Modify: `lua/tepidarium/init.lua`

- [ ] **Step 1: Rewrite init.lua**

Replace the entire contents of `lua/tepidarium/init.lua` with:

```lua
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
```

- [ ] **Step 2: Verify the full colorscheme loads without error**

Run: `nvim --headless -c "colorscheme tepidarium" -c "lua print(vim.g.colors_name)" -c "q" 2>&1`

Expected: `tepidarium` printed, no errors.

- [ ] **Step 3: Verify a sampling of highlight groups are set correctly**

Run:
```bash
nvim --headless -c "colorscheme tepidarium" -c "lua local function hl(n) local h = vim.api.nvim_get_hl(0, {name=n}); print(n, string.format('#%06x', h.fg or 0), h.italic and 'italic' or '') end; hl('Normal'); hl('@function'); hl('@variable.parameter'); hl('@lsp.type.interface'); hl('@operator')" -c "q" 2>&1
```

Expected: Five lines printed with hex colors matching the spec — Normal with `#eaddcb`, @function with `#d5c63b`, @variable.parameter with the param_blue value, @lsp.type.interface with green + `italic`, @operator with operator_purple.

- [ ] **Step 4: Commit**

```bash
git add lua/tepidarium/init.lua
git commit -m "feat: rewrite init.lua with new grouped module load order"
```

---

### Task 14: End-to-end visual verification

Load the colorscheme in a real Neovim session and visually verify against the spec.

- [ ] **Step 1: Open a Python file**

Run: `nvim -c "colorscheme tepidarium" -c "e /tmp/test.py"` with sample code and verify:
- Functions are yellow, parameters have faint blue, strings are orange, f-string interpolation is reddish-orange, self is blue+italic, decorators are bright yellow, operators are purple.

- [ ] **Step 2: Open a Rust file**

Run: `nvim -c "colorscheme tepidarium" -c "e /tmp/test.rs"` and verify:
- Namespaces are darker green, types are green, lifetimes are cyan, macros are red, member variables are italic.

- [ ] **Step 3: Open Telescope**

Open Telescope and verify: monochrome results, elevated prompt/preview with subtle shading, match characters inverted, selection with brightened fg.

- [ ] **Step 4: Verify floating windows**

Trigger an LSP hover or diagnostic float and verify: slightly elevated bg (`ui_surface`), borders use `ui_border`.

- [ ] **Step 5: Note any adjustments needed**

If derived colors don't look right (contrast too low, perceived luminance off), tweak the derivation parameters in `palette_derived.lua` — the blend ratios, darken amounts, or midpoint ratios. No structural changes needed.

- [ ] **Step 6: Commit any final tweaks**

```bash
git add -A
git commit -m "fix: tune derived palette values after visual verification"
```
