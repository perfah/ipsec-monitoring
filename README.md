# ipsec-monitoring
A set of libreswan-compatible bash scripts for monitoring ipsec tunnel status (e.g. send mail when tunnel is down)

The script looks for the 'unrouted' indicator in the output of the 'ipsec status' command.

## Setup using crontab:

Assuming repo is cloned to /opt/ipsec-monitoring, the scripts can be executed as follows:

### All VPN tunnels:

Usage: `/opt/ipsec-monitoring/monitor-all-tunnels.sh *MAIL ADDRESS*`

Crontab:
```
*/1 * * * *     /opt/ipsec-monitoring/monitor-all-tunnels.sh warning-recipient@mycompany.org >> /var/log/ipsec-monitoring.log
```
### A specific VPN tunnel


Usage: `/opt/ipsec-monitoring/monitor-tunnel.sh *TUNNEL NAME* *MAIL ADDRESS*`

Crontab:
```
*/1 * * * *     /opt/ipsec-monitoring/monitor-tunnel.sh CUSTOMER-1 warning-recipient@mycompany.org >> /var/log/ipsec-monitoring.log
```

### Additional considerations
```
chmod +x /opt/ipsec-monitoring/monitor-all-tunnels.sh
chmod +x /opt/ipsec-monitoring/monitor-tunnel.sh
```

## Logging

Log file /var/log/ipsec-monitoring.log could look like this:

```
** Monitoring check of all tunnels at Thu May  9 12:31:01 UTC 2024
Tunnel CUSTOMER-1 is still up
Tunnel CUSTOMER-2 is still up
Tunnel CUSTOMER-3 is now down, mail sent to *email_recipient*

** Monitoring check of all tunnels at Thu May  9 12:32:01 UTC 2024
Tunnel CUSTOMER-1 is still up
Tunnel CUSTOMER-2 is still up
Tunnel CUSTOMER-3 is now up, mail sent to *email_recipient*
```

I highly recommend log rotation.

## Automatic mail upon new offline status
Subject: 

```
(Monitoring) IPSec tunnel down on *host*: CUSTOMER-3
```

Body:
```
~ IPSec monitoring on *host*  ~
 The following tunnel is down:
000 "CUSTOMER-3": *left ip*...%any[@customer-3]===*right ip*; unrouted; eroute owner: #0
```
