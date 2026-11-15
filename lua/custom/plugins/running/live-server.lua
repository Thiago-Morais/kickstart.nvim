local M = {}

-- `live-server` itself is installed with npm (see `pack-build-hooks.lua`)
function M.setup()
  vim.g.live_server = {
    port = 8080,
    -- browser = true,
  }

  vim.pack.add { 'https://github.com/Thiago-Morais/live-server.nvim' }

  M.add_keymaps()
end

function M.add_keymaps()
  vim.keymap.set('n', '<leader>ls', '<Plug>(live-server-start)', { desc = 'Start Live Server' })
  vim.keymap.set('n', '<leader>ld', '<Plug>(live-server-stop)', { desc = 'Stop Live Server' })
  vim.keymap.set('n', '<leader>lt', '<Plug>(live-server-toggle)', { desc = 'Toggle Live Server' })
end

return M
