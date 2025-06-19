# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS development environment setup. It manages shell configurations, development tools, and system preferences through symlinks and Homebrew bundle installation.

## Key Commands

### Environment Setup
- `brew bundle` - Install all applications and tools from Brewfile
- `sh makesymlink.sh` - Create symlinks for all dotfiles to home directory

### Development Tools Management
- Applications are managed via Brewfile (Homebrew Bundle)
- Shell environment uses zsh with zplug for plugin management
- Version managers: rbenv (Ruby), pyenv (Python), built-in node

## Architecture

The repository follows a simple structure:
- Root dotfiles (`.zshrc`, `.vimrc`, `.gitconfig`, etc.) are symlinked to `~`
- `Brewfile` contains all macOS applications and CLI tools
- `makesymlink.sh` handles the symlinking process
- `share/` directory contains additional configuration files

### Key Files
- `.zshrc` - Main shell configuration with aliases, exports, and zplug setup
- `Brewfile` - Complete list of Homebrew packages and casks to install
- `makesymlink.sh` - Script to create symlinks from dotfiles to home directory
- `.gitconfig` - Git configuration with aliases and merge tools

### Shell Configuration
- Uses zsh with custom prompt and history settings
- Includes development-focused aliases for Docker, Git, and AWS
- Integrates direnv for environment management
- Uses zplug for plugin management with syntax highlighting