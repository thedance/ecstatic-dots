#!/usr/bin/env bash

PIDFILE=/tmp/audio_record.pid

ANKI_MEDIA="$HOME/.local/share/Anki2/User 1/collection.media"
DEVICE="bluez_output.18_90_67_77_07_68.1.monitor"

mkdir -p "$ANKI_MEDIA"

if [ -f "$PIDFILE" ]; then
    kill "$(cat "$PIDFILE")"
    rm "$PIDFILE"

    # get newest file safely
    LAST_FILE=$(ls -t "$ANKI_MEDIA"/*.mp3 2>/dev/null | head -n 1)
    BASENAME=$(basename "$LAST_FILE")

    ANKI_TAG="[sound:$BASENAME]"

    # Wayland clipboard
    echo -n "$ANKI_TAG" | wl-copy

    notify-send "Audio saved" "$ANKI_TAG copied to clipboard"
else
    FILE="$ANKI_MEDIA/clip_$(date +%F_%H-%M-%S).mp3"

    ffmpeg -loglevel error \
        -f pulse \
        -i "$DEVICE" \
        -c:a libmp3lame \
        "$FILE" &

    echo $! > "$PIDFILE"

    notify-send "Recording started"
fi
