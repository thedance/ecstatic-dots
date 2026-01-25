#!/usr/bin/env bash

CONFIG="$HOME/.config/waypaper/config.ini"

WALLPAPER=$(grep '^wallpaper' "$CONFIG" | cut -d'=' -f2 | sed 's/^ *//;s/ *$//')
WALLPAPER="${WALLPAPER/#\~/$HOME}"
WALLPAPER=$(realpath "$WALLPAPER")

wal -i "$WALLPAPER" -q
pywalfox update