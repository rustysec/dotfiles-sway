#!/bin/bash

if [ -z $(pgrep openconnect) ];
then
    echo "Enter VPN Gateway:"
    read gateway

    if [ ! -z $gateway ];
    then
        sudo openconnect -b --proto gp $gateway
        swaymsg '[app_id="VPN Connect"] move scratchpad' 2>/dev/null || hyprctl dispatch movetoworkspace "special,title=VPN Connect"
        echo "Press enter to disconnect..."
        read input
    fi
else
    hyprctl dispatch workspace special 2>/dev/null
fi
