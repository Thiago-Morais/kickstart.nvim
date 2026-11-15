# Lua

- Lua changes must pass the StyLua that Mason installs, never a system-wide one. From the repo root: `"${XDG_DATA_HOME:-$HOME/.local/share}/${NVIM_APPNAME:-nvim}/mason/bin/stylua" --check .`
- Descriptive names; single letters only where common sense allows.
- No silent fallbacks in new code: let failures surface instead of hiding them behind defaults or an empty `pcall`.
- Keymaps and user commands get a `desc`.
