vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

require('diffview').setup {
  hooks = {
    -- Taken from this example: https://github.com/sindrets/diffview.nvim/pull/258#issuecomment-1408689220
    diff_buf_win_enter = function(bufnr, winid, ctx)
      if ctx.layout_name:match '^diff2' then
        if ctx.symbol == 'a' then
          vim.opt_local.winhl = table.concat({
            'DiffText:DiffviewDiffAddAsDelete',
            'DiffChange:DiffviewLineChangeDiffDelete',
          }, ',')
        elseif ctx.symbol == 'b' then
          vim.opt_local.winhl = table.concat({
            'DiffText:DiffviewDiffAdd',
            'DiffChange:DiffviewLineChangeDiffAdd',
          }, ',')
        end
      end
    end,
  },
}

vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = 'Open [G]it [D]iffView for the current file' })
vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewClose<CR>', { desc = 'Close [G]it [D]iffView' })
vim.keymap.set('n', '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', { desc = 'Open [G]it [F]ile history for the current file' })
vim.keymap.set('n', '<leader>gF', '<cmd>DiffviewClose<CR>', { desc = 'Close [G]it [F]ile history for the current file' })
