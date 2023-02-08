#!/usr/bin/bash

[ -z $(eww windows | grep '*music') ] && eww open music || eww close music
