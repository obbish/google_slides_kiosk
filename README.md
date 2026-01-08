# GSKiosk

A robust, Wayland-based Google Slides Kiosk for Raspberry Pi (and other minimal Linux systems). Designed for public displays, featuring automatic recovery and a built-in maintenance mode.

## Features

- **High Reliability**: Double-layered watchdog ensures the kiosk restarts if Chromium or the compositor crashes.
- **Maintenance Mode**: A 5-second abort window at startup to launch a normal browser or exit to the terminal.
- **Auto-Refresh**: Automatically simulates F5 key-presses to keep the presentation up-to-date.
- **Wayland Native**: Optimized for performance using `cage` and `chromium-browser`.

## Prerequisites

- **OS**: Raspberry Pi OS Lite (or any minimal Linux with Wayland support).
- **Packages**: `chromium-browser`, `cage`, `wtype`.
  ```bash
  sudo apt update && sudo apt install chromium-browser cage wtype
  ```

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/google_slides_kiosk.git ~/google_slides_kiosk
   cd ~/google_slides_kiosk
   ```

2. **Configure your presentation**:
   Edit `gskiosk.sh` and paste your published Google Slides link into the `URL` variable.
   ```bash
   nano gskiosk.sh
   ```

3. **Set up auto-run**:
   Copy the content of `.bash_profile` to your own `~/.bash_profile`. This will trigger the kiosk automatically when you log in (on `tty1`).
   ```bash
   cat .bash_profile >> ~/.bash_profile
   ```

## Usage

### Public Kiosk
By default, the system boots into GSKiosk after a 5-second countdown. It will stay full-screen and refresh every 10 minutes (configurable).

### Maintenance Mode
During the initial 5-second countdown, press **ANY KEY** on a physical keyboard to see the maintenance menu:
1.  **Launch Chromium Normally**: Opens the browser with the address bar and standard UI for quick checks.
2.  **Exit to Terminal**: Returns you to the bash prompt for system maintenance.

## Configuration

Settings can be found at the top of `gskiosk.sh`:
- `URL`: Your presentation link.
- `REFRESH_INTERVAL`: Seconds between automatic page refreshes.
- `KIOSK_FLAGS`: Custom Chromium arguments for the public display.
