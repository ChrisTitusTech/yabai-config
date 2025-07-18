#!/bin/sh

# Check for wired connection with valid IP on any ethernet interface
WIRED_IP=$(ifconfig | grep -E '^en[0-9]+:' -A 10 | grep 'inet ' | grep -v '127.0.0.1' | head -1 | awk '{print $2}')

# Check for WiFi connection
SSID=$(system_profiler SPAirPortDataType | awk '/Current Network Information:/ { getline; print substr($0, 13, (length($0) - 13)); exit }')

# Determine connection status and display
if [ "$WIRED_IP" != "" ]; then
  # Wired connection is active with valid IP
  sketchybar --set $NAME icon="􀌗" label="Wired"
elif [ "$SSID" != "" ]; then
  # WiFi connection is active
  sketchybar --set $NAME icon="􀙇" label="$SSID"
else
  # No connection
  sketchybar --set $NAME icon="�" label="Disconnected"
fi