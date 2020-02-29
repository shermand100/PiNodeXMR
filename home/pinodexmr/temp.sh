#!/bin/sh
#CPU temp Status
{ sudo cat /sys/class/thermal/thermal_zone1/temp & echo "Updates every 60 seconds" & date; } > /var/www/html/temp.txt