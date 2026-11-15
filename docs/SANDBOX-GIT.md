Only `objects/`, the `agent/*` branches (and their reflogs) and this worktree's gitdir are writable. The rest of the shared git dir is read-only, so:

- `git commit` and `git switch -c` may print "Unable to create …/packed-refs.lock: Read-only file system". They still succeeded, so don't retry; confirm with `git log -1`.
- Branches can't be renamed or deleted. Create a new `agent/*` branch instead and ask the user to delete the old one on the host.
- `git fetch` can't update remote-tracking branches, and stashes and tags can't be created.
- Push and fetch over HTTPS, where the sandbox proxy adds the credentials. SSH fails here ("Host key verification failed").
