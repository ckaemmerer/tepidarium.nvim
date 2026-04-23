---@class Helper
local M = {}


---@param background? HexColor | "NONE"
local function get_blend_background(background)
  if background ~= nil and background ~= "NONE" then
    return background
  end

  local palette = require("tepidarium.palette")
  return palette.bg
end

---@param hex HexColor
---@return RGB
local function hex_to_rgb(hex)
  if hex == nil then
    return { r = 0, g = 0, b = 0 }
  end
  hex = string.lower(hex)
  return {
    r = tonumber(hex:sub(2, 3), 16),
    g = tonumber(hex:sub(4, 5), 16),
    b = tonumber(hex:sub(6, 7), 16),
  }
end

---@param rgb RGB
---@return HexColor
local function rgb_to_hex(rgb)
  local red = string.format("%02x", rgb.r)
  local green = string.format("%02x", rgb.g)
  local blue = string.format("%02x", rgb.b)
  return "#" .. red .. green .. blue
end

---@param hex HexColor | "NONE"
---@param amt number
function M.lighten(hex, amt)
  -- stylua: ignore
  if hex == "NONE" then return hex end

  local rgb = hex_to_rgb(hex)
  -- over upper
  rgb.r = (rgb.r + amt > 255) and 255 or (rgb.r + amt)
  rgb.g = (rgb.g + amt > 255) and 255 or (rgb.g + amt)
  rgb.b = (rgb.b + amt > 255) and 255 or (rgb.b + amt)
  -- below bound
  rgb.r = (rgb.r < 0) and 0 or rgb.r
  rgb.g = (rgb.g < 0) and 0 or rgb.g
  rgb.b = (rgb.b < 0) and 0 or rgb.b
  -- rgb to hex
  local red = string.format("%02x", rgb.r)
  local green = string.format("%02x", rgb.g)
  local blue = string.format("%02x", rgb.b)
  return "#" .. red .. green .. blue
end

---@param hex HexColor | "NONE"
---@param amt number
function M.darken(hex, amt)
  return M.lighten(hex, -amt)
end

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

---@param alpha HexColorAlpha
---@param background HexColor
function M.rgba(red, green, blue, alpha, background)
  background = get_blend_background(background)
  local bg_rgb = hex_to_rgb(background)
  -- new color
  red = (1 - alpha) * bg_rgb.r + alpha * red
  green = (1 - alpha) * bg_rgb.g + alpha * green
  blue = (1 - alpha) * bg_rgb.b + alpha * blue
  return rgb_to_hex({ r = red, g = green, b = blue })
end

---@param hex HexColor | "NONE"
---@param alpha HexColorAlpha
---@param base? HexColor
function M.blend(hex, alpha, base)
  -- stylua: ignore
  if hex == "NONE" then return "NONE" end

  base = get_blend_background(base)
  local rgb = hex_to_rgb(hex)
  return M.rgba(rgb.r, rgb.g, rgb.b, alpha, base)
end

---@param hexColor HexColor
---@param base HexColor
function M.extend_hex(hexColor, base)
  base = get_blend_background(base)
  local hex6 = string.sub(hexColor, 1, 7)
  local alpha = tonumber(string.sub(hexColor, 8, 9), 16) / 255
  return M.blend(hex6, alpha, base)
end

return M
