-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local args = vim.fn.argv()
    if #args >= 1 then
      local stat = vim.loop.fs_stat(args[1])
      if stat then
        if stat.type == 'directory' then
          vim.api.nvim_set_current_dir(args[1])
        else
          vim.api.nvim_set_current_dir(vim.fn.fnamemodify(args[1], ':h'))
        end
      end
    end
  end,
})

-- An example subset of your init.lua

-- Format document with a custom formatter
vim.api.nvim_create_user_command('FormatWith', function(opts)
  local list = vim.split(opts.args, ',', { trimempty = true })
  require('conform').format { formatters = list }
end, {
  nargs = 1,
  desc = 'Format with a comma-separated list of formatters',
  complete = function()
    return require('mason-registry').get_installed_package_names()
  end,
})
