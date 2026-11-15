local M = {}

function M.setup()
  vim.pack.add { 'https://github.com/tpope/vim-fugitive' }

  M.add_keymaps()
end

function M.add_keymaps()
  vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<CR>', { desc = '[G]it [B]lame' })
  vim.keymap.set('n', '<leader>gs', '<cmd>Git<CR>', { desc = '[G]it [S]tatus' })
end

return M
