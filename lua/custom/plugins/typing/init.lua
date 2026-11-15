local M = {}

function M.setup()
  require('custom.plugins.typing.guess-indent').setup()
  require('custom.plugins.typing.blink').setup()
  require('custom.plugins.typing.lsp').setup()
  require('custom.plugins.typing.csvview').setup()
  require('custom.plugins.typing.languagetool').setup()
  require('custom.plugins.typing.lorem').setup()
  require('custom.plugins.typing.multicursor').setup()
  require('custom.plugins.typing.refactoring').setup()
  require('custom.plugins.typing.text-case').setup()
  -- require('custom.plugins.typing.comment').setup()
  -- require('custom.plugins.typing.fcitx').setup()
end

return M
