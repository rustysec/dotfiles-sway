#!/bin/bash

if [ -z $(pgrep openconnect) ];
then
    echo "Enter VPN Gateway:"
    read gateway

    if [ ! -z $gateway ];
    then
        sudo openconnect --proto gp $gateway
    fi
fi
