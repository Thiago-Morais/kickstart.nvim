local M = {}

function M.setup()
  -- The colorscheme goes first so later plugins pick up its highlights.
  require('custom.plugins.decoration.tokyonight').setup()
  require('custom.plugins.decoration.which-key').setup()
  require('custom.plugins.decoration.todo-comments').setup()
  require('custom.plugins.decoration.nvim-colorizer').setup()
  require('custom.plugins.decoration.smear-cursor').setup()
  require('custom.plugins.decoration.vim-fugitive').setup()
  require('custom.plugins.decoration.nvim-treesitter').setup()
end

return M
