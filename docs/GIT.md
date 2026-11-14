# Git

- Conventional commits, no scope, capitalized summary: `feat: Add keymaps for persisted sessions`. No `chore`.
- Every commit must start Neovim without errors.
- Never rewrite history without asking. Fix things with a new commit.
- Every change gets a new `agent/<topic>` branch, created from `agent/dev`.
- Ask before merging a topic branch into `agent/dev`.
- Never commit to or merge into `master`.
- Whenever commits get combined, keep unrelated changes in separate commits.
- You can push your own `agent/*` branch without asking. Ask before pushing any other branch.
- Ask before deleting a remote branch, even your own.
- Don't sync from upstream (`nvim-lua/kickstart.nvim`).
