# AGENTS.md

You're working on a personal Neovim config, forked from kickstart.nvim and heavily customized, that manages plugins with the built-in `vim.pack` (Neovim 0.12+), not lazy.nvim.

## Safety

Stop and ask in chat before:

- deleting files.
- running `:lua vim.pack.update()` or `vim.pack.del`, which change the installed plugins and the lockfile.

## Every task

- Discuss proposed changes before editing, unless asked to make them.
- Check every claim about tools, docs or the environment before writing it: run it, read the source, or search the web. If something can't be checked where you are, say so.
- Comment only code that is counterintuitive or complex, in any file type.
- `docs/HANDOFF.md` (gitignored) passes state between agents. Read it before starting and check its claims against the repo. Before stopping, rewrite it following [docs/HANDOFF-FORMAT.md](docs/HANDOFF-FORMAT.md).

## Checking a change

From the repo root, `nvim --headless +qa` must print no errors.

## Plan Mode

- Make the plan extremely concise. Sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.

## Docs

- [docs/PLUGINS.md](docs/PLUGINS.md): adding, moving or configuring plugins, and where files go
- [docs/LUA.md](docs/LUA.md): writing and checking Lua
- [docs/GIT.md](docs/GIT.md): committing, branching, pushing
- [docs/MARKDOWN.md](docs/MARKDOWN.md): writing Markdown
- [docs/SANDBOX.md](docs/SANDBOX.md): working inside Docker Sandboxes (`$SANDBOX_NAME` is set)
- [docs/PI.md](docs/PI.md): the Pi harness
