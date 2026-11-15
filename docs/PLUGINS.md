# Plugins and layout

- `lua/kickstart/` is upstream's and `lua/custom/` is personal. Put new plugins and features under `custom/`, and keep `kickstart/` changes small.
- Personal features that aren't plugins live apart from the plugin folders.
- Plugins use a module pattern: `local M = {}`, then `M.setup()` with the `vim.pack.add` and the plugin's config, then `return M`. Requiring a module must not run anything.
- A plugin's keymaps go in `M.add_keymaps()`, called at the end of `M.setup()`.
- Plugins are grouped into folders by purpose. Each folder's `init.lua` is a module whose `setup()` calls its files' `setup()`, so a new file must be added there or it never loads.
- Plugins load in the order their `setup()` is called, so a plugin must come after the plugins it depends on.
- To disable a plugin, comment out its `setup()` call.
- No dots in file names: `require` treats dots as path separators.
- Configure plugins through `setup`/`opts` rather than globals.
- Build steps are registered in one place, before the first `vim.pack.add`, because a fresh start installs every plugin in the lockfile on that first call.
- Commit the `vim.pack` lockfile with the plugin change that modified it.
- Colors come from a `matugen.lua` generated outside this repo. Don't create or edit it.
- `README.md` and `doc/kickstart.txt` are upstream's; don't rewrite them for personal changes.
