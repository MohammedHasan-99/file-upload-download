#!/bin/bash

# Enable debugging mode (optional, for debugging purposes)
set -e

# Log file setup
LOG_FILE="log.txt"
echo "Logging server start..." > "$LOG_FILE"
echo "Logging server start..."

# Fetch the current device IP address (excluding loopback address)
echo "Fetching current device IP address..." >> "$LOG_FILE"
echo "Fetching current device IP address..."

DEVICE_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)

# Log the fetched IP address
if [[ -n "$DEVICE_IP" ]]; then
    echo "Current device IP address: $DEVICE_IP" >> "$LOG_FILE"
    echo "Current device IP address: $DEVICE_IP"
else
    echo "Failed to retrieve the current device IP address." >> "$LOG_FILE"
    echo "Failed to retrieve the current device IP address."
    exit 1
fi

# Navigate to the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || {
    echo "Failed to change directory to $SCRIPT_DIR" >> "$LOG_FILE"
    echo "Failed to change directory to $SCRIPT_DIR"
    exit 1
}

echo "Successfully changed directory to $SCRIPT_DIR" >> "$LOG_FILE"
echo "Successfully changed directory to $SCRIPT_DIR"

# Start the server using npm and pass the IP address and port
echo "Starting server with IP: $DEVICE_IP on port 3000..." >> "$LOG_FILE"
echo "Starting server with IP: $DEVICE_IP on port 3000..."
npm start "$DEVICE_IP" 3000

# Wait a few seconds to let the server start
sleep 5

# Output the clickable link in the console
echo >> "$LOG_FILE"
echo "Server started successfully. You can access it at: http://$DEVICE_IP:3000" >> "$LOG_FILE"
echo "Server started successfully. You can access it at: http://$DEVICE_IP:3000"