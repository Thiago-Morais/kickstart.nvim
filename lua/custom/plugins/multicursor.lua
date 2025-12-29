return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'
    mc.setup()

    -- local set = vim.keymap.set
    local set = require('custom.keymap_extended').set

    -- Add or skip cursor above/below the main cursor.
    set({ 'n', 'x' }, { '<up>', '<leader>mk', '<C-M-k>' }, function()
      mc.lineAddCursor(-1)
    end, { desc = 'Add cursor above the main cursor (<C-M-k>)' })
    set({ 'n', 'x' }, { '<down>', '<leader>mj', '<C-M-j>' }, function()
      mc.lineAddCursor(1)
    end, { desc = 'Add cursor below the main cursor (<C-M-j>)' })
    set({ 'n', 'x' }, { '<leader><up>', '<leader>mK' }, function()
      mc.lineSkipCursor(-1)
    end, { desc = 'Skip cursor above the main cursor' })
    set({ 'n', 'x' }, { '<leader><down>', '<leader>mJ' }, function()
      mc.lineSkipCursor(1)
    end, { desc = 'Skip cursor below the main cursor' })

    -- Add or skip adding a new cursor by matching word/selection
    set({ 'n', 'x' }, { '<leader>mn', '<C-M-l>' }, function()
      mc.matchAddCursor(1)
    end, { desc = 'Add a new cursor by matching next word/selection (<C-M-l>)' })
    set({ 'n', 'x' }, { '<leader>mN', '<C-M-h>' }, function()
      mc.matchAddCursor(-1)
    end, { desc = 'Add a new cursor by matching previous word/selection (<C-M-h>)' })
    set({ 'n', 'x' }, { '<leader>ms' }, function()
      mc.matchSkipCursor(1)
    end, { desc = 'Skip adding a new cursor by matching next word/selection' })
    set({ 'n', 'x' }, { '<leader>mS' }, function()
      mc.matchSkipCursor(-1)
    end, { desc = 'Skip adding a new cursor by matching previous word/selection' })

    -- Add and remove cursors with control + left click.
    set('n', '<c-leftmouse>', mc.handleMouse, { desc = 'Add and remove cursors with control + left click' })
    set('n', '<c-leftdrag>', mc.handleMouseDrag, { desc = 'Add and remove cursors with control + left click' })
    set('n', '<c-leftrelease>', mc.handleMouseRelease, { desc = 'Add and remove cursors with control + left click' })

    -- Disable and enable cursors.
    set({ 'n', 'x' }, '<c-q>', mc.toggleCursor, { desc = 'Disable and enable cursors' })

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- Select a different cursor as the main one.
      layerSet({ 'n', 'x' }, '<left>', mc.prevCursor, { desc = 'Select previous cursor' })
      -- layerSet({ 'n', 'x' }, '<C-M-h>', mc.prevCursor, { desc = 'Select previous cursor' })
      layerSet({ 'n', 'x' }, '<right>', mc.nextCursor, { desc = 'Select next cursor' })
      -- layerSet({ 'n', 'x' }, '<C-M-l>', mc.nextCursor, { desc = 'Select next cursor' })

      -- Delete the main cursor.
      layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor, { desc = 'Delete the main cursor' })
      layerSet({ 'n', 'x' }, '<leader>mx', mc.deleteCursor, { desc = 'Delete the main cursor' })

      -- Enable and clear cursors using escape.
      layerSet('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = 'Enable and clear cursors using escape' })
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, 'MultiCursorCursor', { reverse = true })
    hl(0, 'MultiCursorVisual', { link = 'Visual' })
    hl(0, 'MultiCursorSign', { link = 'SignColumn' })
    hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
    hl(0, 'MultiCursorDisabledCursor', { reverse = true })
    hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
    hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
  end,
}
