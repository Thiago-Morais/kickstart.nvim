-- Disabled to keep markdown syntax visible
do
  return
end

vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }
require('render-markdown').setup {
  completions = {
    blink = { enabled = true },
    coq = { enabled = true },
    lsp = { enabled = true },
  },
  preset = 'lazy',
}
