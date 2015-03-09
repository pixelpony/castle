#!/bin/bash
# .bashrc

alias gsu='git submodule sync && git submodule update --init'
alias gp='git pull'
alias gs='git status -sb'
alias cleanDS='sudo find . -name ".DS_Store" -depth -exec rm {} \;'

alias ls="ls -G"
alias lsa="ls -al"
alias ll='ls -lFh'      # Long view, no hidden
alias clr='clear;echo "Currently logged in on $(tty), as $(whoami) in directory $(pwd)."'
alias df='df -h'        # Disk free, in gigabytes, not bytes
alias du='du -h -c'     # Calculate total disk usage for a folder
alias mkdeploy='git subtree push --prefix=dist origin deploy'
#alias ls="ls;exit"

case $OSTYPE in
    linux*)
        # Linux Specific
    ;;
    darwin*)
        # Mac Specific
        alias mvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
    ;;
    *)
  ;;
esac

# Better looking ls output
case `uname` in
    Linux) # Linux Specific
        export LS_COLORS="di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=32;38:tw=0;42:ow=0;43:"
        ;;
    Darwin) # OSX Specific
        export LSCOLORS='Gxfxcxdxdxegedabagacad'
        ;;
    *) # Non-OSX, Non-Linux.
        ;;
esac


if [ -f `brew --prefix`/etc/bash_completion ]; then
	. `brew --prefix`/etc/bash_completion
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export CATALINA_HOME='/usr/local/tomcat'
export PATH="/usr/local/share/python:/usr/local/bin:/bin:/usr/local/share/npm/bin:$PATH"
export PYTHONPATH='/usr/local/share/python'
export EDITOR='/usr/bin/vim'
export GIT_EDITOR='/usr/bin/vim'
export JAVA_HOME=$(/usr/libexec/java_home)

export WORKON_HOME=/opt/virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
source /usr/local/bin/virtualenvwrapper.sh

# Prompt Colors
BGREEN='\[\033[1;32m\]'
GREEN='\[\033[0;32m\]'
BRED='\[\033[1;31m\]'
RED='\[\033[0;31m\]'
BBLUE='\[\033[1;34m\]'
BLUE='\[\033[0;34m\]'
NORMAL='\[\033[00m\]'


extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)        tar xjf $1        ;;
      *.tar.gz)         tar xzf $1        ;;
      *.bz2)            bunzip2 $1        ;;
      *.rar)            unrar x $1        ;;
      *.gz)             gunzip $1         ;;
      *.tar)            tar xf $1         ;;
      *.tbz2)           tar xjf $1        ;;
      *.tgz)            tar xzf $1        ;;
      *.zip)            unzip $1          ;;
      *.Z)              uncompress $1     ;;
      *)                echo "'$1' cannot be extracted via extract()" ;;
  esac
  else
    echo "'$1' is not a valid file"
  fi
}

mcd () {
  mkdir "$@" && cd "$@"
}

parse_git_branch(){ git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'; }





cp_p()
{
   strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
      | awk '{
        count += $NF
            if (count % 10 == 0) {
               percent = count / total_size * 100
               printf "%3d%% [", percent
               for (i=0;i<=percent;i++)
                  printf "="
               printf ">"
               for (i=percent;i<100;i++)
                  printf " "
               printf "]\r"
            }
         }
         END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

#PS1="${BLUE}(${NORMAL}\w${BLUE})${GREEN} \$(parse_git_branch)${NORMAL}\u${BLUE}@\h${RED}\$ ${NORMAL}"


function get_ssh_key_files() {
  local list= 
  for keyfile in $(/usr/bin/egrep -c 'BEGIN.+PRIVATE KEY' ~/.ssh/* | grep :1 | cut -d: -f1); do 
    ssh-keygen -l -f ${keyfile}.pub &>/dev/null && list="${list} $(basename ${keyfile})"
  done
  echo $list
}

# set up public key via public key setup function
#eval $(keychain --eval --agents ssh,gpg --inherit any $(get_ssh_key_files))

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH=/usr/local/opt/ruby/bin:$PATH
export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules

export PATH=$HOME/bin:$PATH

. ~/apps/powerline/powerline/bindings/bash/powerline.sh
