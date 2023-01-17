#!/bin/bash

OPT=$(cat ~/.config/sway/locker/options | wofi --insensitive --dmenu)

case $OPT in
    "Shutdown")
        systemctl poweroff
        ;;
    "Restart")
        systemctl reboot
        ;;
    "Logout")
        swaymsg exit || hyprctl dispatch exit 0
        ;;
    "Lock")
        /usr/bin/bash ~/code/dotfiles-suse/.config/sway/locker/locker.sh
        ;;
    *)
        echo "Doing Nothing!"
        ;;
esac
