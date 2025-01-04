# leave as 05-*, this will exec into tmux so we don't need other bash config
[ -z "$SSH_TTY" ] && return
command -v "tmux" >/dev/null || return

if [ -n "$TMUX" ]; then
  function update-agent {
    export $(tmux show-environment | grep "^SSH_AUTH_SOCK=") > /dev/null
  }
  return
fi

[ -n "$SKIPTMUX" ] && return

if sudo -nv 2>/dev/null; then
  # If we have sudo, we sudo into tmux.
	exec sudo tmux new-session -A -s ${TMUXSESSION:=ssh} -c '~'
fi

# Else we run as the user
exec tmux new-session -A -s ${TMUXSESSION:=ssh} -c '~'