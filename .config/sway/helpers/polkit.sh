#!/bin/sh

# start a polkit agent
/usr/libexec/polkit-gnome-authentication-agent-1 || \
    /usr/libexec/polkit-kde-authentication-agent-1
