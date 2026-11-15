local M = {}

function M.setup()
  vim.pack.add { 'https://github.com/hat0uma/csvview.nvim' }

  ---@module "csvview"
  ---@type CsvView.Options
  require('csvview').setup {
    parser = {
      comments = { '#', '//' },
      delimiter = {
        ft = { tsv = '\t' },
      },
    },
    keymaps = {
      -- Text objects for selecting fields
      textobject_field_inner = { 'if', mode = { 'o', 'x' } },
      textobject_field_outer = { 'af', mode = { 'o', 'x' } },
      -- Excel-like navigation:
      -- Use <Tab> and <S-Tab> to move horizontally between fields.
      -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
      -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
      jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
      jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
      jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
      jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
    },
  }

  M.add_keymaps()
end

function M.add_keymaps()
  vim.keymap.set({ 'n', 'x' }, '<leader>tc', '<cmd>CsvViewToggle<CR>', { desc = 'Toggle Csv View' })
end

return M
