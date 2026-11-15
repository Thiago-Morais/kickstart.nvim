# Git

- Conventional commits, no scope, capitalized summary: `feat: Add keymaps for persisted sessions`. No `chore`.
  - Exception: changes to agent docs use `docs(agents):`. Agent docs are `AGENTS.md` and every doc reachable from it through Markdown links, wherever they live. Docs for humans keep `docs:`.
- Every commit must start Neovim without errors.
- Never rewrite history without asking. Fix things with a new commit.
- Every change gets a new `agent/<topic>` branch, created from `agent/dev`.
- Each branch should be limited to its own scope. Multiple scopes require multiple branches.
- Ask before merging a topic branch into `agent/dev`.
- Never commit to or merge into `master`.
- Whenever commits get combined, keep unrelated changes in separate commits.
- You can push your own `agent/*` branch without asking. Ask before pushing any other branch.
- Ask before deleting a remote branch, even your own.
- Don't sync from upstream (`nvim-lua/kickstart.nvim`).
