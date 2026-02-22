#!/usr/bin/env bash

WALLDIR="$HOME/Pictures/wallpapers"

selection=$(
  find "$WALLDIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) \
  | while read -r img; do
      printf "img:%s\t%s\n" "$img" "$(basename "$img")"
    done \
  | wofi --show dmenu --allow-images --prompt "Wallpaper"
)

# Extract the path (before the tab)
path=$(printf "%s" "$selection" | cut -f1 | sed 's/^img://')

[ -n "$path" ] && swww img "$path" --transition-type grow