vim.pack.add { 'https://github.com/folke/persistence.nvim' }

local persistence = require 'persistence'
persistence.setup {
  dir = vim.fn.stdpath 'state' .. '/sessions/', -- directory where session files are saved
  -- minimum number of file buffers that need to be open to save
  -- Set to 0 to always save
  need = 1,
  branch = true, -- use git branch to save session
}

vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('persistence-autoload', { clear = true }),
  callback = function()
    persistence.load()
  end,
  nested = true,
})

vim.keymap.set('n', '<leader>ps', function()
  persistence.load()
end, { desc = 'Load the [S]ession for the current directory' })
vim.keymap.set('n', '<leader>pS', function()
  persistence.select()
end, { desc = '[S]elect a [S]ession to load' })
vim.keymap.set('n', '<leader>pl', function()
  persistence.load { last = true }
end, { desc = 'Load the [L]ast session' })
vim.keymap.set('n', '<leader>pd', function()
  persistence.stop()
end, { desc = "stop/[D]rop Persistence => session won't be saved on exit" })
