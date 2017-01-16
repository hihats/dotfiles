if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

PATH=$PATH:$HOME/bin:/usr/local/sbin:/usr/local/bin
PATH="$(brew --prefix ruby)/bin:$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export RBENV_ROOT=$HOME/.rbenv
export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
eval "$(rbenv init -)"
export PYENV_ROOT=$HOME/.pyenv
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init -)"
complete -C aws_completer aws
