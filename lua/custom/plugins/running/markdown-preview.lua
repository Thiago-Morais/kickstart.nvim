local M = {}

-- The preview app is installed with yarn
function M.build(plugin_path)
  require('build-helper').try_build_with('markdown-preview.nvim', { 'yarn', 'install' }, vim.fs.joinpath(plugin_path, 'app'))
end

function M.setup()
  vim.g.mkdp_filetypes = { 'markdown' }

  vim.pack.add { 'https://github.com/iamcco/markdown-preview.nvim' }
end

return M
