# /bin/bash

set -e

ln -sf ~/github/hihats/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/github/hihats/dotfiles/.bashrc ~/.bashrc
ln -sf ~/github/hihats/dotfiles/.zshenv ~/.zshenv
ln -sf ~/github/hihats/dotfiles/.zshrc ~/.zshrc
ln -sf ~/github/hihats/dotfiles/.vimrc ~/.vimrc
mkdir -p -m 700 ~/.ssh
ln -sf ~/github/hihats/dotfiles/.ssh/config ~/.ssh/config
ln -sf ~/github/hihats/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/github/hihats/dotfiles/.gitignore_global ~/.gitignore_global
ln -sf ~/github/hihats/dotfiles/.finicky.js ~/.finicky.js
ln -sf ~/github/hihats/dotfiles/.npmrc ~/.npmrc
mkdir -p ~/.claude
ln -sf ~/github/hihats/dotfiles/.claude/settings.json ~/.claude/settings.json
mkdir -p ~/.agents
ln -sf ~/github/hihats/dotfiles/.agents/AGENTS.md ~/.agents/AGENTS.md
mkdir -p ~/.claude/skills
ln -sfn ~/github/hihats/dotfiles/.agents/skills/invest ~/.claude/skills/invest
mkdir -p ~/.claude/rules
ln -sf ~/github/hihats/dotfiles/.claude/rules/worktree.md ~/.claude/rules/worktree.md
ln -sf ~/github/hihats/dotfiles/.agents/rules/claims.md ~/.claude/rules/claims.md
mkdir -p ~/.claude/hooks
ln -sf ~/github/hihats/dotfiles/.claude/hooks/inject-review-practices.sh ~/.claude/hooks/inject-review-practices.sh

# Codex CLI: same AGENTS.md as Claude; tool-neutral skills/rules live in .agents/
mkdir -p ~/.codex/rules ~/.codex/instructions ~/.agents/skills
ln -sf ~/github/hihats/dotfiles/.agents/AGENTS.md ~/.codex/AGENTS.md
ln -sf ~/github/hihats/dotfiles/.codex/config.toml ~/.codex/config.toml
ln -sf ~/github/hihats/dotfiles/.codex/hooks.json ~/.codex/hooks.json
ln -sf ~/github/hihats/dotfiles/.codex/rules/dotfiles.rules ~/.codex/rules/dotfiles.rules
ln -sf ~/github/hihats/dotfiles/.agents/rules/claims.md ~/.codex/instructions/claims.md
ln -sfn ~/github/hihats/dotfiles/.agents/skills/invest ~/.agents/skills/invest

# Neovim
mkdir -p ~/.config
ln -sfn ~/github/hihats/dotfiles/.config/nvim ~/.config/nvim

# direnv
ln -sfn ~/github/hihats/dotfiles/.config/direnv ~/.config/direnv
