-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--
-- `mini`, `decoration`, `telescope` and `typing` are set up earlier from
-- `pack-plugins.lua` because other plugins depend on them.

local M = {}

function M.setup()
  require('custom.plugins.running').setup()
  require('custom.plugins.neovim-extension').setup()
  require('custom.plugins.obsidian').setup()
  require('custom.plugins.obsidian-bridge').setup()
  require('custom.plugins.persisted').setup()
  -- Disabled to avoid duplicate LSP actions with ts_ls
  -- require('custom.plugins.typescript-tools').setup()
end

return M
