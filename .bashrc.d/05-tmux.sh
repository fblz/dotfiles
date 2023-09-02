# leave as 05-*, this will exec into tmux so we don't need other bash config
[ -z "$SSH_TTY" ] && return
command -v "tmux" >/dev/null || return

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
