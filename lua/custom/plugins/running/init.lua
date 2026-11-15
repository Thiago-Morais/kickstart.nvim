local M = {}

function M.setup()
  require('custom.plugins.running.live-preview').setup()
  require('custom.plugins.running.live-server').setup()
  require('custom.plugins.running.markdown-preview').setup()
  -- Disabled to keep markdown syntax visible
  -- require('custom.plugins.running.render-markdown').setup()
end

return M
