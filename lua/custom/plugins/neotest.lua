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
  end,

  event = 'VimEnter',
  keys = {
    { '<leader>tn', '<cmd>Neotest run<CR>', desc = 'Run the [N]earest test' },
    { '<leader>tr', '<cmd>Neotest run<CR>', desc = '[R]un the nearest test' },
    { '<leader>tN', '<cmd>Neotest stop<CR>', desc = 'Stop the [N]earest test' },
    { '<leader>tR', '<cmd>Neotest stop<CR>', desc = 'Stop the nearest test (inverse of [R]un)' },
    { '<leader>tf', '<cmd>Neotest run file<CR>', desc = 'Run the current [F]ile' },
    { '<leader>tl', '<cmd>Neotest run last<CR>', desc = 'Run [L]ast file' },
    { '<leader>ta', '<cmd>Neotest attach<CR>', desc = '[A]ttach to the nearest test' },
    { '<leader>ts', '<cmd>Neotest summary<CR>', desc = 'Open [S]ummary panel' },
    { '<leader>to', '<cmd>Neotest output-panel<CR>', desc = 'Open [O]utpup panel' },
    { '<leader>td', '<cmd>lua require("neotest").run.run ({ strategy = "dap" })<CR>', desc = '[D]ebug the nearest test' },
  },
}
