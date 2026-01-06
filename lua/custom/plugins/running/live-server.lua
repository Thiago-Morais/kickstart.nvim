return {
  'barrett-ruth/live-server.nvim',
  build = 'npm install -g live-server',
  cmd = { 'LiveServerStart', 'LiveServerStop', 'LiveServerToggle' },
  config = true,
  keys = {
    { '<leader>ls', '<cmd>LiveServerStart<CR>', desc = 'Start Live Server' },
    { '<leader>lx', '<cmd>LiveServerStop<CR>', desc = 'Stop Live Server' },
    { '<leader>lt', '<cmd>LiveServerToggle<CR>', desc = 'Toggle Live Server' },
  },
}
