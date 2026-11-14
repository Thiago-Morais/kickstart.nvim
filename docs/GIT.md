# Git

- Conventional commits, no scope, capitalized summary: `feat: Add keymaps for persisted sessions`. No `chore`.
- Every commit must start Neovim without errors.
- Work on an `agent/<topic>` branch. Never commit to or merge into `master`.
- Whenever commits get combined, keep unrelated changes in separate commits.
- You can push your own `agent/*` branch without asking. Ask before pushing any other branch.
- Ask before force-pushing to any branch including your own.
- Don't sync from upstream (`nvim-lua/kickstart.nvim`).
