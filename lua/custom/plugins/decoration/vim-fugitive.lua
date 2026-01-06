return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  keys = {
    { '<leader>gb', '<cmd>Git blame<CR>', desc = '[G]it [B]lame' },
    { '<leader>gs', '<cmd>Git<CR>', desc = '[G]it [S]tatus' },
  },
}
