-- [[ Basic Keymaps ]]
--
-- Remap existing commands
vim.keymap.set('v', 'p', 'P')
vim.keymap.set('v', 'P', 'p')
vim.keymap.set('n', 'vv', 'V')
vim.keymap.set('n', 'd', '"_d')
vim.keymap.set('n', 'D', '"_D')
vim.keymap.set('n', 'S', '"_S')
vim.keymap.set('n', 'c', '"_c')
vim.keymap.set('n', 'x', '"_x')
vim.keymap.set('n', 'dd', 'dd')
--  Move focus
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- Move window
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })
-- Resize window
vim.keymap.set('n', '<C-S-.>', '<C-w>>')
vim.keymap.set('n', '<C-S-,>', '<C-w><')
vim.keymap.set('n', '<C-S-=>', '<C-w>+')
vim.keymap.set('n', '<C-S-->', '<C-w>-')

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
--
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>nt', '<cmd>tabnew %<CR>', { desc = 'Open a [N]ew [T]ab page with the current file' })

vim.keymap.set('n', '<leader>wt', '<cmd>split | terminal<CR>', { desc = 'Open a new [W]indow with a [T]erminal' })

-- [[ Complex Keymaps ]]

vim.keymap.set('n', '<leader>nw', function()
  local shell = vim.env.SHELL
  vim.fn.jobstart({
    'alacritty',
    '-e',
    shell,
    '-c',
    'nvim;' .. shell,
  }, { detach = true })
end, { desc = '[N]ew application [W]indow with CWD' })

vim.keymap.set('n', '<leader>cfr', function()
  local path = vim.fn.expand '%'
  vim.fn.setreg('+', path)
  vim.notify('Copied path:' .. path)
end, { desc = "[C]opy [F]ile's [R]elative path" })

vim.keymap.set({ 'n', 'x' }, '<leader>cfa', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.notify('Copied path:' .. path)
end, { desc = "[C]opy [F]ile's [A]bsolute path" })

vim.keymap.set({ 'n', 'x' }, '<leader>cff', function()
  local path = vim.fn.expand '%:f'
  vim.fn.setreg('+', path)
  vim.notify('Copied path:' .. path)
end, { desc = "[C]opy [F]ile's [F]ilename" })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
