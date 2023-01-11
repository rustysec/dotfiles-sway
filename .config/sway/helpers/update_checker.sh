#!/bin/sh

function check() {
    if [ ! -z $(command -v zypper) ];
    then
        sudo zypper refresh
    elif [ ! -z $(command -v apt) ];
    then
        sudo apt update
    elif [ ! -z $(command -v pacman) ];
    then
        sudo pacman -Syu
    else
        echo "Unsupported package manager"
    fi
}

while true
do
    check
    sleep 600
done
