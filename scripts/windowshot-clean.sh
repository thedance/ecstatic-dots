#!/usr/bin/env bash
HIDE_WS="special:screenshothide"

hyprctl clients -j | jq -r '
    map(select(.floating == true and .focusHistoryID != 0 and .workspace.id > 0))
    | .[].address
' > /tmp/hidden_floats.txt

while read -r addr; do
    [ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent "$HIDE_WS",address:"$addr"
done < /tmp/hidden_floats.txt

sleep 0.15
hyprshot -m window -o ~/Pictures/Screenshots/
sleep 0.5

# Get the active workspace id before restoring
ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')

hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:screenshothide") | .address' > /tmp/restore_floats.txt

while read -r addr; do
    [ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent "$ACTIVE_WS",address:"$addr"
done < /tmp/restore_floats.txt

rm /tmp/hidden_floats.txt /tmp/restore_floats.txt