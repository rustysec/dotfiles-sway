#!/bin/bash

# setup our greeter
sudo mkdir -p /etc/greetd
sudo cp etc/greetd/* /etc/greetd
sudo chown greeter /etc/greetd/*
sudo chgrp greeter /etc/greetd/*
sudo systemctl enable greetd

# link our config directories
for item in $(ls .config/)
do
    ln -s $(pwd)/.config/$item ~/.config/$item
done

# setup tmux
ln -s $pwd/.tmux.conf ~/.tmux.conf

# try and find a valid background
BACKGROUNDS=(
'/usr/share/wallpapers/openSUSEdefault/contents/images/3840x2400.jpg'
'/usr/share/desktop-base/emerald-theme/wallpaper/contents/images/1920x1080.svg'
)

for background in ${BACKGROUNDS[@]}
do
    echo "Checking for $background"
    if [ -e $background ]
    then
        echo "Setting background to $background"
        echo "output * bg $background fill" | tee ~/.config/sway/config.d/200-background.conf
        echo "output * bg $background fill" | sudo tee -a /etc/greetd/sway-config
    fi
done
