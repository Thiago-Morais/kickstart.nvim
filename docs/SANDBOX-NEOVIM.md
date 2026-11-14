# Neovim in the sandbox

- `HOME` is `/home/agent`, so a plain `nvim` finds no config and exits 0 without loading anything. Always set `XDG_CONFIG_HOME="$(dirname "$WORKSPACE_DIR")" NVIM_APPNAME="$(basename "$WORKSPACE_DIR")"`.
- `matugen.lua` doesn't exist here, so startup prints "A matugen style file was not found…". That message is expected.
- Plugins come from `vim.pack`, and Neovim's tools (LSP servers, DAP adapters, linters, formatters, StyLua) come from Mason. Use Mason's copies; don't install those tools another way.
- A fresh sandbox installs all of these in the background: see [SANDBOX-FIRST-RUN.md](SANDBOX-FIRST-RUN.md).
