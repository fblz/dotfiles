# leave as 05-*, this will exec into tmux so we don't need other bash config

# Exit if non interactive
[ -z "$PS1" ] && return

# Exit if not in an SSH session
[ -z "$SSH_TTY" ] && return

# Check if tmux is installed
command -v "tmux" >/dev/null || return

if [ -n "$TMUX" ]; then
  # if already inside tmux, add this function and return
  function update-agent {
    export $(tmux show-environment | grep "^SSH_AUTH_SOCK=") > /dev/null
  }
  return
fi

# This is to skip the auto tmux. Use with /etc/ssh/sshd_config.d/30-autotmux.conf
[ -n "$SKIPTMUX" ] && return

if sudo -nv 2>/dev/null; then
  # If we have sudo, we sudo into tmux.
	exec sudo tmux new-session -A -s ${TMUXSESSION:=ssh} -c '~'
fi

# Else we run as the user
exec tmux new-session -A -s ${TMUXSESSION:=ssh} -c '~'