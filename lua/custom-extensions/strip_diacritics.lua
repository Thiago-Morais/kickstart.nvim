-- Replace accented characters with plain ASCII letters.
-- Provides :StripDiacritics, :StripDiacriticsMatching and a keymap.

local char_to_accented_map = {
  { plain = 'a', accented = 'àáâãäåāăą' },
  { plain = 'A', accented = 'ÀÁÂÃÄÅĀĂĄ' },
  { plain = 'c', accented = 'çćĉċč' },
  { plain = 'C', accented = 'ÇĆĈĊČ' },
  { plain = 'd', accented = 'ďđ' },
  { plain = 'D', accented = 'ĎĐ' },
  { plain = 'e', accented = 'èéêëēĕėęě' },
  { plain = 'E', accented = 'ÈÉÊËĒĔĖĘĚ' },
  { plain = 'g', accented = 'ĝğġģ' },
  { plain = 'G', accented = 'ĜĞĠĢ' },
  { plain = 'i', accented = 'ìíîïĩīĭįı' },
  { plain = 'I', accented = 'ÌÍÎÏĨĪĬĮİ' },
  { plain = 'l', accented = 'ĺļľł' },
  { plain = 'L', accented = 'ĹĻĽŁ' },
  { plain = 'n', accented = 'ñńņň' },
  { plain = 'N', accented = 'ÑŃŅŇ' },
  { plain = 'o', accented = 'òóôõöøōŏő' },
  { plain = 'O', accented = 'ÒÓÔÕÖØŌŎŐ' },
  { plain = 'r', accented = 'ŕŗř' },
  { plain = 'R', accented = 'ŔŖŘ' },
  { plain = 's', accented = 'śŝşš' },
  { plain = 'S', accented = 'ŚŜŞŠ' },
  { plain = 't', accented = 'ţťŧ' },
  { plain = 'T', accented = 'ŢŤŦ' },
  { plain = 'u', accented = 'ùúûüũūŭůűų' },
  { plain = 'U', accented = 'ÙÚÛÜŨŪŬŮŰŲ' },
  { plain = 'y', accented = 'ýÿ' },
  { plain = 'Y', accented = 'ÝŸ' },
  { plain = 'z', accented = 'źżž' },
  { plain = 'Z', accented = 'ŹŻŽ' },
}

local accented_to_char_map = {}
for _, c2a_map_entry in ipairs(char_to_accented_map) do
  for _, accented_character in ipairs(vim.fn.split(c2a_map_entry.accented, [[\zs]])) do
    accented_to_char_map[accented_character] = c2a_map_entry.plain
  end
end

local function strip_diacritics(text)
  -- Remove standalone combining marks (U+0300-U+036F) first, because Vim
  -- shows a letter plus its combining mark as a single character.
  local without_combining_marks = vim.fn.substitute(text, [=[[\u0300-\u036f]]=], '', 'g')

  local characters = vim.fn.split(without_combining_marks, [[\zs]])
  for index, character in ipairs(characters) do
    characters[index] = accented_to_char_map[character] or character
  end

  return table.concat(characters)
end

-- Exposed globally so :substitute can call it through v:lua.
_G.strip_diacritics = strip_diacritics

vim.api.nvim_create_user_command('StripDiacritics', function(command_args)
  local buffer_lines = vim.api.nvim_buf_get_lines(0, command_args.line1 - 1, command_args.line2, false)
  for line_index, line in ipairs(buffer_lines) do
    buffer_lines[line_index] = strip_diacritics(line)
  end
  vim.api.nvim_buf_set_lines(0, command_args.line1 - 1, command_args.line2, false, buffer_lines)
end, { range = '%', desc = 'Strip discritics within line range' })

-- Strip diacritics only inside text matched by a Vim pattern.
-- Example: :StripDiacriticsMatching \v"id": "\zs[^"]+\ze"
vim.api.nvim_create_user_command('StripDiacriticsMatching', function(command_args)
  local escaped_pattern = command_args.args:gsub('/', '\\/')
  -- Runs a `s//ge` substitution on the range using `strip_diacritics()`
  vim.cmd(([[%d,%ds/%s/\=v:lua.strip_diacritics(submatch(0))/ge]]):format(command_args.line1, command_args.line2, escaped_pattern))
end, { nargs = 1, range = '%', desc = 'Strip diacritics inside matches of a pattern' })

vim.keymap.set({ 'n', 'v' }, '<leader>sd', ':StripDiacritics<CR>', { desc = 'Strip diacritics' })
