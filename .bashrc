export TERM=xterm-256color
#eval $(gdircolors ~/dircolors-solarized)
export GREP_OPTIONS="--color=auto"
export HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '
export HISTIGNORE='history*:pwd:la:cd:exit:vagrant ssh:top:uptime'
export PS1="[\[\033[1;34m\]\u@ \[\033[0;33m\]\W\[\033[0m\]]$ "

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

# Applications
alias chrome='open -a "Google Chrome"'
alias incog='open -a "Google Chrome --incognito"'
alias mwb='open -a "MySQLWorkbench.app"'
alias swb='open -a "SQLWorkbenchJ.app"'
alias slack='open -a "Slack.app"'
export DATE=`date "+%Y%m%d"`
alias touchlog='echo "#"`date "+%Y-%m"` >> ~/Dropbox/log/`date "+%Y%m"`log.md'
alias log='atom ~/Dropbox/log/`date "+%Y%m"`log.md'
export GEM_HOME=/Users/hihats/.rbenv/versions/2.3.1/



### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

complete -C aws_completer aws
