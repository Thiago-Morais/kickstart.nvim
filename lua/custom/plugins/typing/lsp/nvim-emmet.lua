local M = {}

function M.setup()
  vim.pack.add { 'https://github.com/olrtg/nvim-emmet' }

  M.add_keymaps()
end

function M.add_keymaps()
  vim.keymap.set({ 'n', 'v' }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
end

return M
