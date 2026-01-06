--[[
  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.
-- 
  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.
-- 
    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.
-- 
    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.
-- 
  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.
-- 
   NOTE: Look for lines like this
-- 
    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.
-- 
If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.
-- 
I hope you enjoy your Neovim journey,
- TJ
-- 
P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = true
-- Used when there is no uppercase letter
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
-- Decrease update time
-- Plugin activation delay depend on this number
vim.o.updatetime = 250
-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
--   `vim.o` and `vim.opt` are mostly the same but `vim.opt` can work with tables
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'
vim.o.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
vim.o.confirm = true
-- Indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = false
vim.o.smartindent = true

vim.o.exrc = true
vim.o.secure = true
-- Remap filetypes
vim.filetype.add {
  extension = { rasi = 'rasi', rofi = 'rasi', wofi = 'rasi', sh = 'bash' },
}

-- [[ Basic Keymaps ]]
--
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
--  Move focus
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- Move window
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })
-- Resize window
vim.keymap.set('n', '<C-S-.>', '<C-w>>')
vim.keymap.set('n', '<C-S-,>', '<C-w><')
vim.keymap.set('n', '<C-S-=>', '<C-w>+')
vim.keymap.set('n', '<C-S-->', '<C-w>-')

vim.keymap.set('n', '<leader>wt', ':split | terminal<CR>')

-- Remap existing commands
vim.keymap.set('v', 'p', 'P')
vim.keymap.set('v', 'P', 'p')
vim.keymap.set('n', 'vv', 'V')
vim.keymap.set('n', 'd', '"_d')
vim.keymap.set('n', 'D', '"_D')
vim.keymap.set('n', 'c', '"_c')
vim.keymap.set('n', 'x', '"_x')
vim.keymap.set('n', 'dd', 'dd')

-- [[ Complex Keymaps ]]

vim.keymap.set('n', '<leader>nw', function()
  local shell = vim.env.SHELL
  vim.fn.jobstart({
    'alacritty',
    '-e',
    shell,
    '-c',
    'nvim;' .. shell,
  }, { detach = true })
end, { desc = '[N]ew [W]indow with CWD' })
vim.keymap.set('n', '<leader>cfr', function()
  local path = vim.fn.expand '%'
  vim.fn.setreg('+', path)
  vim.notify('Copied path:' .. path)
end, { desc = "[C]opy [F]ile's [R]elative path" })
vim.keymap.set({ 'n', 'x' }, '<leader>cfa', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.notify('Copied path:' .. path)
end, { desc = "[C]opy [F]ile's [A]bsolute path" })
vim.keymap.set({ 'n', 'x' }, '<leader>cff', function()
  local path = vim.fn.expand '%:f'
  vim.fn.setreg('+', path)
  vim.notify('Copied path:' .. path)
end, { desc = "[C]opy [F]ile's [F]ilename" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  { import = 'custom.plugins' },
  -- { import = 'custom.plugins.decoration' },
  -- { import = 'custom.plugins.typing' },
  -- { import = 'custom.plugins.lsp' },
  -- { import = 'custom.plugins.mini' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local args = vim.fn.argv()
    if #args >= 1 then
      local stat = vim.loop.fs_stat(args[1])
      if stat then
        if stat.type == 'directory' then
          vim.api.nvim_set_current_dir(args[1])
        else
          vim.api.nvim_set_current_dir(vim.fn.fnamemodify(args[1], ':h'))
        end
      end
    end
  end,
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- An example subset of your init.lua

-- Format document with a custom formatter
vim.api.nvim_create_user_command('FormatWith', function(opts)
  local list = vim.split(opts.args, ',', { trimempty = true })
  require('conform').format { formatters = list }
end, {
  nargs = 1,
  desc = 'Format with a comma-separated list of formatters',
  complete = function()
    return require('mason-registry').get_installed_package_names()
  end,
})

local function source_matugen()
  -- Update this with the location of your output file
  local matugen_path = os.getenv 'HOME' .. '/.config/nvim/matugen.lua' -- dofile doesn't expand $HOME or ~

  local file, err = io.open(matugen_path, 'r')
  -- If the matugen file does not exist (yet or at all), we must initialize a color scheme ourselves
  if err ~= nil then
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
local function auxiliary_function()
  -- Load the matugen style file to get all the new colors
  source_matugen()

  -- -- Because reloading base16 overwrites lualine configuration, just source lualine here
  -- dofile(os.getenv 'HOME' .. '/.config/nvim/config/plugins/lualine-nvim.lua') -- path of your lualine setup

  -- Any other options you wish to set upon matugen reloads can also go here!
  local comment_hl = vim.api.nvim_get_hl(0, { name = 'Comment' })
  comment_hl.italic = true
  vim.api.nvim_set_hl(0, 'Comment', comment_hl)
end

-- Register an autocmd to listen for matugen updates
vim.api.nvim_create_autocmd('Signal', {
  pattern = 'SIGUSR1',
  callback = auxiliary_function,
})

-- Additionally call this function once on startup to query for matugen's theme
-- or set a default
auxiliary_function()
