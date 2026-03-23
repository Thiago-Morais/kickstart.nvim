return {
  'barrett-ruth/live-server.nvim',
  build = 'npm install -g live-server',
  cmd = { 'LiveServerStart', 'LiveServerStop', 'LiveServerToggle' },
  keys = {
    { '<leader>ls', '<Plug>(live-server-start)', desc = 'Start Live Server' },
    { '<leader>lx', '<Plug>(live-server-stop)', desc = 'Stop Live Server' },
    { '<leader>lt', '<Plug>(live-server-toggle)', desc = 'Toggle Live Server' },
  },
  init = function()
    vim.g.live_server = {
      port = 8080,
      browser = true,
    }
  end,
}
