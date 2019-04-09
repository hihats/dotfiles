export TERM=xterm-256color
#eval $(gdircolors ~/dircolors-solarized)
export GREP_OPTIONS="--color=auto"
export HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '
export HISTIGNORE='history*:pwd:la:cd:exit:vagrant ssh:top:uptime'
export PS1="[\[\033[1;34m\]\u@ \[\033[0;33m\]\W\[\033[0m\]]$ "
export DATE=`date "+%Y%m%d"`

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
alias mwb='open -a "MySQLWorkbench.app"'
alias swb='open -a "SQLWorkbenchJ.app"'
alias slack='open -a "Slack.app"'
alias atom='open -a "Atom.app"'
alias jasper='open -a "Jasper.app"'
alias touchlog='echo "#"`date "+%Y-%m"` >> ~/Dropbox/log/`date "+%Y%m"`log.md'
alias log='atom ~/Dropbox/log/`date "+%Y%m"`log.md'



### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
### AWS
complete -C aws_completer aws
