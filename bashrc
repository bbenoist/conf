#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Permet d'utiliser directement nano lors d'un appel de yaourt
# Peut être remplacé par le nom de l'éditeur alternatif à utiliser
export EDITOR="nano"

# Définition des alias
alias cd.='cd ..'
alias cd..='cd ..'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias wget='wget --timeout 10'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias la='ls -la'
alias ll='ls -l'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias halt='shutdown'
alias makelog='make > make.log 2>&1'
alias np='geany'

function mkcd() { mkdir "$1" && cd "$1"; }
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

export PATH=$PATH:~/scripts

# Sources
source /usr/share/git/completion/git-prompt.sh

# Affiche un * à côté de la branche si des changements non commités sont
# présents ou affiche un + si tous les changements ont étés notifiés mais non
# commités
export GIT_PS1_SHOWDIRTYSTATE="true"

# Affiche un % à côté de la branche si des nouveaux fichiers non tracés ont été
# detectés
export GIT_PS1_SHOWUNTRACKEDFILES="true"

# Version affichant la branche git actuelle à la fin de l'en-tete bash
PS1='\e[1;0m\u@\h \e[1;1m\e[1;37m\w\e[1;0m$(__git_ps1 " (\e[1;1m\e[1;33m%s\e[1;0m)")\n\$ '
