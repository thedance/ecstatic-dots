#!/usr/bin/env bash

WALLS="$HOME/Pictures/wallpapers"

# Source pywal FZF colors
[ -f "$HOME/.cache/wal/colors.sh" ] && source "$HOME/.cache/wal/colors.sh"

# Select wallpaper with live swww preview
SELECTED=$(fzf --height 90% --layout=reverse --exact --cycle \
    --border=rounded \
    --prompt=" Select wallpaper: " \
    --pointer="➤ " \
    --marker="✔ " \
    --preview "swww img {} --transition-step 5 --transition-fps 60 >/dev/null 2>&1 &" \
    --preview-window=right:0% \
    < <(find "$WALLS" -type f \( -iname "*.jpg" -o -iname "*.png" \)))

# Apply wallpaper and pywal
if [ -n "$SELECTED" ]; then
    swww img "$SELECTED"
    wal -i "$SELECTED"
fi