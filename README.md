# google_slides_kiosk
Fire-and-forget script to loop Google Slides presentation in full screen. Reloads the browser each day to present the latest version.

* In Google Slides: File --> Share --> Publish to Web
* nano slides_kiosk.sh
  * change <file_id> and delayms (advance interval)
  * set time to reload chromium
* chmod +x slides_kiosk.sh
* run: ./slides_kiosk.sh
