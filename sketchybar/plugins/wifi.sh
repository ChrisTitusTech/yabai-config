#!/bin/sh

# Check for wired connection with valid IP (excluding WiFi interfaces)
# Get WiFi interface name from networksetup
WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

WIRED_IP=$(for iface in $(ifconfig -l | tr ' ' '\n' | grep '^en[0-9]'); do
    # Skip if this is the WiFi interface
    if [ "$iface" = "$WIFI_INTERFACE" ]; then
        continue
    fi
    # Check for active connection with valid IP
    ifconfig "$iface" 2>/dev/null | grep 'inet ' | grep -v '127.0.0.1' | head -1 | awk '{print $2}'
done | head -1)

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