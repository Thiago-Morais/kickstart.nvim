# AGENTS.md

You're working on a personal Neovim config, forked from kickstart.nvim and heavily customized, that manages plugins with the built-in `vim.pack` (Neovim 0.12+), not lazy.nvim.

## Safety

Stop and ask in chat before:

- deleting files.
- running `:lua vim.pack.update()` or `vim.pack.del`, which change the installed plugins and the lockfile.

## Startup

On the user's first message, read [docs/STARTUP.md](docs/STARTUP.md)

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

## Environment documents

- [docs/SANDBOX.md](docs/SANDBOX.md): if working inside Docker Sandboxes, read this document (`$SANDBOX_NAME` is set)
- [docs/PI.md](docs/PI.md): if working within Pi, read this document (`$PI_*` are set)

## Docs

- [docs/GIT.md](docs/GIT.md): before anything involving git
- [docs/LUA.md](docs/LUA.md): before work with Lua
- [docs/PLUGINS.md](docs/PLUGINS.md): before working with Neovim plugins
- [docs/MARKDOWN.md](docs/MARKDOWN.md): before working with Markdown
