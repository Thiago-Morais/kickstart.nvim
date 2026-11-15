local M = {}

-- The preview app is installed with yarn (see `pack-build-hooks.lua`)
function M.setup()
  vim.g.mkdp_filetypes = { 'markdown' }

  vim.pack.add { 'https://github.com/iamcco/markdown-preview.nvim' }
end

return M
