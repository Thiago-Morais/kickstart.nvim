local module_prefix = ...
local current_directory = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))

for file_name, file_type in vim.fs.dir(current_directory) do
  local module_name = file_name:match '^(.+)%.lua$'
  if file_type == 'file' and module_name and module_name ~= 'init' then
    require(module_prefix .. '.' .. module_name)
  end
end
