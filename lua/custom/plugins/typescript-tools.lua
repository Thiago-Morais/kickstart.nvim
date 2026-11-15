local M = {}

function M.setup()
  vim.pack.add {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/pmizio/typescript-tools.nvim',
  }
  require('typescript-tools').setup {
    expose_as_code_action = { 'all' },
  }
end

return M
