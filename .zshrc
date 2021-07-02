export PATH="/opt/homebrew/bin:$PATH"
export GOPATH=$HOME/go
export TERM=xterm-256color
#eval $(gdircolors ~/dircolors-solarized)
export GREP_OPTIONS="--color=auto"
export HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '
export HISTIGNORE='history*:pwd:la:cd:exit:vagrant ssh:top:uptime'
export DATE=`date "+%Y%m%d"`
#export PROMPT='%S%{$fg_bold[green]%}%{$bg[blue]%}%1~%{$reset_color%}%s%{$fg_bold[green]%}%(!.#.%%)%{$reset_color%} '
export PROMPT='%S%1~%s%(!.#.%%) '

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
