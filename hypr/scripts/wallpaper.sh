#!/bin/bash

# 1. Path to the image
WALL=$(realpath "$1")

# 2. Generate colors with Pywal
wal -i "$WALL" -n -q

# 3. Ensure Hyprpaper is running
if ! pgrep -x "hyprpaper" > /dev/null; then
    hyprpaper &
    sleep 1 # Give it a second to start the socket
fi

# 4. Update Hyprpaper via IPC
# Preload the new one
hyprctl hyprpaper preload "$WALL"

# Set it for both your monitors
hyprctl hyprpaper wallpaper "HDMI-A-1,$WALL"
hyprctl hyprpaper wallpaper "DP-1,$WALL"

# 5. Clean up
# Unload other wallpapers to save RAM, but keep the current one
hyprctl hyprpaper unload all

# 6. Refresh Hyprland borders
hyprctl reload
