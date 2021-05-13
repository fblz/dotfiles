#!/bin/bash

if [ -z "$1" ] || [ $1 == "-h" ] || [ $1 == "--help" ]; then
    echo "$0 <profiles...>"
    echo "-h --help :  show this"
    exit
fi

sources=$(dirname $(readlink -f $0))

for profile in "$@"; do
    case "$profile" in
    console)
        ln -fs $sources/.bashrc ~/.bashrc
        ln -fs $sources/.tmux.conf ~/.tmux.conf
        ln -fs $sources/.vimrc ~/.vimrc

        # This might grow regularly, so we keep this a loop
        mkdir -p ~/.bashrc.d/
        for file in $sources/.bashrc.d/*; do
            if [ -f "$file" ]; then
                bname=$(basename $file)
                ln -fs $file ~/.bashrc.d/$bname
                unset bname
            fi
        done
        unset file
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
        echo "Unknown profile \"$profile\""
        ;;
    esac
done
unset profile
unset sources
echo "All done???"
