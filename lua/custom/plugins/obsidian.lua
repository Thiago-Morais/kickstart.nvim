-- Requires plenary, telescope and nvim-treesitter (added earlier in `pack-plugins.lua`)
-- Use the latest release instead of the latest commit
vim.pack.add { { src = 'https://github.com/epwalsh/obsidian.nvim', version = vim.version.range '*' } }

-- Set up on the first markdown buffer only: setup fails when the vault folder doesn't exist.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('obsidian-setup', { clear = true }),
  pattern = 'markdown',
  once = true,
  callback = function()
    require('obsidian').setup {
      workspaces = {
        {
          name = 'main-vault',
          path = '~/Documents/obsidian/main-vault',
        },
      },
    }
  end,
})
