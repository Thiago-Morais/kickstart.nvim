-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- [[ Interaction ]]
vim.o.mouse = 'a'
vim.o.undofile = true
vim.o.confirm = true
-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
-- Used when there is no uppercase letter
vim.o.ignorecase = true
vim.o.smartcase = true
-- Decrease update time
-- Plugin activation delay depend on this number
vim.o.updatetime = 250
-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true

-- [[ Style ]]
vim.o.showmode = false
-- Sidebar
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
-- Text area
vim.o.breakindent = true
vim.o.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
-- Indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = false
vim.o.smartindent = true
--   `vim.o` and `vim.opt` are mostly the same but `vim.opt` can work with tables
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- [[ Others ]]
vim.o.inccommand = 'split'
vim.o.exrc = true
vim.o.secure = true
-- Remap filetypes
vim.filetype.add {
  extension = { rasi = 'rasi', rofi = 'rasi', wofi = 'rasi', sh = 'bash' },
  pattern = {
    ['.*/mako/config'] = 'dosini',
    ['.*/hypr/.+%.conf'] = 'hyprlang',
    ['%.env%.[%w_.-]+'] = 'sh',
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
