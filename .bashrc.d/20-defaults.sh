# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoredups
HISTIGNORE='exit':'clear':'du*':'ip a':'cd':'cd ~':'cd ..':'man *':'which *':'history -c'
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
shopt -s histverify
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
 
export EDITOR=/usr/bin/vim

case "$TERM" in
*color)
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='\u@\h:\w\$ '
    ;;
esac
