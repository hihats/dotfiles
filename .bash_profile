if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

PATH=$PATH:$HOME/bin
PATH="$HOME/.rbenv/bin:$PATH"
PATH="$(brew --prefix ruby)/bin:$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
export RBENV_ROOT=/usr/local/var/rbenv
export PATH

eval "$(rbenv init -)"
export PATH="/usr/local/sbin:$PATH"
