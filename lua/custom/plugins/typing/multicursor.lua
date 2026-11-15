local M = {}

M.module = nil

function M.setup()
  vim.pack.add { { src = 'https://github.com/jake-stewart/multicursor.nvim', version = '1.0' } }
  M.module = require 'multicursor-nvim'
  M.module.setup()
  M.add_keymaps()
  M.set_multicursor_highlights()
  M.reload_highlights_on_color_scheme_change()
end

function M.add_keymaps()
  -- local set = vim.keymap.set
  local set = require('custom.keymap_extended').set

  -- Add or skip cursor above/below the main cursor.
  set({ 'n', 'x' }, { '<up>', '<C-M-k>' }, function()
    M.module.lineAddCursor(-1)
  end, { desc = 'Add cursor above [k] the main cursor (<C-M-k>)' })
  set({ 'n', 'x' }, { '<down>', '<C-M-j>' }, function()
    M.module.lineAddCursor(1)
  end, { desc = 'Add cursor below [j] the main cursor (<C-M-j>)' })
  set({ 'n', 'x' }, { '<leader><up>', '<leader>mK' }, function()
    M.module.lineSkipCursor(-1, { skipEmpty = false })
  end, { desc = 'Skip cursor above [k] the main cursor' })
  set({ 'n', 'x' }, { '<leader><down>', '<leader>mJ' }, function()
    M.module.lineSkipCursor(1, { skipEmpty = false })
  end, { desc = 'Skip cursor below [j] the main cursor' })

  vim.keymap.set('v', 'I', M.module.insertVisual)
  vim.keymap.set('v', 'A', M.module.appendVisual)

  set({ 'v' }, '<leader>ms', M.module.splitCursors, { desc = '[S]plit with regex as separator' })
  set({ 'v' }, '<leader>mm', M.module.splitCursors, { desc = 'Select only regex [M]atches' })
  set({ 'v' }, { '<leader>mr' }, function()
    M.module.transposeCursors(1)
  end, { desc = '[R]otate clockwise the contents of each visual selection for each cursor.' })
  set({ 'v' }, { '<leader>mR' }, function()
    M.module.transposeCursors(-1)
  end, { desc = '[R]otate anti-clockwise the contents of each visual selection for each cursor.' })
  set({ 'v' }, { '<leader>m<M-j>' }, function()
    M.module.swapCursors(1)
  end, { desc = '[R]otate clockwise the contents of each visual selection for each cursor.' })
  set({ 'v' }, { '<leader>m<M-k>' }, function()
    M.module.swapCursors(-1)
  end, { desc = '[R]otate anti-clockwise the contents of each visual selection for each cursor.' })

  -- Add or skip adding a new cursor by matching word/selection
  -- The first command select the word, the second select the next match
  local function selectThenKeymap(lhs, rhs, opts)
    set({ 'n' }, lhs, 'viw', opts)
    set({ 'x' }, lhs, rhs, opts)
  end

  selectThenKeymap({ '<leader>mn', '<C-M-l>' }, function()
    M.module.matchAddCursor(1, { skipEmpty = false })
  end, { desc = 'Add a [N]ew cursor by matching next word/selection (<C-M-l>)' })
  selectThenKeymap({ '<leader>mN', '<C-M-h>' }, function()
    M.module.matchAddCursor(-1, { skipEmpty = false })
  end, { desc = 'Add a [N]ew cursor by matching previous word/selection (<C-M-h>)' })
  selectThenKeymap({ '<leader>mL' }, function()
    M.module.matchSkipCursor(1)
  end, { desc = 'Skip adding a new cursor by matching next word/selection' })
  selectThenKeymap({ '<leader>mH' }, function()
    M.module.matchSkipCursor(-1)
  end, { desc = 'Skip adding a new cursor by matching previous word/selection' })
  selectThenKeymap('<leader>mA', M.module.matchAllAddCursors, { desc = 'Add a cursor for [A]ll matches of the word/selection under the cursor.' })

  set({ 'x', 'n' }, '<leader>m<c-a>', M.module.sequenceIncrement, { desc = 'Add to the number or alphabetic character in the highlighted text.' })
  set({ 'x', 'n' }, '<leader>m<c-x>', M.module.sequenceDecrement, { desc = 'Subtract from the number or alphabetic character in the highlighted text.' })

  -- Add and remove cursors with control + left click.
  set('n', '<c-leftmouse>', M.module.handleMouse, { desc = 'Add and remove cursors with control + left click' })
  set('n', '<c-leftdrag>', M.module.handleMouseDrag, { desc = 'Add and remove cursors with control + left click' })
  set('n', '<c-leftrelease>', M.module.handleMouseRelease, { desc = 'Add and remove cursors with control + left click' })

  -- Disable and enable cursors.
  set({ 'n', 'x' }, '<c-q>', M.module.toggleCursor, { desc = 'Disable and enable cursors' })

  -- Mappings defined in a keymap layer only apply when there are
  -- multiple cursors. This lets you have overlapping mappings.
  M.module.addKeymapLayer(function(layerSet)
    -- Select a different cursor as the main one.
    layerSet({ 'n', 'x' }, '<leader>mh', M.module.prevCursor, { desc = 'Select previous cursor' })
    layerSet({ 'n', 'x' }, '<leader>mk', M.module.prevCursor, { desc = 'Select previous cursor' })
    layerSet({ 'n', 'x' }, '<leader>ml', M.module.nextCursor, { desc = 'Select next cursor' })
    layerSet({ 'n', 'x' }, '<leader>mj', M.module.nextCursor, { desc = 'Select next cursor' })

    layerSet({ 'n', 'x' }, '<leader>ma', M.module.alignCursors, { desc = 'Align cursors' })

    -- Delete the main cursor.
    layerSet({ 'n', 'x' }, '<leader>mx', M.module.deleteCursor, { desc = 'Delete the main cursor' })

    -- Enable and clear cursors using escape.
    layerSet('n', '<esc>', function()
      if not M.module.cursorsEnabled() then
        M.module.enableCursors()
      else
        M.module.clearCursors()
      end
    end, { desc = 'Enable and clear cursors using escape' })
  end)
end

function M.set_multicursor_highlights()
  -- Customize how cursors look.
  local hl = vim.api.nvim_set_hl
  hl(0, 'MultiCursorCursor', { reverse = true })
  hl(0, 'MultiCursorVisual', { link = 'Visual' })
  hl(0, 'MultiCursorSign', { link = 'SignColumn' })
  hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
  hl(0, 'MultiCursorDisabledCursor', { reverse = true })
  hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
  hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
end

function M.reload_highlights_on_color_scheme_change()
  vim.api.nvim_create_autocmd('ColorScheme', { callback = M.set_multicursor_highlights })
end

return M
