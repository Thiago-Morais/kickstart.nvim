-- Fill the gaps in mini.icons with icons from nvim-web-devicons' data tables
-- (e.g. GNU for Makefile, npm for package.json), without replacing any icon
-- mini.icons already has.
--
-- Only the data files are required, never the `nvim-web-devicons` module itself,
-- which `MiniIcons.mock_nvim_web_devicons()` replaces.

local M = {}

-- mini.icons only has these colours, so each devicons colour is mapped to the
-- closest hue. The actual colours then follow the colorscheme (and matugen).
local hue_ranges = {
  { max_hue = 15, group = 'MiniIconsRed' },
  { max_hue = 45, group = 'MiniIconsOrange' },
  { max_hue = 70, group = 'MiniIconsYellow' },
  { max_hue = 160, group = 'MiniIconsGreen' },
  { max_hue = 195, group = 'MiniIconsCyan' },
  { max_hue = 220, group = 'MiniIconsAzure' },
  { max_hue = 255, group = 'MiniIconsBlue' },
  { max_hue = 330, group = 'MiniIconsPurple' },
  { max_hue = 360, group = 'MiniIconsRed' },
}
-- Below this saturation a colour reads as grey rather than a hue
local grey_saturation_threshold = 0.2

---@param hex_color string Color like '#6D8086'
---@return string highlight_group
local function closest_mini_highlight(hex_color)
  local red = tonumber(hex_color:sub(2, 3), 16) / 255
  local green = tonumber(hex_color:sub(4, 5), 16) / 255
  local blue = tonumber(hex_color:sub(6, 7), 16) / 255

  local brightest = math.max(red, green, blue)
  local darkest = math.min(red, green, blue)
  local chroma = brightest - darkest
  local saturation = brightest == 0 and 0 or chroma / brightest
  if saturation < grey_saturation_threshold then
    return 'MiniIconsGrey'
  end

  local hue
  if brightest == red then
    hue = ((green - blue) / chroma) % 6
  elseif brightest == green then
    hue = (blue - red) / chroma + 2
  else
    hue = (red - green) / chroma + 4
  end
  hue = hue * 60

  for _, range in ipairs(hue_ranges) do
    if hue <= range.max_hue then
      return range.group
    end
  end
  return 'MiniIconsRed'
end

---@param devicon { icon: string, color: string }
local function to_mini_icon(devicon)
  return { glyph = devicon.icon, hl = closest_mini_highlight(devicon.color) }
end

-- devicons matches file names case-insensitively and stores them in lower case,
-- but mini.icons matches exact names. Names without an extension are usually
-- capitalized (makefile -> Makefile, gemfile -> Gemfile), so add that spelling too.
local function name_spellings(file_name)
  local capitalized = file_name:sub(1, 1):upper() .. file_name:sub(2)
  if file_name:find('.', 1, true) or capitalized == file_name then
    return { file_name }
  end
  return { file_name, capitalized }
end

--- File name overrides for `require('mini.icons').setup()`.
--- Cheap enough to run at startup (about 2 ms).
---@return table<string, table>
function M.file_overrides()
  local devicons_by_file_name = require 'nvim-web-devicons.default.icons_by_filename'

  -- Set mini.icons up with its defaults to see which names it has a specific icon for
  local mini_icons = require 'mini.icons'
  mini_icons.setup()
  local mini_file_names = {}
  for _, file_name in ipairs(mini_icons.list 'file') do
    mini_file_names[file_name] = true
  end

  local file_overrides = {}
  for file_name, devicon in pairs(devicons_by_file_name) do
    for _, spelling in ipairs(name_spellings(file_name)) do
      if not mini_file_names[spelling] then
        file_overrides[spelling] = to_mini_icon(devicon)
      end
    end
  end
  return file_overrides
end

--- Extension overrides, only for extensions mini.icons doesn't recognize at all
--- (it would show its default icon), so its filetype-based icons stay.
--- Each check runs a filetype lookup (about 17 ms for all of them), so call this
--- after startup. mini.icons must already be set up without extension overrides.
---@return table<string, table>
function M.extension_overrides()
  local devicons_by_extension = require 'nvim-web-devicons.default.icons_by_file_extension'

  local extension_overrides = {}
  for extension, devicon in pairs(devicons_by_extension) do
    local _, _, is_default = MiniIcons.get('extension', extension)
    if is_default then
      extension_overrides[extension] = to_mini_icon(devicon)
    end
  end
  return extension_overrides
end

return M
