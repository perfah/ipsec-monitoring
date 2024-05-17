#!/bin/bash

email_recipient="$2"

# File to store the previous tunnel status
status_file="/opt/ipsec-monitoring/tunnelstatus/$1.txt"

touch "$status_file"

# Function to check if IPsec tunnel is down
is_tunnel_down() {
    # Command to check IPsec tunnel status (replace with your own command)
    ipsec status | grep "$1" | grep -q "unrouted"
    return $?
}

# Function to send email notification
send_email_notification() {
    # Email configuration:
    subject="(Monitoring) IPSec tunnel $2 on $(hostname): $1"
    body="~ IPSec monitoring on $(hostname)  ~ \n Tunnel $1 is now $2, detail                                                                                                                                                             s:  \n\n  $(ipsec status | grep "$1" | grep "unrouted")"

    echo -e "$body" | mail -s "$subject" "$email_recipient"
}

# Read previous status from file
previous_status=$(cat "$status_file" 2>/dev/null)

# Check if IPsec tunnel is down
is_tunnel_down "$1"
current_status=$?

# Send email notification if tunnel goes down for the first time
if [ $current_status -eq 0 ] && [ "$previous_status" != "down" ]; then
    echo "Tunnel $1 is now down. Sending email to $email_recipient"
    send_email_notification "$1" "down"
elif [ $current_status -ne 0 ] && [ "$previous_status" == "down" ]; then
    echo "Tunnel $1 is now up. Sending email to $email_recipient"
    send_online_notification "$1" "up"
elif [ $current_status -eq 0 ]; then
    echo "Tunnel $1 status is still down"
elif [ $current_status -ne 0 ]; then
    echo "Tunnel $1 status is still up"
fi

# Update previous status in file
if [ $current_status -eq 0 ]; then
    echo "down" > "$status_file"
else
    echo "up" > "$status_file"
fi
