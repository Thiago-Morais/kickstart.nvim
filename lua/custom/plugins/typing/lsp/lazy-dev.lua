-- Configures lua_ls for editing your Neovim config (runtime, plugins and API types).
-- It only activates in Lua buffers.

local M = {}

function M.setup()
  vim.pack.add { 'https://github.com/folke/lazydev.nvim' }

  require('lazydev').setup {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  }
end

return M
