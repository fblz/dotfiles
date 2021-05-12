# leave as 99-*, this will exec into tmux and you want all other stuff to be executed before
[ -z "$SSH_TTY" ] && return
test -x $(which tmux) || return

if [ -n "$TMUX" ]; then
  function update-agent {
    export $(tmux show-environment | grep "^SSH_AUTH_SOCK=") > /dev/null
  }
  return
fi

# don't start tmux when invoked via sudo
[ -n "$SUDO_USER" ] && return

[ -n "$SKIPTMUX" ] && return

if [ -z "$TMUXSESSION" ]; then
    export TMUXSESSION='ssh'
fi

tmux has-session -t $TMUXSESSION || tmux new-session -s $TMUXSESSION -d

tmux has-session -t $TMUXSESSION || return

exec tmux attach-session -t $TMUXSESSION
