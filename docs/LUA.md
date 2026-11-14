# Lua

- Lua changes must pass the StyLua that Mason installs, never a system-wide one. From the repo root: `"${XDG_DATA_HOME:-$HOME/.local/share}/$(basename "$PWD")/mason/bin/stylua" --check .` (the folder name is the `NVIM_APPNAME`, which picks Mason's data dir).
- Descriptive names; single letters only where common sense allows.
- No silent fallbacks in new code: let failures surface instead of hiding them behind defaults or an empty `pcall`.
- Keymaps and user commands get a `desc`.
