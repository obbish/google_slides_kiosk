# Check if we are on the physical screen (tty1) and not SSH
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  # Run Cage, pointing it to your script
  exec cage -s -- /home/globadmin/kiosk.sh > /home/globadmin/kiosk_debug.log 2>&1
fi
