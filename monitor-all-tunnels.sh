#!/bin/bash

tunnel_names=$(ipsec status | ack -o '(?<=^000 ")[^"/]*' | sort | uniq)

echo "** Monitoring check of all tunnels at $(date)"

while IFS= read -r tunnel_name; do
    /opt/ipsec-monitoring/monitor-tunnel.sh "$tunnel_name"
done <<< "$tunnel_names"