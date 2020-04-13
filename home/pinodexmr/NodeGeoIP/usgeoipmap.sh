#!/bin/bash
python3 /home/pinodexmr/NodeGeoIP/usgeoipmap.py -i /home/pinodexmr/NodeGeoIP/IPoutput.txt --extents=-142.5/-56/7.6/56 --service m --db /home/pinodexmr/NodeGeoIP/GeoIPData/GeoLite2-City.mmdb --output=/var/www/html/usnodes.png

	#Update timestamp of when list last created
echo "Map last updated: " > /var/www/html/us-map-timestamp.txt
date >> /var/www/html/us-map-timestamp.txt