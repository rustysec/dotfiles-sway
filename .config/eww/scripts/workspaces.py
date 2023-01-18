#!/usr/bin/python3

import json
import os
import socket
import subprocess
import sys

def update_workspace(active_workspace):
    output = subprocess.run(f"hyprctl -j workspaces", 
                    shell=True,
                    capture_output=True)

    workspaces = sorted(
            json.loads(output.stdout.decode("utf-8")),
            key=lambda d: d['id']
            )

    prompt  = f"(box"

    for ws in workspaces:
        id = ws["id"]
        count = ws["windows"]

        if id > 0:
            if id == active_workspace:
                prompt += f"(label :text \"{id}\" :class \"active\")"
            elif count > 0:
                prompt += f"(label :text \"{id}\")"

    prompt += ")"

    subprocess.run(f"echo '{prompt}'", shell=True)


def start():
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

    server_address = f'/tmp/hypr/{os.environ["HYPRLAND_INSTANCE_SIGNATURE"]}/.socket2.sock'

    sock.connect(server_address)

    while True:
        new_event = sock.recv(4096).decode("utf-8")
        
        for item in new_event.split("\n"):
                
            if "workspace>>" == item[0:11]:
                workspaces_num = item[-1]
                
                try:
                    update_workspace(int(workspaces_num))
                except Exception:
                    update_workspace(0)

if len(sys.argv) == 1:
    start()
else:
    output = subprocess.run(f"hyprctl -j monitors", 
                    shell=True,
                    capture_output=True)

    workspaces = sorted(
            json.loads(output.stdout.decode("utf-8")),
            key=lambda d: d['id']
            )

    active = workspaces[0]["activeWorkspace"]["id"]
    update_workspace(active)
