-- Uses telescope.nvim as its picker (see `custom/plugins/telescope.lua`)

local M = {}

function M.setup()
  vim.pack.add { 'https://github.com/brianhuster/live-preview.nvim' }

  M.add_keymaps()
end

function M.add_keymaps()
  vim.keymap.set('n', '<leader>v', '<cmd>LivePreview close<CR><cmd>LivePreview start<CR>', { desc = 'Restart LivePreview' })
end

return M
