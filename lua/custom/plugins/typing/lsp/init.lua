local M = {}

function M.setup()
  -- lazydev goes before the LSP so lua_ls gets the Neovim runtime types.
  require('custom.plugins.typing.lsp.lazy-dev').setup()
  require('custom.plugins.typing.lsp.nvim-lspconfig').setup()
  require('custom.plugins.typing.lsp.conform').setup()
  require('custom.plugins.typing.lsp.nvim-emmet').setup()
  require('custom.plugins.typing.lsp.vim-matchup').setup()
end

return M
