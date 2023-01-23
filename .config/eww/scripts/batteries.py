#!/usr/bin/python3

import os

def read_file(path):
    try:
        f = open(path, 'r')
        return f.read().strip()
    except Exception:
        return ""

def update_batteries():
    prompt  = f""

    for dir in os.scandir('/sys/class/power_supply'):
        kind = read_file(dir.path + '/' + 'type')

        if kind == "Battery":
            model = read_file(dir.path + '/' + 'model_name')
            capacity = read_file(dir.path + '/' + 'capacity')
            prompt += f"(circle-indicator :value {capacity} :text \"\" :tooltips \"{model}\" :cmd \"\")"

    prompt += ""
    print(prompt)

update_batteries()
