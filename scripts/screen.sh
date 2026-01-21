#!/bin/bash
# set_monitors.sh
# Hard-coded script to restore a specific multi-monitor layout using xrandr.
# This script configures two displays: DP-4-1 and DP-4-2.
# The laptop display (eDP-1) is disconnected/disabled in this configuration.

# -----------------------------------------------------------------------------
# Configuration Breakdown (Derived from the user's 'xrandr --current' output):
#
# 1. DP-4-1 (Left Monitor / Primary):
#    - Mode: 1920x1080
#    - Rate: 60.00 Hz (*)
#    - Position: 0x0
#    - Status: Primary
#
# 2. DP-4-2 (Right Monitor):
#    - Mode: 1920x1080
#    - Rate: 60.00 Hz (*)
#    - Position: 1920x0 (Adjacent to the right of DP-4-1)
#
# 3. eDP-1 (Laptop Screen):
#    - Status: Connected but not active (no mode/position shown)
# -----------------------------------------------------------------------------

# Start with a clean xrandr command
XRANDR_CMD="xrandr"

# 1. Configure DP-4-1 (Left, Primary)
XRANDR_CMD+=" --output DP-4-1 --primary --mode 1920x1080 --rate 60.00 --pos 0x0 --rotate normal"

# 2. Configure DP-4-2 (Right)
XRANDR_CMD+=" --output DP-4-2 --mode 1920x1080 --rate 60.00 --pos 1920x0 --rotate normal"

# 3. Disable eDP-1 (Laptop Screen - not in use)
XRANDR_CMD+=" --output eDP-1 --off"


echo "Applying xrandr configuration..."
echo "Running command: $XRANDR_CMD"

# Execute the command
$XRANDR_CMD

# Check the exit status of the xrandr command
if [ $? -eq 0 ]; then
    echo "Configuration applied successfully."
else
    echo "Error: xrandr command failed. Check the parameters above."
fi