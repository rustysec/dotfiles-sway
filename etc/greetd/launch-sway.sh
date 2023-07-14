#!/bin/bash

export XDG_CURRENT_DESKTOP=sway
export MOZ_ENABLE_WAYLAND=1

eval "$(ssh-agent -s)"

/usr/local/bin/sway
