-- [[ Snippet Engine ]]
-- LuaSnip's regex support is built in `pack-build-hooks.lua`
vim.pack.add {
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
  -- `friendly-snippets` contains a variety of premade snippets.
  --    See the README about individual language/framework/plugin snippets:
  --    https://github.com/rafamadriz/friendly-snippets
  'https://github.com/rafamadriz/friendly-snippets',
}
require('luasnip').setup {}
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load { paths = { './snippets' } }

vim.keymap.set({ 'n', 'i', 's' }, '<Tab>', function()
  local luasnip = require 'luasnip'
  if luasnip.locally_jumpable(1) then
    luasnip.jump(1)
  else
    require('custom.keymap_extended').feedkey '<Tab>'
  end
end)
vim.keymap.set({ 'n', 'i', 's' }, '<S-Tab>', function()
  local luasnip = require 'luasnip'
  if luasnip.locally_jumpable(-1) then
    luasnip.jump(-1)
  else
    require('custom.keymap_extended').feedkey '<S-Tab>'
  end
end)
vim.keymap.set({ 'n', 'i', 's' }, '<C-E>', function()
  local luasnip = require 'luasnip'
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)

-- [[ Autocomplete Engine ]]
vim.pack.add {
  -- use v2.* of blink.compat for blink.cmp v1.*
  { src = 'https://github.com/saghen/blink.compat', version = vim.version.range '2.*' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
  -- Extra completion sources
  'https://github.com/MahanRahmati/blink-nerdfont.nvim',
  'https://github.com/Kaiser-Yang/blink-cmp-git',
  'https://github.com/disrupted/blink-cmp-conventional-commits',
  'https://github.com/moyiz/blink-emoji.nvim',
  { src = 'https://github.com/mikavilpas/blink-ripgrep.nvim', version = vim.version.range '*' },
}
require('blink.compat').setup {}

--- @module 'blink.cmp'
--- @type blink.cmp.Config
local blink_config = {
  keymap = {
    preset = 'enter',
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
    ['<Tab>'] = { 'select_next', 'fallback' },
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'nerdfont', 'git', 'conventional_commits', 'emoji' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      nerdfont = {
        module = 'blink-nerdfont',
        name = 'Nerd Fonts',
        score_offset = 15, -- Tune by preference
        opts = {
          insert = true, -- Insert nerdfont icon (default) or complete its name
          trigger = ':-)', -- Customize the trigger. Defaults to ":"
        },
      },
      git = {
        module = 'blink-cmp-git',
        name = 'Git',
        opts = {
          -- options for the blink-cmp-git
        },
      },
      conventional_commits = {
        name = 'Conventional Commits',
        module = 'blink-cmp-conventional-commits',
        enabled = function()
          return vim.bo.filetype == 'gitcommit'
        end,
        ---@module 'blink-cmp-conventional-commits'
        ---@type blink-cmp-conventional-commits.Options
        opts = {}, -- none so far
      },
      emoji = {
        module = 'blink-emoji',
        name = 'Emoji',
        score_offset = 15, -- Tune by preference
        opts = {
          insert = true, -- Insert emoji (default) or complete its name
          ---@type string|table|fun():table
          trigger = function()
            return { ':' }
          end,
        },
        should_show_items = function()
          return vim.tbl_contains(
            -- Enable emoji completion only for git commits and markdown.
            -- By default, enabled for all file-types.
            { 'gitcommit', 'markdown' },
            vim.o.filetype
          )
        end,
      },
      ripgrep = {
        module = 'blink-ripgrep',
        name = 'Ripgrep',
        -- see the full configuration below for all available options
        ---@module "blink-ripgrep"
        ---@type blink-ripgrep.Options
        opts = {},
      },
    },
  },

  snippets = { preset = 'luasnip' },

  -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  -- which automatically downloads a prebuilt binary when enabled.
  --
  -- By default, we use the Lua implementation instead, but you may enable
  -- the rust implementation via `'prefer_rust_with_warning'`
  --
  -- See :h blink-cmp-config-fuzzy for more information
  fuzzy = { implementation = 'lua' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}
require('blink.cmp').setup(blink_config)
