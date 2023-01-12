#!/bin/bash

function check() {
    if [ ! -z $(command -v zypper) ];
    then
        zypper lu | grep 'v |' | wc -l
    elif [ ! -z $(command -v apt) ];
    then
        apt list --upgradable 2>/dev/null | grep "/" | wc -l
    elif [ ! -z $(command -v pacman) ];
    then
        pacman -Qu | wc -l
    else
        echo "Unsupported package manager"
    fi
}

check
