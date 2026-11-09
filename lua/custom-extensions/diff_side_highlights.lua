-- Colour each side of a plain two-window diff (gitsigns diffthis, fugitive :Gvdiffsplit)
-- the way the Diffview hook does: the older side in red, the newer side in green.
-- Which side is older comes from git history, so diffs against other branches or
-- newer commits are coloured correctly. Diffs with no history order use left = old.
-- The highlight groups come from the matugen Neovim template.
--
-- Functions live in `M` so the file reads top-down: setup, then the main logic,
-- then the details. They're looked up when called, so their order doesn't matter;
-- `M.setup()` runs last, once everything is defined.

local M = {}

local old_side_winhighlight = 'DiffText:DiffviewDiffAddAsDelete,DiffChange:DiffviewLineChangeDiffDelete'
local new_side_winhighlight = 'DiffText:DiffviewDiffAdd,DiffChange:DiffviewLineChangeDiffAdd'

-- Window variable holding a window's own winhighlight while this file overrides it
local saved_winhighlight_variable = 'diff_side_previous_winhighlight'

-- Diffs that colour themselves. Matched against each diff window's buffer name.
local ignored_buffer_name_patterns = {
  '^diffview://', -- Diffview, coloured by its diff_buf_win_enter hook
}

-- The index and the file on disk both build on HEAD: the index adds staged changes,
-- and the file on disk adds unstaged changes on top of those.
local changes_on_top_of_base = { commit = 0, index = 1, file_on_disk = 2 }

---@class DiffSide
---@field kind 'commit'|'index'|'file_on_disk'
---@field revision? string Commit-ish, for `kind = 'commit'`
---@field git_dir? string Repository the revision belongs to

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

function M.setup()
  M.set_fallback_highlights()

  local augroup = vim.api.nvim_create_augroup('diff-side-highlights', { clear = true })

  -- `:colorscheme` clears all highlight groups, so set the fallbacks again
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = augroup,
    callback = M.set_fallback_highlights,
  })

  -- A window entered or left diff mode (:diffthis, :diffoff)
  vim.api.nvim_create_autocmd('OptionSet', {
    group = augroup,
    pattern = 'diff',
    callback = M.schedule_update_diff_highlights,
  })

  -- The windows or buffers involved changed
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinClosed', 'TabEnter' }, {
    group = augroup,
    callback = M.schedule_update_diff_highlights,
  })
end

-- Wait until both diff windows are set up (or a closed window is gone) before updating
function M.schedule_update_diff_highlights()
  vim.schedule(M.update_diff_highlights)
end

--------------------------------------------------------------------------------
-- Main logic
--------------------------------------------------------------------------------

function M.update_diff_highlights()
  local diff_windows = M.get_diff_windows()
  local old_window, new_window = M.get_old_new_windows(diff_windows)
  M.try_restore_highlights()
  M.try_apply_highlights(old_window, new_window)
end

function M.get_diff_windows()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  return (vim.tbl_filter(function(window)
    return vim.wo[window].diff
  end, windows))
end

function M.get_old_new_windows(diff_windows)
  -- Only a two-window diff has a single old and new side (a merge has three or four)
  local old_window, new_window
  if #diff_windows == 2 and not M.has_ignored_window(diff_windows) then
    old_window, new_window = M.order_by_history(diff_windows[1], diff_windows[2])
    if not old_window then
      old_window, new_window = M.order_by_position(diff_windows[1], diff_windows[2])
    end
  end
  return old_window, new_window
end

-- Undo this file's colours in every window, so a window only keeps them while it's
-- part of a diff this file colours (not after :diffoff, or in a merge or Diffview diff).
-- Only windows this file coloured are affected; the current diff is coloured again right after.
function M.try_restore_highlights()
  for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    M.try_restore_side_highlight(window)
  end
end

function M.try_apply_highlights(old_window, new_window)
  if old_window then
    M.apply_side_highlight(old_window, old_side_winhighlight)
  end
  if new_window then
    M.apply_side_highlight(new_window, new_side_winhighlight)
  end
end

---@param windows integer[]
function M.has_ignored_window(windows)
  for _, window in ipairs(windows) do
    local buffer_name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(window))
    for _, pattern in ipairs(ignored_buffer_name_patterns) do
      if buffer_name:match(pattern) then
        return true
      end
    end
  end
  return false
end

--------------------------------------------------------------------------------
-- Which side is older
--------------------------------------------------------------------------------

-- Order two diff windows by git history. Returns old_window, new_window,
-- or nothing when history has no order (diverged branches, two plain files).
---@param first_window integer
---@param second_window integer
---@return integer?, integer?
function M.order_by_history(first_window, second_window)
  local first_side, second_side = M.as_diffside(first_window), M.as_diffside(second_window)
  if not first_side or not second_side then
    return nil
  end
  local git_dir = first_side.git_dir or second_side.git_dir
  if not git_dir then
    return nil
  end

  local first_base, second_base = M.try_get_base_commit(git_dir, first_side), M.try_get_base_commit(git_dir, second_side)
  if not first_base or not second_base then
    return nil
  end

  if first_base == second_base then
    local first_changes, second_changes = changes_on_top_of_base[first_side.kind], changes_on_top_of_base[second_side.kind]
    if first_changes < second_changes then
      return first_window, second_window
    elseif second_changes < first_changes then
      return second_window, first_window
    end
    return nil
  end

  if M.is_ancestor(git_dir, first_base, second_base) then
    return first_window, second_window
  elseif M.is_ancestor(git_dir, second_base, first_base) then
    return second_window, first_window
  end
  return nil
end

-- Order two diff windows like `git diff left right`: the left (or top) window is old
---@param first_window integer
---@param second_window integer
---@return integer, integer
function M.order_by_position(first_window, second_window)
  local first_row, first_column = unpack(vim.api.nvim_win_get_position(first_window))
  local second_row, second_column = unpack(vim.api.nvim_win_get_position(second_window))
  local first_is_old
  if first_column ~= second_column then
    first_is_old = first_column < second_column
  else
    first_is_old = first_row <= second_row
  end

  if first_is_old then
    return first_window, second_window
  end
  return second_window, first_window
end

--------------------------------------------------------------------------------
-- Where each side of the diff comes from
--------------------------------------------------------------------------------

-- Where a diff window's content comes from, or nil if that can't be told
---@param window integer
---@return DiffSide?
function M.as_diffside(window)
  local bufnr = vim.api.nvim_win_get_buf(window)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)

  for _, parse_git_buffer in ipairs(M.git_buffer_parsers) do
    local git_dir, revision = parse_git_buffer(buffer_name)
    if git_dir and revision then
      return M.diffside_from_revision(git_dir, revision)
    end
  end

  if M.is_file_on_disk(bufnr) then
    return { kind = 'file_on_disk' }
  end
  return nil
end

-- Plugins that show a file as stored in git. Each parser reads one plugin's buffer name
-- and returns the git dir plus the revision (`:0` for the index), or nothing.
---@type (fun(buffer_name: string): (string?, string?))[]
M.git_buffer_parsers = {
  -- gitsigns://<git dir>//<revision>:<path>
  function(buffer_name)
    local git_dir, revision_and_path = buffer_name:match '^gitsigns://(.-)//(.+)$'
    if not git_dir then
      return nil
    end
    return git_dir, M.revision_from(revision_and_path)
  end,

  -- fugitive://…, read with fugitive's own parser: { '<revision>:<path>', '<git dir>' }
  function(buffer_name)
    if not buffer_name:match '^fugitive://' or vim.fn.exists '*FugitiveParse' == 0 then
      return nil
    end
    local parsed_ok, parsed = pcall(vim.fn.FugitiveParse, buffer_name)
    if not parsed_ok or parsed[1] == '' then
      return nil
    end
    local revision_and_path, git_dir = parsed[1], parsed[2]
    return git_dir, M.revision_from(revision_and_path)
  end,
}

-- The revision part of `<revision>:<path>`. The index revision `:0` (and the merge
-- stages `:1` to `:3`) contain a colon themselves, so they need their own pattern.
---@param revision_and_path string
---@return string?
function M.revision_from(revision_and_path)
  return revision_and_path:match '^(:%d):' or revision_and_path:match '^([^:]+):'
end

-- Turn a revision from a buffer name into a diff side.
-- `:0` is the index; `:1` to `:3` are merge conflict stages, which have no before/after.
---@param git_dir string
---@param revision string
---@return DiffSide?
function M.diffside_from_revision(git_dir, revision)
  if revision == ':0' then
    return { kind = 'index', git_dir = git_dir }
  end
  local is_merge_stage = revision:match '^:%d$' ~= nil
  if is_merge_stage then
    return nil
  end
  return { kind = 'commit', revision = revision, git_dir = git_dir }
end

-- A real file: a normal buffer with a name that isn't a plugin URL like `oil://…`
---@param bufnr integer
function M.is_file_on_disk(bufnr)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)
  local is_normal_buffer = vim.bo[bufnr].buftype == ''
  local is_plugin_url = buffer_name:match '^%a+://' ~= nil
  return is_normal_buffer and buffer_name ~= '' and not is_plugin_url
end

--------------------------------------------------------------------------------
-- Git helpers
--------------------------------------------------------------------------------

-- The commit a side builds on, as a full hash
---@param git_dir string
---@param side DiffSide
---@return string?
function M.try_get_base_commit(git_dir, side)
  local commitish = side.revision or 'HEAD'
  local resolved, commit = M.run_git(git_dir, { 'rev-parse', '--verify', '--quiet', commitish .. '^{commit}' })
  if not resolved then
    return nil
  end
  return commit
end

---@param git_dir string
---@param possible_ancestor string
---@param commit string
function M.is_ancestor(git_dir, possible_ancestor, commit)
  local is_ancestor_commit = M.run_git(git_dir, { 'merge-base', '--is-ancestor', possible_ancestor, commit })
  return is_ancestor_commit
end

---@param git_dir string
---@param args string[]
---@return boolean succeeded, string output
function M.run_git(git_dir, args)
  local result = vim.system(vim.list_extend({ 'git', '--git-dir', git_dir }, args), { text = true }):wait()
  return result.code == 0, vim.trim(result.stdout or '')
end

--------------------------------------------------------------------------------
-- Highlights
--------------------------------------------------------------------------------

function M.apply_side_highlight(window, winhighlight)
  if vim.w[window][saved_winhighlight_variable] == nil then
    vim.w[window][saved_winhighlight_variable] = vim.wo[window].winhighlight
  end
  vim.wo[window].winhighlight = winhighlight
end

-- Puts back the winhighlight saved by apply_side_highlight; no saved value means this
-- file never coloured the window, so there is nothing to undo
function M.try_restore_side_highlight(window)
  local saved_winhighlight = vim.w[window][saved_winhighlight_variable]
  if saved_winhighlight ~= nil then
    vim.wo[window].winhighlight = saved_winhighlight
    vim.w[window][saved_winhighlight_variable] = nil
  end
end

-- Diffview defines the DiffText groups itself, but the changed-line groups only come
-- from matugen. Fall back to the plain diff colours when matugen hasn't generated its
-- theme; `default = true` keeps matugen's colours when it does define them.
function M.set_fallback_highlights()
  vim.api.nvim_set_hl(0, 'DiffviewLineChangeDiffDelete', { link = 'DiffDelete', default = true })
  vim.api.nvim_set_hl(0, 'DiffviewLineChangeDiffAdd', { link = 'DiffAdd', default = true })
end

M.setup()

return M
