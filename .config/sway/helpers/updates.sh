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
    elif [ ! -z $(command -v xbps-install) ];
    then
        xbps-install -un | wc -l
    fi
}

check
