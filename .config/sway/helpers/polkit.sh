#!/bin/bash

# start a polkit agent
/usr/libexec/polkit-gnome-authentication-agent-1 || \
    /usr/libexec/polkit-kde-authentication-agent-1 || \
    /usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1 || \
    /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
