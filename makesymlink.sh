# /bin/bash

set -e

ln -sf ~/github/hihats/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/github/hihats/dotfiles/.bashrc ~/.bashrc
ln -sf ~/github/hihats/dotfiles/.zshrc ~/.zshrc
ln -sf ~/github/hihats/dotfiles/.vimrc ~/.vimrc
ln -sf ~/github/hihats/dotfiles/.ssh/config ~/.ssh/config
ln -sf ~/github/hihats/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/github/hihats/dotfiles/.gitignore_global ~/.gitignore_global
ln -sf ~/github/hihats/dotfiles/.finicky.js ~/.finicky.js
ln -sf ~/github/hihats/dotfiles/.npmrc ~/.npmrc
ln -sf ~/github/hihats/dotfiles/.claude/settings.json ~/.claude/settings.json
mkdir -p ~/.agents
ln -sf ~/github/hihats/dotfiles/.agents/AGENTS.md ~/.agents/AGENTS.md
ln -sf ~/.agents/AGENTS.md ~/.claude/CLAUDE.md

# Neovim
mkdir -p ~/.config
ln -sfn ~/github/hihats/dotfiles/.config/nvim ~/.config/nvim
