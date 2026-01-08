#!/bin/bash

# --- CONFIGURATION ---
# The URL to display in kiosk mode (e.g., your published Google Slides link)
URL="YOUR_URL_HERE"

# How often to refresh the page (in seconds)
REFRESH_INTERVAL=600

# Default URL for Normal Mode (Maintenance)
NORMAL_URL="https://www.google.com"

# Chromium Kiosk Flags (for public display)
KIOSK_FLAGS=(
  --kiosk
  --noerrdialogs
  --disable-infobars
  --check-for-update-interval=31536000
  --ozone-platform=wayland
  --enable-features=OverlayScrollbar
  --start-maximized
  --disable-session-crashed-bubble
  --disable-features=Translate
  --no-first-run
  --fast
  --disable-pinch
  --overscroll-history-navigation=0
  --password-store=basic
)

# Chromium Normal Flags (for maintenance)
NORMAL_FLAGS=(
  --ozone-platform=wayland
  --enable-features=OverlayScrollbar
  --start-maximized
  --no-first-run
)
# ---------------------

# 1. Environment Tweaks
export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland

# 2. Cleanup locks
rm -rf ~/.config/chromium/Singleton*

# --- LAUNCH LOGIC ---
if [ "$GSKIOSK_MODE" = "normal" ]; then
    echo "Launching Chromium in normal mode..."
    chromium "${NORMAL_FLAGS[@]}" "$NORMAL_URL"
    exit 0
fi

# Kiosk Mode (Default)
echo "Starting GSKiosk in public mode..."

# 3. Start the "Refresh Timer" in the background
(
  while true; do
    sleep $REFRESH_INTERVAL
    # Send the F5 key press to the active window (Chromium)
    wtype -k F5
  done
) &
REFRESH_PID=$!

# Ensure we kill the timer if the script exits
trap "kill $REFRESH_PID; rm -f ~/.config/chromium/Singleton*" EXIT

# 4. The Chromium Loop
while true; do
   chromium "${KIOSK_FLAGS[@]}" "$URL"
   sleep 2
done



