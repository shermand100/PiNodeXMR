#!/bin/sh
#SSD Status
df -h | grep -E -- 'File|^/dev/' > /var/www/html/df-h.txt