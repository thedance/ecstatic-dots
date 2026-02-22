#!/usr/bin/env bash

WALLS="$HOME/Pictures/wallpapers"

# pick random image from any subfolder
IMG=$(find "$WALLS" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)

# apply wallpaper + pywal
[ -n "$IMG" ] && {
    swww img "$IMG" --transition-step 5 --transition-fps 60
    wal -i "$IMG"
}