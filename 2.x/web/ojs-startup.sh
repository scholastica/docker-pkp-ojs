#!/bin/bash
# Start the cron service in the background.
cron -f &
echo "[OJS Startup] Started cron"

# Run the apache process in the foreground as in the php image
echo "[OJS Startup] Starting apache..."
apache2-foreground
