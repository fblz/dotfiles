#!/bin/bash

if [ -z "$1" ] || [ $1 == "-h" ] || [ $1 == "--help" ]; then
    echo "$0 <profiles...>"
    echo "Currently available Profiles:"
    echo "console"
    echo "desktop"
    echo "ssh"
    echo "apt"
    echo "qemu"
    exit
fi

sources=$(dirname $(readlink -f $0))

for profile in "$@"; do
    echo "Installing profile '$profile'"
    case "$profile" in
    console)
        echo "$profile is a symlink profile"
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
        echo "$profile is a symlink profile"
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
        echo "$profile is a copy profile (sudo)"
        echo "Deleting non-local config:"
        sudo mkdir -p /etc/ssh/sshd_config.d/
        sudo find /etc/ssh/sshd_config.d/ -maxdepth 1 -type f ! -name "*.local.conf" -print
        echo ""
        echo "All files named *.local.conf will be kept."
        sudo find /etc/ssh/sshd_config.d/ -maxdepth 1 -type f ! -name "*.local.conf" -exec rm {} +
        sudo cp -f $sources/etc/ssh/sshd_config /etc/ssh/sshd_config
        sudo cp -f $sources/etc/ssh/sshd_config.d/01-security.conf /etc/ssh/sshd_config.d/01-security.conf
        sudo cp -f $sources/etc/ssh/sshd_config.d/30-autotmux.conf /etc/ssh/sshd_config.d/30-autotmux.conf
        sudo cp -f $sources/etc/ssh/sshd_config.d/90-defaults.conf /etc/ssh/sshd_config.d/90-defaults.conf
        sudo systemctl reload-or-try-restart ssh
        ;;
    apt)
        echo "$profile is a copy profile (sudo)"
        sudo mkdir -p /etc/apt/apt.conf.d/
        sudo mkdir -p /etc/systemd/system/apt-daily.timer.d
        sudo mkdir -p /etc/systemd/system/apt-daily-upgrade.timer.d
        sudo cp -f $sources/etc/apt/apt.conf.d/60custom-unattended /etc/apt/apt.conf.d/60custom-unattended
        sudo cp -f $sources/etc/systemd/system/apt-daily.timer.d/override.conf /etc/systemd/system/apt-daily.timer.d/override.conf
        sudo cp -f $sources/etc/systemd/system/apt-daily-upgrade.timer.d/override.conf /etc/systemd/system/apt-daily-upgrade.timer.d/override.conf
        sudo systemctl daemon-reload
        sudo systemctl restart apt-daily.timer
        sudo systemctl restart apt-daily-upgrade.timer
        ;;
    qemu)
        echo "$profile is a copy profile (sudo)"
        sudo mkdir -p /etc/qemu/
        sudo cp -f $sources/etc/qemu/qemu-ga.conf /etc/qemu/qemu-ga.conf
        sudo systemctl reload-or-try-restart qemu-guest-agent.service
        ;;
    ntp)
        echo "$profile is a copy profile (sudo)"
        sudo mkdir -p /etc/chrony/sources.d/
        sudo cp -f $sources/etc/chrony/sources.d/time.ptb.de.sources /etc/chrony/sources.d/time.ptb.de.sources
        sudo chronyc reload sources
        sudo timedatectl set-timezone 'Europe/Berlin'
        ;;
   *)
        echo "unknown profile $profile"
        continue
        ;;
    esac
    echo "success"
done
unset profile
unset sources
