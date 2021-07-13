#!/bin/bash

if [ -z "$1" ] || [ $1 == "-h" ] || [ $1 == "--help" ]; then
    echo "$0 <profiles...>"
    echo "Currently available Profiles:"
    echo "console"
    echo "desktop"
    exit
fi

if [ $(id -u) != 0 ]; then
    echo "To install packages, we need root. Please rerun as root."
    exit
fi

if ! [ -e /etc/os-release ]; then
    echo "/etc/os-release not found. Aborting."
    exit
fi

source /etc/os-release
echo "detected $ID"

for profile in "$@"; do
    echo "Installing profile '$profile'"
    case "$profile" in
    console)
        case "$ID" in
        ubuntu)
            apt-get update
            apt-get install -y tmux git vim fzf bash-completion
            ;;
        fedora)
            dnf install --assumeyes tmux git vim fzf bash-completion
            ;;
        *)
            echo "not configured"
            ;;
        ;;
    desktop)
        case "$ID" in
        fedora)
            dnf groupinstall --assumeyes i3
            rpm --import https://packages.microsoft.com/keys/microsoft.asc
            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
            dnf install --assumeyes xfce4-terminal xss-lock rofi maim ImageMagick keepassxc nextcloud-client fontawesome-fonts code feh
            ;;
        *)
            echo "not configured"
            ;;
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
