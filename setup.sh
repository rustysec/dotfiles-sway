#!/bin/sh

# setup our greeter
sudo mkdir -p /etc/greetd
sudo cp etc/greetd/* /etc/greetd
sudo chown greeter /etc/greetd/*
sudo chgrp greeter /etc/greetd/*
sudo systemctl enable greetd

# link our config directories
for item in $(ls .config/)
do
    ln -s $pwd/.config/$item ~/.config/$item
done

# setup tmux
ln -s $pwd/.tmux.conf ~/.tmux.conf

# try and find a valid background
if [ -e '/usr/share/wallpapers/openSUSEdefault/contents/images/3840x2400.jpg' ];
then
    echo 'output * bg /usr/share/wallpapers/openSUSEdefault/contents/images/3840x2400.jpg fill' > ~/.config/sway/config.d/200-background.conf
elif [ -e '/usr/share/desktop-base/emerald-theme/wallpaper/contents/images/1920x1080.svg' ];
then
    echo 'output * bg /usr/share/desktop-base/emerald-theme/wallpaper/contents/images/1920x1080.svg fill' > ~/.config/sway/config.d/200-background.conf
fi
