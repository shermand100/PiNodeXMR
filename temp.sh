#!/bin/sh
#CPU temp Status
{ sudo /opt/vc/bin/vcgencmd measure_temp & echo "Updates every 60 seconds" & date; } > /var/www/html/temp.txt