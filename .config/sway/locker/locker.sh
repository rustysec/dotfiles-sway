#!/bin/bash

EXTRA=$(cat $(dirname $0)/extra 2>/dev/null || echo "")

echo $EXTRA

swaylock $EXTRA -f -c 282c34 \
	--inside-color 282c34 \
	--inside-wrong-color ed1515 \
	--ring-wrong-color ed1515 \
	--inside-ver-color f67400 \
	--ring-ver-color f67400 \
	--ring-color 1d99f3 \
	--ring-clear-color 1b668f \
	--line-clear-color 1b668f \
	--inside-clear-color 16a085 \
	--key-hl-color 3daee9 \
	--bs-hl-color b65619
