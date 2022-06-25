#!/bin/bash

if [ -z "$1" ] || [ $1 == "-h" ] || [ $1 == "--help" ]; then
    echo "$0 <profiles...>"
    echo "Currently available Profiles:"
    echo "console"
    echo "desktop"
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
    *)
        echo "unknown profile"
        continue
        ;;
    esac
    echo "success"
done
unset profile
unset sources
