# ADR-0002: Pi's config dir lives in the agent worktree

**Date**: 2026-11-15
**Status**: accepted
**Deciders**: Thiago, Pi agent

## Context

Pi keeps its packages and their config in `~/.pi/agent`, which is lost when the sandbox is recreated. pi-web-access needs a `web-search.json` with `ssrf.trustEnvProxy: true`, because the sandbox only resolves allowed domains through the proxy. A postCreate step reinstalled the package but couldn't keep its config.

## Decision

`sbxenv.yaml` mounts `.pi-agent/` from the agent worktree at `/home/agent/.pi/agent`, Pi's default config dir. `settings.json` and `web-search.json` are tracked there; everything else in it is gitignored. The postCreate install step is gone, since Pi installs the packages in `settings.json` at startup.

## Alternatives Considered

### Alternative 1: Copy `web-search.json` into `~/.pi/agent` in postCreate

- **Pros**: sessions and caches stay outside the worktree
- **Cons**: two postCreate steps to keep in sync; packages installed by hand inside the sandbox are lost on recreate
- **Why not**: one mount keeps the whole config, and changes to it go through git

### Alternative 2: Point `PI_CODING_AGENT_DIR` at the worktree

- **Why not**: the only host path available is `${{ env.fileDir }}/../nvim-agent/.pi-agent`. Neither `sbx` nor Pi normalizes the `..`, and `fileDir` (the main worktree) isn't mounted, so the path doesn't resolve inside the sandbox

### Alternative 3: Mount `./.pi-agent` from the main worktree

- **Why not**: the agent would write straight into the user's working copy instead of going through an `agent/*` branch

### Alternative 4: Name the dir `.pi`

- **Why not**: Pi reads `.pi/` in the project as project settings

## Consequences

### Positive

- `pi install` inside the sandbox writes to the tracked `settings.json`, so new packages persist once committed
- Sessions persist across recreates too (gitignored)

### Negative

- Pi may write its own keys (e.g. `lastChangelogVersion`) into the tracked `settings.json`

### Risks

- `auth.json` lives in the worktree. Pi creates it empty since the proxy injects credentials, but a `/login` would store real tokens there. It's gitignored
