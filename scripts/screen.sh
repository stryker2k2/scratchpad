#!/bin/bash
# set_monitors.sh
# Hard-coded script to restore a specific multi-monitor layout using xrandr.
# This script configures three displays: DP-0.2, DP-0.1, and eDP-1-0.

# -----------------------------------------------------------------------------
# Configuration Breakdown (Derived from the user's 'xrandr --current' output):
#
# 1. DP-0.2 (Portrait Left Monitor):
#    - Mode: 1920x1080 (Rotated resolution used in the mode list)
#    - Rate: 60.00 Hz (*)
#    - Position: 0x0
#    - Rotation: left
#
# 2. DP-0.1 (Center Monitor):
#    - Mode: 2560x1440
#    - Rate: 120.00 Hz (*)
#    - Position: 1080x240 (Offset to align vertically with the other screens)
#
# 3. eDP-1-0 (Primary Laptop Screen):
#    - Mode: 1920x1200
#    - Rate: 165.00 Hz (*)
#    - Position: 3640x360
#    - Status: Primary
# -----------------------------------------------------------------------------

# Start with a clean xrandr command
XRANDR_CMD="xrandr"

# 1. Configure DP-0.2 (Left, Rotated Portrait)
XRANDR_CMD+=" --output DP-0.2 --mode 1920x1080 --rate 60.00 --pos 0x0 --rotate left"

# 2. Configure DP-0.1 (Center, High Refresh Rate)
XRANDR_CMD+=" --output DP-0.1 --primary --mode 2560x1440 --rate 120.00 --pos 1080x240"

# 3. Configure eDP-1-0 (Right, Primary Laptop Screen)
XRANDR_CMD+=" --output eDP-1-0 --mode 1920x1200 --rate 165.00 --pos 3640x360"


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
