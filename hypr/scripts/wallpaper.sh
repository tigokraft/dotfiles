#!/bin/bash

# 1. Path to the image
WALL=$(realpath "$1")

# 2. Generate colors with Pywal
wal -i "$WALL" -n -q

# 3. Ensure hyprpaper is running
if ! pgrep -x "hyprpaper" > /dev/null; then
    hyprpaper &
    sleep 1
fi

# 4. Update via hyprctl IPC
# Step A: Preload the NEW wallpaper first (don't unload yet!)
hyprctl hyprpaper preload "$WALL"
sleep 0.2

# Step B: Explicitly tell EVERY monitor to switch to the new wall
# Using the ",$WALL" syntax targets all monitors at once
hyprctl hyprpaper wallpaper ",$WALL"
sleep 0.2

# Step C: NOW unload the previous wallpapers to save RAM
# This ensures the transition is finished before clearing memory
hyprctl hyprpaper unload all
# Re-preload the current one so it's not accidentally cleared from the 'active' list
hyprctl hyprpaper preload "$WALL"

killall waybar
waybar &

# 5. Refresh Hyprland colors
hyprctl reload