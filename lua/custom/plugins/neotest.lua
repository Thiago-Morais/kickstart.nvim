return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- Adapters
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-plenary',
    'nvim-neotest/neotest-vim-test',
    'nvim-neotest/neotest-jest',
  },

  config = function()
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
      },
    }

    vim.keymap.set('n', '<leader>tn', '<cmd>Neotest run<CR>', { desc = 'Run the [N]earest test' })
    vim.keymap.set('n', '<leader>tf', '<cmd>Neotest run file<CR>', { desc = 'Run the current [F]ile' })
    vim.keymap.set('n', '<leader>tl', '<cmd>Neotest run last<CR>', { desc = 'Run [L]ast file' })
    vim.keymap.set('n', '<leader>tN', '<cmd>Neotest stop<CR>', { desc = 'Stop the [N]earest test' })
    vim.keymap.set('n', '<leader>ta', '<cmd>Neotest attach<CR>', { desc = '[A]ttach to the nearest test' })
    vim.keymap.set('n', '<leader>ts', '<cmd>Neotest summary<CR>', { desc = 'Open [S]ummary panel' })
    vim.keymap.set('n', '<leader>to', '<cmd>Neotest output-panel<CR>', { desc = 'Open [O]utpup panel' })
    vim.keymap.set('n', '<leader>td', '<cmd>lua require("neotest").run.run ({ strategy = "dap" })<CR>', { desc = '[D]ebug the nearest test' })
  end,
}
