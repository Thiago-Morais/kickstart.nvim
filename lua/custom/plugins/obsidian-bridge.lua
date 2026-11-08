vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/oflisback/obsidian-bridge.nvim',
}

-- Set up when the first markdown file is opened, so other sessions don't
-- need the Obsidian REST API key and certificate.
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('obsidian-bridge-setup', { clear = true }),
  pattern = '*.md',
  once = true,
  callback = function()
    require('obsidian-bridge').setup {
      obsidian_server_address = 'https://127.0.0.1:27124',
      cert_path = '~/.ssl/obsidian-local-rest-api.crt',
      -- scroll_sync = true,
    }
    -- The command only exists when setup succeeded (API key and certificate found).
    if vim.fn.exists ':ObsidianBridgeOff' == 2 then
      vim.cmd 'ObsidianBridgeOff'
    end
  end,
})
