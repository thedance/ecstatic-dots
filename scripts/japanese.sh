#!/usr/bin/env bash

setsid spotify >/dev/null 2>&1 &
setsid anki >/dev/null 2>&1 &
setsid obsidian >/dev/null 2>&1 &
setsid brave --profile-directory=Default --app-id=nkfkgialnemdjemblbhklkljafjlpgip >/dev/null 2>&1 &

pkill "$$"