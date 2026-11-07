-- Uses telescope.nvim as its picker (see `custom/plugins/telescope.lua`)
vim.pack.add { 'https://github.com/brianhuster/live-preview.nvim' }

vim.keymap.set('n', '<leader>v', '<cmd>LivePreview close<CR><cmd>LivePreview start<CR>', { desc = 'Restart LivePreview' })
