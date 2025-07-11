#!/bin/bash
# Nothing Ear Waybar Module Script (modified to detect JBL LIVE660NC)
# Shows Headphone icon with status colors and sends notifications

DEVICE_MAC="40:72:18:7D:0A:69"  # JBL LIVE660NC MAC address
STATE_FILE="/tmp/jbl_headphones_state"

# Create state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "unknown" > "$STATE_FILE"
fi

# Get previous state
PREV_STATE=$(cat "$STATE_FILE")

# Check if device is connected
is_connected() {
    bluetoothctl info "$DEVICE_MAC" 2>/dev/null | grep -q "Connected: yes"
}

# Check if device exists (is paired)
device_exists() {
    bluetoothctl devices 2>/dev/null | grep -q "$DEVICE_MAC"
}

# Send notification function - only used for initial status changes, not for user-initiated actions
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="$3"  # low, normal, critical
    
    # Only send notifications for background changes (not from clicking the icon)
    # This helps prevent duplicate notifications
    if [ ! -f "/tmp/jbl_user_action" ] || [ $(( $(date +%s) - $(stat -c %Y /tmp/jbl_user_action) )) -gt 5 ]; then
        notify-send --app-name="JBL Headphones" --urgency="$urgency" "$title" "$message"
    fi
}

# Main function
main() {
    if ! device_exists; then
        # Device not paired - show grey icon
        echo '{"text": "󰋋", "tooltip": "JBL LIVE660NC: Not Paired", "class": "disconnected"}'
        
        # Only notify if status changed
        if [ "$PREV_STATE" != "notpaired" ]; then
            send_notification "JBL Headphones Not Found" "Device not paired with system" "normal"
            echo "notpaired" > "$STATE_FILE"
        fi
    elif is_connected; then
        # Device connected - show green icon
        # Get battery level if available
        battery_info=$(bluetoothctl info "$DEVICE_MAC" 2>/dev/null | grep "Battery Percentage" | grep -o '[0-9]*' | head -1)
        if [ -n "$battery_info" ]; then
            tooltip="JBL LIVE660NC: Connected (${battery_info}%)"
            
            # Only notify if status changed and not from user action
            if [ "$PREV_STATE" != "connected" ]; then
                send_notification "JBL Headphones Connected" "Battery level: ${battery_info}%" "normal"
                echo "connected" > "$STATE_FILE"
            fi
        else
            tooltip="JBL LIVE660NC: Connected"
            
            # Only notify if status changed and not from user action
            if [ "$PREV_STATE" != "connected" ]; then
                send_notification "JBL Headphones Connected" "Connection established" "normal"
                echo "connected" > "$STATE_FILE"
            fi
        fi
        echo '{"text": "󰋋", "tooltip": "'"$tooltip"'", "class": "connected"}'
    else
        # Device paired but not connected - show grey icon
        echo '{"text": "󰋋", "tooltip": "JBL LIVE660NC: Disconnected", "class": "disconnected"}'
        
        # Only notify if status changed and not from user action
        if [ "$PREV_STATE" != "disconnected" ]; then
            send_notification "JBL Headphones Disconnected" "Click the icon to reconnect" "low"
            echo "disconnected" > "$STATE_FILE"
        fi
    fi
}

main