#!/usr/bin/env bash
# This script is a cutom wrapper for i3lock.
# Dependencies: i3lock, imagemagick, scrot.

# Create a temporary file to work with.
IMAGE="$(mktemp).png"

# Take a screenshot and save it to the temporary file.
scrot -z "$IMAGE"

# Transform the image.
EFFECT=(-scale 25% -scale 400%)
convert "$IMAGE" "${EFFECT[@]}" "$IMAGE"

# Call the i3 lock.
i3lock -i "$IMAGE" -u