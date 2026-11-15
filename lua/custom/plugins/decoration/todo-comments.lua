-- Highlight todo, notes, etc in comments

local M = {}

function M.setup()
  vim.pack.add {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/folke/todo-comments.nvim',
  }
  require('todo-comments').setup { signs = false }
end

return M
