-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

require 'options'
require 'keymaps'
require 'commands'
-- Build hooks must be registered before any `vim.pack.add` call,
-- otherwise they won't run when a plugin is first installed.
require 'pack-build-hooks'
require 'pack-plugins'
require('custom.matugen_config').setup()
require 'custom-extensions'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
