return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'json',
      'jsonc',
      'javascript',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    install = { prefer_git = true },
  },
  config = function(_, opts)
    require('nvim-treesitter').setup(opts)
    -- require('nvim-treesitter').install(opts.ensure_installed)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        -- pcall: silently no-op on filetypes with no parser installed
        pcall(vim.treesitter.start)
      end,
    })
  end,
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
