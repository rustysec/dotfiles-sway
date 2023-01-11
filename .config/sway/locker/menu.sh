#!/bin/bash

OPT=$(cat ~/code/dotfiles-suse/.config/sway/locker/options | wofi --insensitive --dmenu --style=/etc/wofi/style.css)

case $OPT in
    "Shutdown")
        systemctl poweroff
        ;;
    "Restart")
        systemctl reboot
        ;;
    "Logout")
        swaymsg exit
        ;;
    "Lock")
        /usr/bin/bash ~/code/dotfiles-suse/.config/sway/locker/locker.sh
        ;;
    *)
        echo "Doing Nothing!"
        ;;
esac
