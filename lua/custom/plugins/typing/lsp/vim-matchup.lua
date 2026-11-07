vim.pack.add { 'https://github.com/andymass/vim-matchup' }

---@type matchup.Config
require('match-up').setup {
  treesitter = {
    stopline = 500,
  },
}
