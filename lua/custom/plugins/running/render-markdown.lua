return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
  opts = {
    completions = {
      blink = { enabled = true },
      coq = { enabled = true },
      lsp = { enabled = true },
    },
    preset = 'lazy',
  },
}
