# Git worktrees

- Need a separate checkout (e.g. a fix branched from the default branch while the main checkout has uncommitted changes): use the `EnterWorktree` tool. It creates `.claude/worktrees/<name>/` from the remote default branch; return with `ExitWorktree`
- `EnterWorktree` cannot take a branch name. To work on a specific existing branch, run `git worktree add .claude/worktrees/<name> <branch>`, then call `EnterWorktree` with that `path`
- Never create worktrees in the scratchpad or `/tmp`: `~/.claude/settings.json` denies `Read(**/tmp/**)` and `Edit(**/tmp/**)` (the scratchpad lives under `/private/tmp`), and paths outside the working directory need approval for other operations too. Place one outside the repository only when the user asks
- While inside a worktree, the main checkout is blocked; `ExitWorktree` before touching it
- Decide whether and how to use a worktree while planning and write it in the plan. If execution needs a different method, tell the user before switching
