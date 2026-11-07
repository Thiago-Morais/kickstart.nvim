-- Disabled
do
  return
end

vim.pack.add { 'https://github.com/junyixu/fcitx.nvim' }
require('fcitx').setup {
  -- enable_cmdline = true, -- also toggle when entering / or ?
}
