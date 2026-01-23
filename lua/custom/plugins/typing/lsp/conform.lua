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

return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  dependencies = { 'zapling/mason-conform.nvim' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    log_level = vim.log.levels.DEBUG,
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      python = { 'isort', 'black' },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      -- javascript = { 'prettier', stop_after_first = true },
      jsonc = { 'biome', stop_after_first = true },
      markdown = { 'markdownlint' },
      bash = { 'beautysh' },
      sh = { 'beautysh' },
      hyprland = { 'hyprls' },
      ['_'] = { 'prettierd', 'prettier', lsp_format = 'fallback', stop_after_first = true },
      -- ['_'] = { 'prettier', lsp_format = 'fallback', stop_after_first = true },
    },
    formatters = {
      prettier = {
        append_args = function(_, ctx)
          local util = require 'conform.util'
          local root = util.root_file {
            '.prettierrc',
            '.prettierrc.json',
            '.prettierrc.yml',
            '.prettierrc.yaml',
            '.prettierrc.json5',
            '.prettierrc.js',
            '.prettierrc.cjs',
            '.prettierrc.mjs',
            '.prettierrc.toml',
            'prettier.config.js',
            'prettier.config.cjs',
            'prettier.config.mjs',
            'package.json',
          }

          if root then
            return {}
          else
            local bufnr = ctx.buf or ctx.bufnr or vim.api.nvim_get_current_buf()
            local shiftwidth = vim.bo[bufnr].shiftwidth
            local expandtab = vim.bo[bufnr].expandtab

            local args = { '--tab-width=' .. tostring(shiftwidth) }
            if not expandtab then
              table.insert(args, '--use-tabs')
            end
            return args
          end
        end,
      },
    },
  },
  config = function(_, opts)
    opts.formatters.prettierd = opts.formatters.prettier
    require('conform').setup(opts)
  end,
}
