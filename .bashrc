# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

case "$TERM" in
*color)
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='\u@\h:\w\$ '
    ;;
esac

test -s ~/.alias && . ~/.alias || true

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR=/usr/bin/vim

if [ -n "$TMUX" ]; then
  function update-agent {
    export $(tmux show-environment | grep "^SSH_AUTH_SOCK=") > /dev/null
  }
  return
fi

# don't start tmux when invoked via sudo
[ -n "$SUDO_USER" ] && return

[ -n "$SKIPTMUX" ] && return

test -x $(which tmux) || return

if [ -z "$TMUXSESSION" ]; then
    export TMUXSESSION='ssh'
fi

tmux has-session -t $TMUXSESSION || tmux new-session -s $TMUXSESSION -d

tmux has-session -t $TMUXSESSION || return

exec tmux attach-session -t $TMUXSESSION