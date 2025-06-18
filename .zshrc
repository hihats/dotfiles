export PYENV_ROOT="$HOME/.pyenv"
export PATH="/opt/homebrew/bin:$PYENV_ROOT/shims:$PATH"
export GOPATH=$HOME/go
export TERM=xterm-256color
#eval $(gdircolors ~/dircolors-solarized)
export GREP_OPTIONS="--color=auto"
export HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '
export HISTIGNORE='history*:pwd:la:cd:exit:vagrant ssh:top:uptime'
export DATE=`date "+%Y%m%d"`
#export PROMPT='%S%{$fg_bold[green]%}%{$bg[blue]%}%1~%{$reset_color%}%s%{$fg_bold[green]%}%(!.#.%%)%{$reset_color%} '
export PROMPT='%S%1~%s%(!.#.%%) '
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups

case "${OSTYPE}" in
darwin*)
  alias ls="ls -G"
  alias ll="ls -l"
  alias la="ls -la"
  ;;
linux*)
  alias ls='ls --color=auto'
  alias la='ls -la'
  ;;
esac
alias rm='rm -i'

# frequently used command
alias bashrc='vim ~/.bashrc'
alias sshconf='vim ~/.ssh/config'
alias dl='open ~/Downloads/'
alias dcbuild='docker-compose build'
alias dcps='docker-compose ps'
alias frequent="HISTTIMEFORMAT='' history | sed -e 's/^[ ]*//g' | cut -d' ' -f2- | sort | uniq -c | sort -r"

# Applications
alias chrome='open -a "Google Chrome"'
alias incog='open -a "Google Chrome --incognito"'
alias slack='open -a "Slack.app"'
alias touchlog='echo "#"`date "+%Y-%m"` >> ~/Dropbox/log/`date "+%Y%m"`log.md'

# git
alias gitmylog='git log --author=hishats@gmail.com --since=1.months --pretty=format:"%cd : %s" --no-merges'
### AWS
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
compinit

setopt +o nomatch

# direnv
export EDITOR=vim
eval "$(direnv hook zsh)"

# zplugの設定
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

# プライベートリポジトリのプラグインも使うのでzplugのgitをssh経由にする
ZPLUG_PROTOCOL=ssh

zplug "zsh-users/zsh-syntax-highlighting"

# peco/percol/fzfなどでフィルタ絞込するためのフレームワーク
zplug "mollifier/anyframe"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
