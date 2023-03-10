#!/usr/bin/python3

import subprocess

def fix(item):
    item = item.replace("(", "\\(")
    item = item.replace(")", "\\)")
    item = item.replace("'", "\\'")
    item = item.replace("`", "\\`")
    item = item.replace("\"", "\\\"")
    return item


def start():
    player = subprocess.Popen(["playerctl", "-F", "metadata", "-f", "{{status}}|{{artist}}|{{title}}|{{album}}|{{mpris:artUrl}}"], stdout=subprocess.PIPE)

    while True:
        line = player.stdout.readline()

        if not line:
            break

        try:
            (status, artist, title, album, artUrl) = line.decode().strip().split('|')

            artUrl = artUrl.replace("file://", "")

            prompt = "{"
            prompt += f"\"status\": \"{status}\","
            prompt += f"\"artist\": \"{artist}\","
            prompt += f"\"title\": \"{title}\","
            prompt += f"\"album\": \"{album}\","
            prompt += f"\"artUrl\": \"{artUrl}\""
            prompt += "}"

            print(f"{prompt}", flush=True)

            # subprocess.run("echo '" + prompt + "'", shell=True)
        except Exception:
            print("{}", flush=True)


start()
