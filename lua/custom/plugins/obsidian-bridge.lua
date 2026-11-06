local obsidian_bridge_settings = {
  obsidian_server_address = 'https://127.0.0.1:27124',
  cert_path = '~/.ssl/obsidian-local-rest-api.crt',
  -- scroll_sync = true,
}

return {
  'oflisback/obsidian-bridge.nvim',
  -- enabled = false,
  opts = obsidian_bridge_settings,
  event = {
    'BufReadPre *.md',
    'BufNewFile *.md',
    -- 'VeryLazy',
  },
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('obsidian-bridge').setup(obsidian_bridge_settings)
    vim.cmd ':ObsidianBridgeOff'
  end,
}
