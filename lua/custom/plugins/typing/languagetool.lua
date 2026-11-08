vim.pack.add { 'https://github.com/liba2k/languagetool.nvim' }

require('languagetool').setup {
  -- server_url = 'https://lang.thiagomorais.dev/v2',
  server_url = 'http://localhost:8081',
  language = 'pt-BR',
}

vim.keymap.set('n', '<leader>lc', '<cmd>LTCheck<cr>', { desc = 'Check line' })
vim.keymap.set('v', '<leader>lc', '<cmd>LTCheck<cr>', { desc = 'Check selection' })
vim.keymap.set('n', '<leader>lb', '<cmd>LTCheckBuffer<cr>', { desc = 'Check buffer' })
vim.keymap.set('n', '<leader>lf', '<cmd>LTFix<cr>', { desc = 'Show fixes' })
vim.keymap.set('n', '<leader>lx', '<cmd>LTClear<cr>', { desc = 'Clear diagnostics' })
