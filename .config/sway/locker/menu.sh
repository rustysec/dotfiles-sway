#!/bin/bash

OPT=$(cat ~/.config/sway/locker/options | wofi --insensitive --dmenu)

case $OPT in
    "Shutdown")
        systemctl poweroff || loginctl poweroff
        ;;
    "Restart")
        systemctl reboot || loginctl reboot
        ;;
    "Logout")
        swaymsg exit || hyprctl dispatch exit 0
        ;;
    "Lock")
        /usr/bin/bash ~/.config/sway/locker/locker.sh
        ;;
    *)
        echo "Doing Nothing!"
        ;;
esac
