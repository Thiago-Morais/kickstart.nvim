# Plugins and layout

- `lua/kickstart/` is upstream's and `lua/custom/` is personal. Put new plugins and features under `custom/`, and keep `kickstart/` changes small.
- Personal features that aren't plugins live apart from the plugin folders.
- Plugins are grouped into folders by purpose. Each folder's `init.lua` requires its files, so a new file must be required there or it never loads.
- Plugins load in the order they're required, so a plugin must come after the plugins it depends on.
- One plugin per file: `vim.pack.add { 'https://github.com/owner/repo' }`, then its setup in the same file.
- No dots in file names: `require` treats dots as path separators.
- Configure plugins through `setup`/`opts` rather than globals.
- Build steps are registered in one place, before the first `vim.pack.add`, because a fresh start installs every plugin in the lockfile on that first call.
- Commit the `vim.pack` lockfile with the plugin change that modified it.
- Colors come from a `matugen.lua` generated outside this repo. Don't create or edit it.
- `README.md` and `doc/kickstart.txt` are upstream's; don't rewrite them for personal changes.
