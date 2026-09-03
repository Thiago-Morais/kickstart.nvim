return {
  'liba2k/languagetool.nvim',
  opts = {
    -- server_url = 'https://lang.thiagomorais.dev/v2',
    server_url = 'http://localhost:8081',
    language = 'pt-BR',
  },
  keys = {
    { '<leader>lc', '<cmd>LTCheck<cr>', desc = 'Check line' },
    { '<leader>lc', '<cmd>LTCheck<cr>', mode = 'v', desc = 'Check selection' },
    { '<leader>lb', '<cmd>LTCheckBuffer<cr>', desc = 'Check buffer' },
    { '<leader>lf', '<cmd>LTFix<cr>', desc = 'Show fixes' },
    { '<leader>lx', '<cmd>LTClear<cr>', desc = 'Clear diagnostics' },
  },
}
