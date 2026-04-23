# Tepidarium Colorscheme Design Spec

## Overview

Tepidarium is a warm, dark Neovim colorscheme using soft/pastel colors at roughly equal perceived luminance. The design prioritizes readability while being easy on the eyes. The kitty terminal config (`ref_colors/kitty.conf`) is the single source of truth for base colors, supplemented by the Aether GTK override (`ref_colors/aether.override.css`).

## Architecture: Palette + Shade Generator + Grouped Highlights

### File Structure

```
lua/tepidarium/
├── init.lua                  # Loader — applies all highlight groups in order
├── palette.lua               # Base 16+2 colors (kitty source of truth)
├── palette_derived.lua       # Computed shades from base palette via color_helper
├── color_helper.lua          # Blend/lighten/darken utilities
├── groups/
│   ├── editor.lua            # Neovim built-in editor highlights
│   ├── syntax.lua            # Vim legacy syntax groups
│   ├── diagnostics.lua       # Diagnostic highlights, virtual text, underlines
│   ├── lsp.lua               # LSP semantic tokens, inlay hints, code lens
│   └── treesitter.lua        # Shared @-prefixed treesitter captures
├── languages/
│   ├── python.lua            # Python-specific overrides
│   ├── java.lua              # Java-specific overrides
│   ├── cpp.lua               # C++-specific overrides
│   └── rust.lua              # Rust-specific overrides
├── plugins/
│   ├── telescope.lua         # Telescope highlights
│   └── yazi.lua              # yazi.nvim (mikavilpas) highlights
└── lualine/
    └── themes/
        └── tepidarium.lua    # Lualine statusline theme
```

### Load Order

`init.lua` applies groups in this order: editor → syntax → diagnostics → lsp → treesitter → languages → plugins. Later groups override earlier ones, so language-specific files override shared treesitter defaults.

---

## Base Palette

Sourced directly from `ref_colors/kitty.conf`:

| Name           | Hex       | Kitty key       |
|----------------|-----------|-----------------|
| bg             | `#191311` | background      |
| fg             | `#eaddcb` | foreground      |
| black          | `#191311` | color0          |
| bright_black   | `#3b322f` | color8          |
| red            | `#c63d3b` | color1          |
| bright_red     | `#f87775` | color9          |
| green          | `#72b134` | color2          |
| bright_green   | `#b4e981` | color10         |
| yellow         | `#d5c63b` | color3          |
| bright_yellow  | `#fff28c` | color11         |
| blue           | `#3c72c5` | color4          |
| bright_blue    | `#99bef9` | color12         |
| magenta        | `#c751b0` | color5          |
| bright_magenta | `#faa8ea` | color13         |
| cyan           | `#34b0b1` | color6          |
| bright_cyan    | `#a5eff0` | color14         |
| white          | `#ededed` | color15         |
| orange         | `#cc8137` | — (extra, not in kitty) |
| purple         | `#9f55c2` | — (extra, not in kitty) |

Orange and purple are additional base colors not part of the terminal 16 but core to the semantic mapping (strings = orange, operators = purple). Their values are carried over from the original palette draft.

---

## Derived Palette

Computed from base colors using `color_helper.lua`. All derived colors are generated at load time so that changing a base color automatically propagates.

| Semantic name      | Derivation                                  | Used for                        |
|--------------------|---------------------------------------------|---------------------------------|
| `namespace_green`  | Darken green ~15-20%                        | Namespace highlights            |
| `param_blue`       | Blend bright_blue at ~25% alpha over fg     | Function parameters             |
| `operator_purple`  | Blend magenta + blue midpoint               | Intrinsic operators             |
| `special_string`   | Shift orange toward red                     | Escape sequences, interpolation |
| `ui_surface`       | Lighten bg by ~8-10                         | Floating windows, popups        |
| `ui_border`        | Lighten bg by ~15                           | Borders, separators             |
| `ui_muted`         | Blend fg at ~40% alpha over bg              | Deemphasized text               |

---

## Semantic Color Mapping

### Code Elements

| Element                    | Color              | Style  | Notes                                  |
|----------------------------|--------------------|--------|----------------------------------------|
| Namespaces/modules         | `namespace_green`  | normal | Darker than class green                |
| Classes/types              | `green`            | normal | Base green                             |
| Abstract classes/interfaces| `green`            | italic | Same color, italic distinguishes       |
| Functions/methods          | `yellow`           | normal | Base yellow                            |
| Function parameters        | `param_blue`       | normal | Faint blue tint over fg                |
| Local variables            | `fg`               | normal | Default foreground                     |
| Member variables/fields    | `fg`               | italic | Italic distinguishes from locals       |
| Keywords/control flow      | `magenta`          | normal | if/else/for/match/etc.                 |
| Intrinsic operators        | `operator_purple`  | normal | +, -, =, ->, etc.                      |
| Numbers/numeric literals   | `bright_magenta`   | normal | Light magentaish                       |
| Constants/enums            | `bright_magenta`   | normal | Same as numbers                        |
| Strings                    | `orange`           | normal | Orangeish                              |
| Special strings/escapes    | `special_string`   | normal | Reddish orange                         |
| Comments                   | `ui_muted`         | italic | Deemphasized                           |
| Decorators/annotations     | `bright_yellow`    | normal | @decorator, @Override                  |
| Preprocessor/macros        | `red`              | normal | #include, macro_rules!                 |

### Text Styling Rules

Minimal styling overall:
- **Italic**: comments, abstract/interface classes, member variables
- **Bold**: only for search matches, cursor line number, selected menu items
- **Undercurl**: diagnostic underlines only

---

## UI Elements (Monochrome + Accents)

The UI follows a monochrome palette with color accents reserved for semantically important elements (diagnostics, selections, matches).

| Element                | fg          | bg           | Notes                              |
|------------------------|-------------|--------------|------------------------------------|
| Normal editor          | `fg`        | `bg`         | Matches kitty fg/bg                |
| Floating windows/popups| `fg`        | `ui_surface`  | Subtle elevation                   |
| Borders                | `ui_border` | —            |                                    |
| Inactive/unfocused text| `ui_muted`  | `bg`         |                                    |
| Selection/visual       | `fg`        | `bright_black`|                                   |
| Search match           | —           | —            | `reverse = true` (Neovim inverts fg/bg) |
| IncSearch              | —           | —            | `reverse = true` (Neovim inverts fg/bg) |
| Pmenu                  | `fg`        | `ui_surface`  | Elevated                           |
| PmenuSel               | `fg` (bright) | `blue`    | Brightened text on blue accent bg  |
| Cursor line            | —           | `bg`         | Minimal, only line number accented |
| Line numbers           | `ui_muted`  | —            |                                    |
| Cursor line number     | `yellow`    | —            | Bold                               |
| Diagnostic error       | `red`       | —            | Accent                             |
| Diagnostic warning     | `yellow`    | —            | Accent                             |
| Diagnostic info        | `blue`      | —            | Accent                             |
| Diagnostic hint        | `cyan`      | —            | Accent                             |

---

## Plugin Highlights

### Telescope

| Group                  | fg          | bg           | Notes                    |
|------------------------|-------------|--------------|--------------------------|
| TelescopeNormal        | `ui_muted`  | `bg`         | Monochrome base          |
| TelescopePromptNormal  | `fg`        | `ui_surface`  | Elevated prompt area     |
| TelescopePromptBorder  | `ui_border` | `ui_surface`  | Matches prompt bg        |
| TelescopePromptPrefix  | `blue`      | `ui_surface`  | Accent prefix icon       |
| TelescopeResultsNormal | `ui_muted`  | `bg`         | Muted until matched      |
| TelescopeResultsBorder | `ui_border` | `bg`         |                          |
| TelescopePreviewNormal | `fg`        | `ui_surface`  | Elevated preview pane    |
| TelescopePreviewBorder | `ui_border` | `ui_surface`  |                          |
| TelescopeSelection     | `fg`        | `ui_surface`  | Brightened fg            |
| TelescopeSelectionCaret| `blue`      | `ui_surface`  | Accent caret             |
| TelescopeMatching      | —           | —            | `reverse = true`         |
| TelescopeTitle         | `fg`        | —            | Bold                     |

### yazi.nvim (mikavilpas)

| Group            | fg          | bg           | Notes                  |
|------------------|-------------|--------------|------------------------|
| YaziFloat        | `fg`        | `ui_surface`  | Main floating window   |
| YaziBorder       | `ui_border` | `ui_surface`  | Border matches float   |
| YaziSelectedFile | `blue`      | —            | Accent for selected    |

### Built-in LSP Floating Windows

| Group          | fg          | bg           | Notes                |
|----------------|-------------|--------------|----------------------|
| NormalFloat    | `fg`        | `ui_surface`  | All floating windows |
| FloatBorder    | `ui_border` | `ui_surface`  | Consistent borders   |
| FloatTitle     | `fg`        | `ui_surface`  | Bold                 |
| LspInfoBorder  | `ui_border` | `ui_surface`  | :LspInfo window      |

---

## Language-Specific Overrides

Each language file only defines overrides where treesitter captures or semantic tokens diverge from the shared defaults. Everything else inherits from `groups/treesitter.lua`.

### Python

| Capture / Token                | Color            | Style  | Notes                    |
|--------------------------------|------------------|--------|--------------------------|
| `@string.special.python`       | `special_string` | normal | f-strings, format specs  |
| `@attribute.python`            | `bright_yellow`  | normal | Decorators               |
| `@type.builtin.python`         | `green`          | normal | int, str, list, dict     |
| `@variable.builtin.python` (self) | `param_blue`  | italic | self references          |
| `@constructor.python`          | `yellow`         | normal | __init__                 |

### Java

| Capture / Token                | Color            | Style  | Notes                    |
|--------------------------------|------------------|--------|--------------------------|
| `@type.qualifier.java`         | `green`          | italic | abstract, interface kw   |
| `@attribute.java`              | `bright_yellow`  | normal | @Override etc.           |
| Semantic: abstract type modifier | `green`        | italic | Abstract classes         |
| `@constant.java`               | `bright_magenta` | normal | static final fields      |

### C++

| Capture / Token                | Color              | Style  | Notes                  |
|--------------------------------|--------------------|--------|------------------------|
| `@namespace.cpp`               | `namespace_green`  | normal | Namespaces             |
| `@type.qualifier.cpp`          | `magenta`          | normal | const, volatile        |
| `@keyword.import.cpp`          | `red`              | normal | #include               |
| `@constant.macro.cpp`          | `red`              | normal | Preprocessor defines   |
| `@operator.cpp`                | `operator_purple`  | normal | ::, ->, <<             |
| `@variable.member.cpp`         | `fg`               | italic | Member variables       |

### Rust

| Capture / Token                | Color              | Style  | Notes                  |
|--------------------------------|--------------------|--------|------------------------|
| `@namespace.rust`              | `namespace_green`  | normal | mod, crate paths       |
| `@type.qualifier.rust`         | `magenta`          | normal | mut, pub, unsafe       |
| `@attribute.rust`              | `bright_yellow`    | normal | #[derive], #[cfg]      |
| `@function.macro.rust`         | `red`              | normal | println!, vec!         |
| `@string.special.rust`         | `special_string`   | normal | Format args            |
| `@lifetime.rust` / `@label.rust` | `cyan`           | normal | Lifetimes              |
| `@variable.member.rust`        | `fg`               | italic | Member variables       |

---

## Fixes to Existing Code

These bugs in the draft will be resolved as part of implementation:

1. **`color_helper.lua`**: References `tepidarium.colorscheme.palette` (nonexistent) — fix to `tepidarium.palette`
2. **`lualine/themes/tepidarium.lua`**: References `P.background` — fix to `P.bg`
3. **`syntax.lua`**: References `P.background` in Todo group — fix to `P.bg`
4. **`init.lua`**: Requires `tepidarium.plugins.lsp` which doesn't exist — will be replaced by new load order
5. **`syntax.lua`**: Not loaded by `init.lua` — will be loaded in the new structure
6. **`palette.lua`**: Hex values don't match kitty — rebuild from kitty source of truth

---

## Design Principles

- **Warm and soft**: All colors should feel warm and pastel, avoiding harsh neon tones
- **Equal perceived luminance**: Colors at the same semantic level should have roughly equal brightness
- **Minimum contrast**: Ensure readability — no color pairing should fall below WCAG AA contrast for its context
- **Monochrome UI**: Reserve color for semantically meaningful elements only
- **Computed derivation**: All non-base colors are derived from the base palette, so palette tweaks propagate automatically
- **Minimal styling**: Bold and italic used sparingly and with clear semantic meaning
