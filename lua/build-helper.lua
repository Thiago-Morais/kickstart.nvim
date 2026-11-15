-- Shared by the plugin modules' `build` functions
local M = {}

function M.try_build_with(plugin_name, command, cwd)
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

return M
