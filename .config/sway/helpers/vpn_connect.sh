#!/bin/bash

if [ -z $(pgrep openconnect) ];
then
    echo "Enter VPN Gateway:"
    read gateway

    if [ ! -z $gateway ];
    then
        sudo openconnect -b --proto gp $gateway
        swaymsg '[app_id="VPN Connect"] move scratchpad'
        echo "Press enter to disconnect..."
        read input
    fi
fi
