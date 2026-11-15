local M = {}

function M.setup()
  require('custom.plugins.neovim-extension.diffview').setup()
  require('custom.plugins.neovim-extension.neotest').setup()
end

return M
