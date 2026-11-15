-- Requires telescope.nvim (see `custom/plugins/telescope.lua`)

local M = {}

function M.setup()
  vim.pack.add { 'https://github.com/johmsalas/text-case.nvim' }

  require('textcase').setup {
    prefix = '<leader>c',
  }
  require('telescope').load_extension 'textcase'

  M.add_keymaps()
end

function M.add_keymaps()
  vim.keymap.set({ 'n', 'x' }, '<leader>c.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Text [C]ase in Telescope' })
end

return M
