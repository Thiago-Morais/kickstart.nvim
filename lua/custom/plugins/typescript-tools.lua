return {
  'pmizio/typescript-tools.nvim',
  enabled = false,
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    expose_as_code_action = { 'all' },
  },
}
