# --- GSKiosk Boot & Reliability Sequence ---
# This block handles the startup of the Google Slides Kiosk. 
# It provides a 5-second maintenance abort window on tty1 and 
# ensures the kiosk automatically restarts if it crashes.
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  GSKIOSK_DIR="$HOME/google_slides_kiosk"
  export GSKIOSK_MODE="kiosk"

  # --- MAINTENANCE MENU (tty1) ---
  echo "----------------------------------------------------"
  echo "GSKiosk is starting..."
  echo "Press ANY KEY within 5 seconds to maintenance menu."
  echo "----------------------------------------------------"

  if read -n 1 -t 5; then
    echo -e "\n"
    echo "=========================================="
    echo "            MAINTENANCE MENU             "
    echo "=========================================="
    echo " 1) Launch Chromium Normally (UI enabled)"
    echo " 2) Exit to Terminal"
    echo "------------------------------------------"
    echo -n "Select option [1-2]: "
    read -n 1 choice
    echo -e "\n"

    case $choice in
      1)
        echo "Launching Chromium in normal mode..."
        export GSKIOSK_MODE="normal"
        touch "$GSKIOSK_DIR/.stop_gskiosk"
        ;;
      2)
        echo "Exiting to terminal..."
        return 0 2>/dev/null || exit 0
        ;;
      *)
        echo "Invalid selection. Starting kiosk..."
        ;;
    esac
  fi
  # -------------------------------

  # Reliability Loop: Keep the kiosk alive unless maintenance is requested
  while true; do
    # Run Cage (pointing it to your script)
    cage -s -- "$GSKIOSK_DIR/gskiosk.sh" > "$GSKIOSK_DIR/gskiosk_debug.log" 2>&1

    # Check for maintenance stop flag
    if [ -f "$GSKIOSK_DIR/.stop_gskiosk" ]; then
      rm -f "$GSKIOSK_DIR/.stop_gskiosk"
      echo "Maintenance mode detected. Returning to terminal."
      break
    fi


    echo "Kiosk/Cage exited unexpectedly. Restarting in 2 seconds..."
    sleep 2
  done
fi


