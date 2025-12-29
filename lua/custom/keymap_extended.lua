local M = {}

function M.set(modes, lhs, rhs, opts)
  if type(lhs) == 'table' then
    for _, key in ipairs(lhs) do
      vim.keymap.set(modes, key, rhs, opts)
    end
  else
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

return M
