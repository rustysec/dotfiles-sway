#!/bin/bash

function update() {
    if [ ! -z $(command -v zypper) ];
    then
        sudo zypper dup
    elif [ ! -z $(command -v apt) ];
    then
        sudo apt upgrade
    elif [ ! -z $(command -v pacman) ];
    then
        sudo pacman -Syu
    else
        echo "Unsupported package manager"
    fi
}

update
echo "Updates done, press enter to close"
read input
