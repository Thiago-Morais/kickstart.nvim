-- Requires telescope.nvim (see `custom/plugins/telescope.lua`)
vim.pack.add { 'https://github.com/johmsalas/text-case.nvim' }

require('textcase').setup {
  prefix = '<leader>c',
}
require('telescope').load_extension 'textcase'

vim.keymap.set({ 'n', 'x' }, '<leader>c.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Text [C]ase in Telescope' })
