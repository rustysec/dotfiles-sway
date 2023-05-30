#!/bin/bash

# start a polkit agent
AGENTS=(
    "/usr/libexec/polkit-mate-authentication-agent-1"
    "/usr/libexec/polkit-gnome-authentication-agent-1"
    "/usr/libexec/polkit-kde-authentication-agent-1"
    "/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1"
    "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"
    "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
)

for agent in ${AGENTS[@]};
do
    if [ -f $agent ]; then
        echo "Using $agent"
        $agent
        break
    fi
done
