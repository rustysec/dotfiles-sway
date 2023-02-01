#!/usr/bin/bash

volume=""

if [ "$1" = "up" ];
then
    volume=$(pamixer --allow-boost -ui 2 && dc -e "[`pamixer --get-volume`]sM 100d `pamixer --get-volume`<Mp")
elif [ "$1" = "down" ];
then
    volume=$(pamixer --allow-boost -ud 2 && dc -e "[`pamixer --get-volume`]sM 100d `pamixer --get-volume`<Mp")
fi

if [ ! -z $volume ]; then
    ~/.local/bin/eww update volume=$volume
fi
