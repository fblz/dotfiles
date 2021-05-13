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

        mkdir -p ~/.bashrc.d/
        ln -fs $sources/.bashrc.d/20-defaults.sh ~/.bashrc.d/20-defaults.sh
        ln -fs $sources/.bashrc.d/30-alias.sh ~/.bashrc.d/30-alias.sh
        ln -fs $sources/.bashrc.d/40-extensions.sh ~/.bashrc.d/40-extensions.sh
        ln -fs $sources/.bashrc.d/99-tmux.sh ~/.bashrc.d/99-tmux.sh
        ;;
    desktop)
        ln -fs $sources/.lock ~/.lock
        
        mkdir -p ~/.config/i3/
        mkdir -p ~/.config/i3status/
        mkdir -p ~/.config/rofi/
        ln -fs $sources/.config/i3/config ~/.config/i3/config
        ln -fs $sources/.config/i3status/config ~/.config/i3status/config
        ln -fs $sources/.config/rofi/config.rasi ~/.config/rofi/config.rasi
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
