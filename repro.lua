-- template from https://lazy.folke.io/developers#reprolua, feel free to replace if you have your own minimal init.lua
vim.env.LAZY_STDPATH = '.repro'
load(vim.fn.system 'curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua')()

require('lazy.minit').repro {
  spec = {
    {
      'nvim-neo-tree/neo-tree.nvim',
      -- branch = 'v3.x', -- or "main"
      branch = 'main', -- or "main"
      -- version = '*',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
        -- { "3rd/image.nvim", opts = {} }, -- Optional image support
      },
      lazy = false,
      keys = {
        { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
      },
      ---@module "neo-tree"
      ---@type neotree.Config?
      opts = {
        -- fill any relevant options here
        filesystem = {
          window = {
            mappings = {
              ['\\'] = 'close_window',
            },
          },
        },
      },
    },
  },
}
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree<CR>')
-- do anything else you need to do to reproduce the issue
