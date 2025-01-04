#!/bin/bash

if [ -z "$1" ] || [ $1 == "-h" ] || [ $1 == "--help" ]; then
    echo "$0 <profiles...>"
    echo "Currently available Profiles:"
    echo "console"
    echo "desktop"
    echo "ssh"
    exit
fi

sources=$(dirname $(readlink -f $0))

for profile in "$@"; do
    echo "Installing profile '$profile'"
    case "$profile" in
    console)
        ln -fs $sources/.bashrc ~/.bashrc
        ln -fs $sources/.tmux.conf ~/.tmux.conf
        ln -fs $sources/.vimrc ~/.vimrc
        ln -fs $sources/.inputrc ~/.inputrc

        mkdir -p ~/.bashrc.d/
        ln -fs $sources/.bashrc.d/05-tmux.sh ~/.bashrc.d/05-tmux.sh
        ln -fs $sources/.bashrc.d/20-defaults.sh ~/.bashrc.d/20-defaults.sh
        ln -fs $sources/.bashrc.d/30-alias.sh ~/.bashrc.d/30-alias.sh
        ln -fs $sources/.bashrc.d/40-extensions.sh ~/.bashrc.d/40-extensions.sh
        ln -fs $sources/.bashrc.d/98-fzf.sh ~/.bashrc.d/98-fzf.sh
        ;;
    desktop)
        ln -fs $sources/.lock ~/.lock
        
        mkdir -p ~/.config/i3/
        mkdir -p ~/.config/i3status/
        mkdir -p ~/.config/rofi/
        mkdir -p ~/.config/xfce4/terminal/
        ln -fs $sources/.config/i3/config ~/.config/i3/config
        ln -fs $sources/.config/i3status/config ~/.config/i3status/config
        ln -fs $sources/.config/rofi/config.rasi ~/.config/rofi/config.rasi
        ln -fs $sources/.config/xfce4/terminal/terminalrc ~/.config/xfce4/terminal/terminalrc
        ;;
    ssh)
				echo "Warning: This overwrites the files in /etc/ssh." 
				echo "sudo is used." 
        sudo mkdir -p /etc/ssh/sshd_config.d/
        sudo cp -f $sources/etc/ssh/sshd_config /etc/ssh/sshd_config
        sudo cp -f $sources/etc/ssh/sshd_config.d/10-security.conf /etc/ssh/sshd_config.d/10-security.conf
        sudo cp -f $sources/etc/ssh/sshd_config.d/30-autotmux.conf /etc/ssh/sshd_config.d/30-autotmux.conf
        sudo cp -f $sources/etc/ssh/sshd_config.d/90-defaults.conf /etc/ssh/sshd_config.d/90-defaults.conf
        ;;
    *)
        echo "unknown profile"
        continue
        ;;
    esac
    echo "success"
done
unset profile
unset sources
