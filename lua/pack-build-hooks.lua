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
-- `PackChanged` event after a plugin is installed or updated.
-- See `:help vim.pack-events`

local function run_build(plugin_name, command, cwd)
  local result = vim.system(command, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then
      output = 'No output from build command.'
    end
    vim.notify(('Build failed for %s:\n%s'):format(plugin_name, output), vim.log.levels.ERROR)
  end
end

---@type table<string, fun(plugin_path: string, is_active: boolean)>
local build_steps_by_plugin = {
  ['telescope-fzf-native.nvim'] = function(plugin_path)
    if vim.fn.executable 'make' == 1 then
      run_build('telescope-fzf-native.nvim', { 'make' }, plugin_path)
    end
  end,

  -- Build Step is needed for regex support in snippets.
  ['LuaSnip'] = function(plugin_path)
    if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
      run_build('LuaSnip', { 'make', 'install_jsregexp' }, plugin_path)
    end
  end,

  ['nvim-treesitter'] = function(_, is_active)
    if not is_active then
      vim.cmd.packadd 'nvim-treesitter'
    end
    vim.cmd 'TSUpdate'
  end,

  ['markdown-preview.nvim'] = function(plugin_path)
    run_build('markdown-preview.nvim', { 'yarn', 'install' }, vim.fs.joinpath(plugin_path, 'app'))
  end,

  ['live-server.nvim'] = function(plugin_path)
    run_build('live-server.nvim', { 'npm', 'install', '-g', 'live-server' }, plugin_path)
  end,
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-build-hooks', { clear = true }),
  callback = function(event)
    local kind = event.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    local build_step = build_steps_by_plugin[event.data.spec.name]
    if build_step then
      build_step(event.data.path, event.data.active)
    end
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
