#!/bin/bash

GREETD_USERS=(
    "greeter"
    "_greetd"
)

for greetd_user in ${GREETD_USERS[@]}
do
    if [ ! -z "$(grep $greetd_user /etc/passwd)" ];
    then
        GREETD_USER=$greetd_user
        break
    fi
done

# setup our greeter
sudo mkdir -p /etc/greetd
sudo cp etc/pam.d/* /etc/pam.d
sudo cp etc/greetd/* /etc/greetd
sudo chown $GREETD_USER /etc/greetd/*
sudo chgrp $GREETD_USER /etc/greetd/*
sudo systemctl enable greetd

# allow package refreshing from users
sudo cp etc/sudoers.d/* /etc/sudoers.d/

# link our config directories
for item in $(ls .config/)
do
    ln -s $(pwd)/.config/$item ~/.config/$item
done

# setup tmux
ln -s $(pwd)/.tmux.conf ~/.tmux.conf

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

# configure some .profile items
echo 'export XDG_CURRENT_DESKTOP=sway' | tee -a ~/.profile
echo 'eval "$(ssh-agent -s)"' | tee -a ~/.profile

