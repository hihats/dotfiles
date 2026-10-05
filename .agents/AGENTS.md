# AGENTS.md

This file provides guidance to Code Agent(e.g. claude.ai/code) when working with code in this machine globally.

## Must
### Coding
- Always plan mode
- When requested to conduct an investigation, always consult official documentation first and ensure that the source is cited at the end of the findings.
- Write
  * In code, write How
  * In test code, write What
  * In commit logs, write Why(For changes only)
  * In code comments, write Why not
- Keep the Cyclomatic Complexity within 5
- For every function/class you write or modify, assess cohesion (single responsibility) and coupling (dependencies on other modules/classes); flag and justify when either looks poor

### Design and Planning
- Product Backlog Items must satisfy INVEST; tasks must satisfy SMART. Use the `invest` skill when creating, splitting, or reviewing them

### General
- Check to see if there are any inconsistencies with previous conversations, and if there are, be honest about them
- At the end of the response, explicitly state whether there were any signs of sycophancy

## Recommend
> Note: These are personal guidelines, not official recommendations.
- Content intended for humans should be written in README
- Content intended for both humans and AI should be written in both README & AGENTS.md (CLAUDE.md)
  * However, vary the level of detail

  - README: Human-facing details (usage, concrete examples, background explanation)
  - CLAUDE.md: Only the key points AI needs to make work decisions

  For example, Rate Limits should be documented in both CLAUDE.md and README.
  However, for README, a high-level explanation like "these limitations exist" is sufficient,
  while CLAUDE.md needs implementation-level details like "use this sleep value when writing code"

## Toolchain
### Python
- pyenv is the global Python (bare `python` outside projects); uv is the per-project tool. They coexist by design — do not propose removing pyenv or changing its global settings
- Inside a uv project, run via `uv run` or the direnv-activated `.venv`. Never `pip install` into the global interpreter
- Leave uv's Python to uv's own managed installations; do not set `python-preference`, `uv python pin --global`, or `uv python install --default`
- When creating a uv project, add `.envrc` containing `layout uv` (defined in `.config/direnv/direnvrc`) so bare `python` resolves to `.venv` instead of a pyenv shim

## Tool-specific rules
- Claude Code: tool-specific instructions live in `~/.claude/rules/` (managed in this repo's `.claude/rules/`), e.g. `worktree.md` for when to use `EnterWorktree` vs `git worktree add`. They load every session alongside this file
