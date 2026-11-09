vim.pack.add { 'https://www.github.com/olimorris/persisted.nvim' }

local persisted = require 'persisted'

persisted.setup {
  autoload = true,
  use_git_branch = true,
  on_autoload_no_session = function()
    vim.notify 'No existing session to load.'
  end,
  before_save = function(opts)
    -- If the session is being saved manually, then do nothing
    if not opts.auto then
      return
    end
    -- Otherwise, close those terminal buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == 'terminal' then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
}

require('telescope').load_extension 'persisted'

vim.api.nvim_create_autocmd('User', {
  pattern = 'PersistedTelescopeLoadPre',
  callback = function(session)
    -- Save the currently loaded session passing in the path to the current session
    persisted.save { session = vim.g.persisted_loaded_session }

    -- Delete all of the open buffers
    vim.api.nvim_input '<ESC>:%bd<CR>'
  end,
})
