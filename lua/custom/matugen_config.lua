local matugen = {}

local function source_matugen()
  -- Update this with the location of your output file
  local matugen_path = os.getenv 'HOME' .. '/.config/nvim/matugen.lua' -- dofile doesn't expand $HOME or ~

  local file, err = io.open(matugen_path, 'r')
  -- If the matugen file does not exist (yet or at all), we must initialize a color scheme ourselves
  if err ~= nil then
    -- if true then
    -- Some placeholder theme, this will be overwritten once matugen kicks in
    -- vim.cmd 'colorscheme base16-catppuccin-mocha'
    vim.cmd.colorscheme 'tokyonight-night'

    -- Optionally print something to the user
    vim.print "A matugen style file was not found, but that's okay! The colorscheme will dynamically change if matugen runs!"
  else
    dofile(matugen_path)
    io.close(file)
  end
end

-- Main entrypoint on matugen reloads
local function reload()
  -- Load the matugen style file to get all the new colors
  source_matugen()

  -- -- Because reloading base16 overwrites lualine configuration, just source lualine here
  -- dofile(os.getenv 'HOME' .. '/.config/nvim/config/plugins/lualine-nvim.lua') -- path of your lualine setup

  -- Any other options you wish to set upon matugen reloads can also go here!
  local comment_hl = vim.api.nvim_get_hl(0, { name = 'Comment' })
  comment_hl.italic = true
  vim.api.nvim_set_hl(0, 'Comment', comment_hl)
end

function matugen.setup()
  -- Register an autocmd to listen for matugen updates
  vim.api.nvim_create_autocmd('Signal', {
    pattern = 'SIGUSR1',
    callback = reload,
  })

  reload()
end

-- Additionally call this function once on startup to query for matugen's theme
-- or set a default
return matugen
