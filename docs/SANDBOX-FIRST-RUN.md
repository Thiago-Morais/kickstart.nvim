# Sandbox first run

On every sandbox start, the `nvim-tools` kit runs a background step that starts Neovim headless with this config and runs `:MasonToolsInstallSync`. On a fresh sandbox, that step:

1. installs every plugin in the `vim.pack` lockfile from GitHub and runs their build steps;
2. installs the Mason tools (LSP servers, DAP adapters, linters, formatters, StyLua, the tree-sitter CLI).

Until it finishes, plugins or StyLua may be missing and the startup check may fail.

- Check whether it's still running: `pgrep -af MasonToolsInstallSync`.
- If it isn't running and Mason's data dir (`~/.local/share/$(basename "$WORKSPACE_DIR")/mason`) doesn't exist, the step never ran, probably because the kit that `sbxenv.yaml` loads is outdated. Tell the user.
- A download blocked by the sandbox firewall gets HTTP 403, and the response body says what to ask the user. Pass that on; don't work around the firewall.

## Known failures

- markdown-preview's build fails with `ENOENT … 'yarn'`, because yarn isn't installed.
- Treesitter parsers don't get built. On the first run, the build hook runs before Mason installs the tree-sitter CLI. Later starts quit before the asynchronous parser install finishes. Until the parsers exist, every start, including the startup check, prints `Downloading tree-sitter-…` lines; they aren't errors.

If the step fails in any other way or can't finish, say so instead of reporting success, and ask the user to run `:checkhealth vim.pack`.
