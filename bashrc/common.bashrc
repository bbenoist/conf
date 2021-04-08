# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Définition des alias
alias sudo='sudo ' # Allow to use alias avec sudo
alias cpdir='cp -ari'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias la='ls -la'
alias ll='ls -l'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias halt='shutdown'

function mkcd() { mkdir "$1" && cd "$1"; }
function mkexec() { chmod +x "$1"; }
function mkmine() { sudo chown -R ${USER} ${1:-.}; }

function mktar()
{
  if [ ! -z "$1" ]; then
    tar czf "${1%%/}.tar.gz" "${1%%/}/";
  else
    echo "Please specify a file or directory"
    exit 1
  fi
}

function extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf $1;;
      *.tar.gz) tar xzf $1;;
      *.bz2) bunzip2 $1;;
      *.rar) rar x $1;;
      *.gz) gunzip $1;;
      *.tar) tar xf $1;;
      *.tbz2) tar xjf $1;;
      *.tgz) tar xzf $1;;
      *.zip) unzip $1;;
      *.Z) uncompress $1;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Avoid succesive duplicates in the bash command history.
export HISTCONTROL=ignoredups

# Append commands to the bash command history file (~/.bash_history) instead of
# overwriting it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ "$SSH_CONNECTION" != "" ]; then
  # Required by xming hardware OpenGL
  export LIBGL_ALWAYS_INDIRECT=1

  # tmux at launch
  if which tmux 2>&1 >/dev/null; then
    # if no session is started, start a new session
    test -z ${TMUX} && tmux
    # when quitting tmux, try to attach
    while test -z ${TMUX}; do
      tmux attach || break
    done
  fi
fi

# Custom prompt

function __last_exit_ps1 {
  if [ "$1" == "0" ]; then
    echo -e "\\[\e[0;32m\\]✓\\[\e[m\\]"
  else
    echo -e "\\[\e[0;31m\\]$1\\[\e[m\\]"
  fi
}

function __prompt_command {
  __git_ps1 "$(__last_exit_ps1 $?) \w\\[\e[m\\] " "\\\$ " "- %s "
}

export PROMPT_COMMAND='__prompt_command'
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWCOLORHINTS=1

# Limit the size of the path to 3 directories.
export PROMPT_DIRTRIM=3
