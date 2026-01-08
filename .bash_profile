# Check if we are on the physical screen (tty1) and not SSH
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  KIOSK_SCRIPT="$HOME/gskiosk.sh"
  STOP_FLAG="$HOME/.stop_gskiosk"
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
        touch "$STOP_FLAG"
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
    cage -s -- "$KIOSK_SCRIPT" > "$HOME/gskiosk_debug.log" 2>&1

    # Check for maintenance stop flag
    if [ -f "$STOP_FLAG" ]; then
      rm -f "$STOP_FLAG"
      echo "Maintenance mode detected. Returning to terminal."
      break
    fi

    echo "Kiosk/Cage exited unexpectedly. Restarting in 2 seconds..."
    sleep 2
  done
fi


