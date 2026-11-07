-- Minimal config to reproduce plugin issues in isolation.
-- Run it with a separate app name so it doesn't touch your real plugins:
--   NVIM_APPNAME=nvim-repro nvim -u repro.lua
vim.g.mapleader = ' '

vim.pack.add {
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  -- 'https://github.com/3rd/image.nvim', -- Optional image support
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree<CR>')

---@module "neo-tree"
---@type neotree.Config
require('neo-tree').setup {
  -- fill any relevant options here
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}
-- do anything else you need to do to reproduce the issue
