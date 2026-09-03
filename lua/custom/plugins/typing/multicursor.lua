return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'
    mc.setup()

    -- local set = vim.keymap.set
    local set = require('custom.keymap_extended').set

    -- Add or skip cursor above/below the main cursor.
    set({ 'n', 'x' }, { '<up>', '<C-M-k>' }, function()
      mc.lineAddCursor(-1)
    end, { desc = 'Add cursor above [k] the main cursor (<C-M-k>)' })
    set({ 'n', 'x' }, { '<down>', '<C-M-j>' }, function()
      mc.lineAddCursor(1)
    end, { desc = 'Add cursor below [j] the main cursor (<C-M-j>)' })
    set({ 'n', 'x' }, { '<leader><up>', '<leader>mK' }, function()
      mc.lineSkipCursor(-1, { skipEmpty = false })
    end, { desc = 'Skip cursor above [k] the main cursor' })
    set({ 'n', 'x' }, { '<leader><down>', '<leader>mJ' }, function()
      mc.lineSkipCursor(1, { skipEmpty = false })
    end, { desc = 'Skip cursor below [j] the main cursor' })

    vim.keymap.set('v', 'I', mc.insertVisual)
    vim.keymap.set('v', 'A', mc.appendVisual)

    set({ 'v' }, '<leader>ms', mc.splitCursors, { desc = '[S]plit with regex as separator' })
    set({ 'v' }, '<leader>mm', mc.splitCursors, { desc = 'Select only regex [M]atches' })
    set({ 'v' }, { '<leader>mr' }, function()
      mc.transposeCursors(1)
    end, { desc = '[R]otate clockwise the contents of each visual selection for each cursor.' })
    set({ 'v' }, { '<leader>mR' }, function()
      mc.transposeCursors(-1)
    end, { desc = '[R]otate anti-clockwise the contents of each visual selection for each cursor.' })
    set({ 'v' }, { '<leader>m<M-j>' }, function()
      mc.swapCursors(1)
    end, { desc = '[R]otate clockwise the contents of each visual selection for each cursor.' })
    set({ 'v' }, { '<leader>m<M-k>' }, function()
      mc.swapCursors(-1)
    end, { desc = '[R]otate anti-clockwise the contents of each visual selection for each cursor.' })

    -- Add or skip adding a new cursor by matching word/selection
    -- The first command select the word, the second select the next match
    local function selectThenKeymap(lhs, rhs, opts)
      set({ 'n' }, lhs, 'viw', opts)
      set({ 'x' }, lhs, rhs, opts)
    end

    selectThenKeymap({ '<leader>mn', '<C-M-l>' }, function()
      mc.matchAddCursor(1, { skipEmpty = false })
    end, { desc = 'Add a [N]ew cursor by matching next word/selection (<C-M-l>)' })
    selectThenKeymap({ '<leader>mN', '<C-M-h>' }, function()
      mc.matchAddCursor(-1, { skipEmpty = false })
    end, { desc = 'Add a [N]ew cursor by matching previous word/selection (<C-M-h>)' })
    selectThenKeymap({ '<leader>mL' }, function()
      mc.matchSkipCursor(1)
    end, { desc = 'Skip adding a new cursor by matching next word/selection' })
    selectThenKeymap({ '<leader>mH' }, function()
      mc.matchSkipCursor(-1)
    end, { desc = 'Skip adding a new cursor by matching previous word/selection' })
    selectThenKeymap('<leader>mA', mc.matchAllAddCursors, { desc = 'Add a cursor for [A]ll matches of the word/selection under the cursor.' })

    set({ 'x', 'n' }, '<leader>m<c-a>', mc.sequenceIncrement, { desc = 'Add to the number or alphabetic character in the highlighted text.' })
    set({ 'x', 'n' }, '<leader>m<c-x>', mc.sequenceDecrement, { desc = 'Subtract from the number or alphabetic character in the highlighted text.' })

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
      layerSet({ 'n', 'x' }, '<leader>mh', mc.prevCursor, { desc = 'Select previous cursor' })
      layerSet({ 'n', 'x' }, '<leader>mk', mc.prevCursor, { desc = 'Select previous cursor' })
      layerSet({ 'n', 'x' }, '<leader>ml', mc.nextCursor, { desc = 'Select next cursor' })
      layerSet({ 'n', 'x' }, '<leader>mj', mc.nextCursor, { desc = 'Select next cursor' })

      layerSet({ 'n', 'x' }, '<leader>ma', mc.alignCursors, { desc = 'Align cursors' })

      -- Delete the main cursor.
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
