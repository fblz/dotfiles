# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
PS1='\u@\h:\w\$ '

test -s ~/.alias && . ~/.alias || true

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR=/usr/bin/vim

# don't start tmux when invoked via sudo
[ -n "$SUDO_USER" ] && return

# don't start tmux if already running inside tmux
[ -n "$TMUX" ] && return

[ -n "$SKIPTMUX" ] && return

test -x $(which tmux) || return

tmux has-session -t ssh || tmux new-session -s ssh -d

tmux has-session -t ssh || return

exec tmux attach-session -t ssh
