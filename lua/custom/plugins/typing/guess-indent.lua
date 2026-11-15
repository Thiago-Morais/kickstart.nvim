local M = {}

function M.setup()
  vim.pack.add { 'https://github.com/NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}
end

return M
