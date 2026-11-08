-- [[ Install and configure plugins ]]
--
-- Unlike lazy.nvim, `vim.pack` loads plugins in the order they are added,
-- and every plugin is loaded at startup. Each module below calls
-- `vim.pack.add` and then sets its plugins up, so the order matters when
-- one plugin needs another (e.g. mason before mason-nvim-dap).
--
--  To check the current status of your plugins, run
--    :checkhealth vim.pack

-- mini.icons must be set up first so it can stand in for nvim-web-devicons.
require 'custom.plugins.mini.mini'
require 'custom.plugins.decoration'
require 'custom.plugins.telescope'
require 'custom.plugins.typing'

require 'kickstart.plugins.gitsigns'
require 'kickstart.plugins.debug'
require 'kickstart.plugins.indent_line'
require 'kickstart.plugins.lint'
require 'kickstart.plugins.autopairs'
require 'kickstart.plugins.neo-tree'

require 'custom.plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
