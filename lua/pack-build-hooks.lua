-- [[ Intro to `vim.pack` ]]
-- `vim.pack` is the plugin manager built into Neovim (0.12+).
--
--  See `:help vim.pack`, `:help vim.pack-examples` or
--  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
--
--  To inspect plugin state and pending updates, run
--    :lua vim.pack.update(nil, { offline = true })
--
--  To update plugins, run
--    :lua vim.pack.update()
--
--  To remove a plugin you no longer `vim.pack.add`, run
--    :lua vim.pack.del { 'plugin-name' }
--
-- `vim.pack` has no `build` field, so build steps run from the
-- `PackChanged` event after a plugin is installed or updated, by calling
-- the `build` function of the plugin's module.
-- See `:help vim.pack-events`

local M = {}

-- The hook requires these modules while plugins are still installing,
-- so requiring them must not run `vim.pack.add` or any setup.
---@type table<string, string>
local build_modules_by_plugin = {
  ['telescope-fzf-native.nvim'] = 'custom.plugins.telescope',
  ['LuaSnip'] = 'custom.plugins.typing.blink',
  ['nvim-treesitter'] = 'custom.plugins.decoration.nvim-treesitter',
  ['markdown-preview.nvim'] = 'custom.plugins.running.markdown-preview',
  ['live-server.nvim'] = 'custom.plugins.running.live-server',
}

function M.setup()
  vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('pack-build-hooks', { clear = true }),
    callback = function(event)
      local kind = event.data.kind
      if kind ~= 'install' and kind ~= 'update' then
        return
      end

      local build_module = build_modules_by_plugin[event.data.spec.name]
      if build_module then
        require(build_module).build(event.data.path, event.data.active)
      end
    end,
  })
end

return M

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
