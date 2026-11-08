vim.pack.add {
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  -- Adapters
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/nvim-neotest/neotest-plenary',
  'https://github.com/nvim-neotest/neotest-vim-test',
  'https://github.com/nvim-neotest/neotest-jest',
  'https://github.com/marilari88/neotest-vitest',
  'https://github.com/thenbe/neotest-playwright',
  'https://github.com/nvim-neotest/neotest',
}

require('neotest').setup {
  adapters = {
    require 'neotest-python' {
      dap = { justMyCode = false },
    },
    require 'neotest-plenary',
    require 'neotest-vim-test' {
      ignore_file_types = { 'python', 'vim', 'lua' },
    },
    require 'neotest-jest',
    require 'neotest-vitest',
    require('neotest-playwright').adapter {
      options = {
        persist_project_selection = true,
        enable_dynamic_test_discovery = true,
      },
    },
  },
}

vim.keymap.set('n', '<leader>tn', '<cmd>Neotest run<CR>', { desc = 'Run the [N]earest test' })
vim.keymap.set('n', '<leader>tr', '<cmd>Neotest run<CR>', { desc = '[R]un the nearest test' })
vim.keymap.set('n', '<leader>tN', '<cmd>Neotest stop<CR>', { desc = 'Stop the [N]earest test' })
vim.keymap.set('n', '<leader>tR', '<cmd>Neotest stop<CR>', { desc = 'Stop the nearest test (inverse of [R]un)' })
vim.keymap.set('n', '<leader>tf', '<cmd>Neotest run file<CR>', { desc = 'Run the current [F]ile' })
vim.keymap.set('n', '<leader>tl', '<cmd>Neotest run last<CR>', { desc = 'Run [L]ast file' })
vim.keymap.set('n', '<leader>ta', '<cmd>Neotest attach<CR>', { desc = '[A]ttach to the nearest test' })
vim.keymap.set('n', '<leader>ts', '<cmd>Neotest summary<CR>', { desc = 'Open [S]ummary panel' })
vim.keymap.set('n', '<leader>to', '<cmd>Neotest output-panel<CR>', { desc = 'Open [O]utpup panel' })
vim.keymap.set('n', '<leader>tO', '<cmd>Neotest output<CR>', { desc = 'Open [O]utpup window' })
vim.keymap.set('n', '<leader>td', function()
  require('neotest').run.run { strategy = 'dap' }
end, { desc = '[D]ebug the nearest test' })
