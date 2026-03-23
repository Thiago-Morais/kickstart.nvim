return { -- Lua
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  opts = {
    dir = vim.fn.stdpath 'state' .. '/sessions/', -- directory where session files are saved
    -- minimum number of file buffers that need to be open to save
    -- Set to 0 to always save
    need = 1,
    branch = true, -- use git branch to save session
  },
  keys = {
    {
      '<leader>ps',
      function()
        require('persistence').load()
      end,
      desc = 'Load the [S]ession for the current directory',
    },
    {
      '<leader>pS',
      function()
        require('persistence').select()
      end,
      desc = '[S]elect a [S]ession to load',
    },
    {
      '<leader>pl',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'Load the [L]ast session',
    },
    {
      '<leader>pd',
      function()
        require('persistence').stop()
      end,
      desc = "stop/[D]rop Persistence => session won't be saved on exit",
    },
  },
}
