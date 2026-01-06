return {
  'sindrets/diffview.nvim',
  opts = {
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
  },
}
