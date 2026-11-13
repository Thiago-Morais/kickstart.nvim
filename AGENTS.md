# AGENTS.md — kickstart.nvim

Personal Neovim config, forked from [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
and heavily customized. Installed as the `.config/nvim` submodule of
[Thiago-Morais/dotfiles](https://github.com/Thiago-Morais/dotfiles).

When this repo sits at `~/.config/nvim`, Pi also loads the dotfiles `AGENTS.md` from `$HOME`. For
anything inside this repo, **this file wins** (branch name, commit style and Lua style differ).

## Safety

Pi runs tools without asking for approval, so these rules are the only guardrail. Stop and ask in chat before:

- pushing anything, and always before force-pushing (even your own branch);
- deleting files, or editing anything outside this repository;
- running `:lua vim.pack.update()` or `vim.pack.del`, which change the installed plugins and the lockfile.

## Requirements

- Neovim **0.12+**: plugins are managed by the built-in `vim.pack`, not lazy.nvim.
- A Nerd Font (`vim.g.have_nerd_font = true`).

## Layout

Explore the tree with `ls`/`find` rather than assuming a structure. What the files won't tell you:

- `lua/kickstart/` came from upstream kickstart and `lua/custom/` is personal. Put new plugins and
  features under `custom/`, and keep `kickstart/` changes small so upstream syncs stay easy.
- Plugins are grouped into folders by purpose; each folder's `init.lua` requires its files, so a new
  file must be added there or it never loads.
- `lua/custom-extensions/` holds personal features that aren't plugins.
- Colors come from `~/.config/nvim/matugen.lua` (generated, see below); `tokyonight-night` is only the
  fallback when that file is missing.
- `README.md` and `doc/kickstart.txt` follow upstream; don't rewrite them for personal changes.

## Plugins with vim.pack

- **Everything loads at startup, in the order it's added.** No lazy loading. A plugin that depends on
  another must be required after it (e.g. mini.icons stands in for nvim-web-devicons, so it comes first).
  Check `pack-plugins.lua` and `custom/plugins/init.lua` before moving things.
- One plugin per file: `vim.pack.add { 'https://github.com/owner/repo' }`, then its setup in the same
  file, required from the right group's `init.lua`.
- No dots in file names (`smear-cursor.lua`): `require` treats dots as path separators.
- Commit `nvim-pack-lock.json` with the plugin change that modified it.
- Build steps go in `pack-build-hooks.lua`. Pass options through `setup`/`opts` rather than globals.

## Never commit

- `matugen.lua`: generated from the dotfiles template `.config/matugen/templates/neovim.lua`.
  Color changes go in that template, in the dotfiles repo.
- `.luarc.json`, `spell/`, `test.sh` (local, see `.gitignore`).

## Style

- `stylua` with `.stylua.toml`: **2 spaces**, single quotes, no call parentheses
  (`require 'options'`, `vim.pack.add { ... }`), 160 columns. Check with `stylua --check .`.
- Descriptive names; single letters only where common sense allows.
- Keymaps and user commands get a `desc`.

## Checking a change

- Run `stylua --check .` and `nvim --headless +qa`; startup must print no errors.
- A first start installs missing plugins from GitHub, which needs network access. If Neovim 0.12+ isn't
  available or startup can't finish where you're running (e.g. a sandbox without network), say so
  instead of reporting success, and list what the user should check (`:checkhealth vim.pack`).

## Upstream

- Upstream is `nvim-lua/kickstart.nvim` (`master`). Only sync if explicitly asked. When syncing, keep personal changes, resolve
  conflicts by hand, and don't commit leftover merge files.

## Commits and branches

- Conventional commits, **no scope**, capitalized imperative summary:
  `feat: Add keymaps for persisted sessions`, `fix: Correct misspelled smear-cursor option names`.
  `!` for breaking changes (`build!: Replace lazy.nvim with vim.pack`).
- No catch-all types like `chore`; use `feat`, `fix`, `refactor`, `style`, `docs`, `build`, `ci`, `perf`, `revert`.
- Split work so **every commit works on its own** (Neovim still starts without errors).
- Default branch is `master`. Never commit, push or merge to it directly; work on a new branch.
- After a change lands, the dotfiles repo needs its `.config/nvim` submodule pointer bumped.
