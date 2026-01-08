#!/bin/bash

# --- CONFIGURATION ---
# How often to refresh the page (in seconds)
REFRESH_INTERVAL=600
# ---------------------

# 1. Environment Tweaks
export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland

# 2. Cleanup locks
rm -rf ~/.config/chromium/Singleton*

# 3. Start the "Refresh Timer" in the background
# This runs alongside Chromium. Every N seconds, it simulates pressing F5.
(
  while true; do
    sleep $REFRESH_INTERVAL
    # Send the F5 key press to the active window (Chromium)
    wtype -k F5
  done
) &
# Save the background process ID so we can kill it if this script stops
REFRESH_PID=$!

# Ensure we kill the timer if the script exits (Ctrl+C)
trap "kill $REFRESH_PID" EXIT

# 4. The Chromium Loop
while true; do
   chromium \
      --kiosk \
      --noerrdialogs \
      --disable-infobars \
      --check-for-update-interval=31536000 \
      --ozone-platform=wayland \
      --enable-features=OverlayScrollbar \
      --start-maximized \
      --disable-session-crashed-bubble \
      --disable-features=Translate \
      --no-first-run \
      --fast \
      --disable-pinch \
      --overscroll-history-navigation=0 \
      --password-store=basic \
      \
      "https://docs.google.com/presentation/d/e/2PACX-1vQKbj7MTaqwAyb6kH45I-FpxTb4A0MLT7ZkYGeHVGCUHPwpoqsa7sVpoMRPEwAZSvx5UihBkPBclK5b/pub?start=true&loop=true&delayms=15000"
      
   sleep 2
done
