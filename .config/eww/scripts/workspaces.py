#!/usr/bin/python3

import json
import os
import socket
import subprocess
import sys
from i3ipc import Connection, Event
import getopt

i3 = None

orientation = "v"
monitor_name = "none"
monitor = 0

def update_hypr_workspace(active_workspace):
    global orientation
    global monitor_name

    output = subprocess.run(f"hyprctl -j workspaces", 
                    shell=True,
                    capture_output=True)

    workspaces = sorted(
            json.loads(output.stdout.decode("utf-8")),
            key=lambda d: d['id']
            )

    prompt  = f"(box :spacing 5 :orientation \"{orientation}\" "

    for ws in workspaces:
        id = ws["id"]
        count = ws["windows"]

        if ws["monitor"] == monitor_name and id > 0:
            if id == active_workspace:
                prompt += f"(circle-indicator :value 100 :class \"workspace\" :cmd \"hyprctl dispatch workspace {id}\" :text \"{id}\")"
            elif count > 0:
                prompt += f"(circle-indicator :value 0   :class \"workspace\" :cmd \"hyprctl dispatch workspace {id}\" :text \"{id}\")"

    prompt += ")"

    print(prompt, flush=True)


def start_hypr():
    global monitor
    global monitor_name

    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

    server_address = f'/tmp/hypr/{os.environ["HYPRLAND_INSTANCE_SIGNATURE"]}/.socket2.sock'

    sock.connect(server_address)

    output = subprocess.run(f"hyprctl -j monitors", 
                    shell=True,
                    capture_output=True)

    monitors = json.loads(output.stdout.decode("utf-8"))

    for m in monitors:
        if m["id"] == monitor:
            monitor_name = m["name"]
            break

    while True:
        new_event = sock.recv(4096).decode("utf-8")
        
        for item in new_event.split("\n"):
                
            if "workspace>>" == item[0:11]:
                workspaces_num = item[-1]
                
                try:
                    update_hypr_workspace(int(workspaces_num))
                except Exception:
                    update_hypr_workspace(0)

def init_hypr():
    output = subprocess.run(f"hyprctl -j monitors", 
                    shell=True,
                    capture_output=True)

    workspaces = sorted(
            json.loads(output.stdout.decode("utf-8")),
            key=lambda d: d['id']
            )

    active = workspaces[0]["activeWorkspace"]["id"]
    update_hypr_workspace(active)

    start_hypr()

def update_sway_workspace():
    prompt  = f"(box :spacing 5 :orientation \"v\" "

    workspaces = i3.get_workspaces()

    for ws in workspaces:
        id = ws.num

        if ws.focused:
            prompt += f"(circle-indicator :value 100 :class \"workspace\" :cmd \"sway workspace {id}\" :text \"{id}\")"
        else:
            prompt += f"(circle-indicator :value 0   :class \"workspace\" :cmd \"sway workspace {id}\" :text \"{id}\")"

    prompt += ")"

    print(prompt, flush=True)

def on_sway_workspace_focus(self, e):
    if e.current:
        update_sway_workspace()

def init_sway():
    global i3
    i3 = Connection()
    update_sway_workspace()
    i3.on(Event.WORKSPACE_FOCUS, on_sway_workspace_focus)
    i3.on(Event.WORKSPACE_INIT, on_sway_workspace_focus)
    i3.main()

######################
# Determine which WM #
######################
CURRENT_DESKTOP = USER = os.getenv('XDG_CURRENT_DESKTOP')

def main(argv):
    opts, args = getopt.getopt(argv,"hvm:")

    for opt, arg in opts:
        if opt == "h":
            orientation = "h"
        elif opt == "v":
            orientation = "v"
        elif opt == "m":
            monitor = arg

    if CURRENT_DESKTOP == 'sway':
        init_sway()
    elif CURRENT_DESKTOP == 'Hyprland':
        init_hypr()
    else:
        print(f"Incompatable window manager: {CURRENT_DESKTOP}")

if __name__ == "__main__":
   main(sys.argv[1:])
