#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="$HOME/Documents/地獄/０２ー資料/Japanese Logs/Logs"
TODAY="$(date +%F).md"
FILE="$LOG_DIR/$TODAY"

mkdir -p "$LOG_DIR"

if [[ ! -f "$FILE" ]]; then
cat > "$FILE" <<'EOF'
---
active: 0
freeflow: 0
passive: 0
---

[[logs]]
EOF
fi

exec kitty \
    --class journal-note \
    --override font_size=15 \
    micro "$FILE"