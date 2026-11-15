# ADR-0001: The Mason startup step uses `+cmd` arguments instead of `-l`

**Date**: 2026-11-15
**Status**: accepted
**Deciders**: Thiago, Pi agent

## Context

The `nvim-tools` kit runs a background startup step that installs the config's Mason tools. It ran `:MasonToolsInstallSync` from a Lua script passed with `-l`. Neovim fires VimEnter before an `-l` script runs, so mason-tool-installer's own VimEnter run started first, and Sync ran alongside it. On a fresh install, Sync skipped the packages the first run was installing and waited for them forever, so the step never finished.

## Decision

We run `nvim --headless +MasonToolsInstallSync +qa`. VimEnter fires after the `+cmd`s, so `+qa` quits before mason-tool-installer's own run starts, and only Sync installs.

## Alternatives Considered

### Alternative 1: Keep `-l` and wait for mason-tool-installer's own run (`agent/mason-install-hang`)
- **Pros**: no second run; also waits for installs started elsewhere (mason-nvim-dap's) and fails instead of hanging
- **Cons**: more code in the kit, built around the order in which the plugins start their installs
- **Why not**: the `+cmd` change fixes the hang with a one-line command

## Consequences

### Positive
- A fresh install finishes: exit 0 in 51 s, each of the 12 tools installed once

### Negative
- delve, started by mason-nvim-dap, is aborted at `+qa`, and Mason prints an abort error
- `+qa` exits 0 even after a Lua error, so the step doesn't report failures

### Risks
- It depends on Neovim firing VimEnter after `+cmd`s. If that order changes, the hang comes back
