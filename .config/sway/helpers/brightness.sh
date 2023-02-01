#!/usr/bin/bash

brightness=""

if [ "$1" = "up" ];
then
    brightnessctl -q set 5%+
    brightness=$((`brightnessctl get` * 100 / `brightnessctl m`))
elif [ "$1" = "down" ];
then
    brightnessctl -q set 5%-
    brightness=$((`brightnessctl get` * 100 / `brightnessctl m`))
fi

if [ ! -z $brightness ]; then
    echo "setting new brightness $brightness"
    ~/.local/bin/eww update brightness=$brightness
fi
