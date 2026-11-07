-- Configures lua_ls for editing your Neovim config (runtime, plugins and API types).
-- It only activates in Lua buffers.
vim.pack.add { 'https://github.com/folke/lazydev.nvim' }

require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}
