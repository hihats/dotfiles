export PYENV_ROOT="$HOME/.pyenv"
export EDITOR=nvim

[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"

export UV_DEFAULT_INDEX="https://token:${TAKUMI_GUARD_TOKEN}@pypi.flatt.tech/simple/"
