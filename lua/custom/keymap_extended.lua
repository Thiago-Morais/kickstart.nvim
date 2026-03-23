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

function M.feedkey(key)
  local remapped_key = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(remapped_key, 'n', false)
end

return M
