#!/bin/bash
python3 /home/pinodexmr/NodeGeoIP/worldgeoipmap.py -i /home/pinodexmr/NodeGeoIP/IPoutput.txt --service m --db /home/pinodexmr/NodeGeoIP/GeoIPData/GeoLite2-City.mmdb --output=/var/www/html/worldnodes.png

	#Update timestamp of when list last created
echo "Map last updated: " > /var/www/html/world-map-timestamp.txt
date >> /var/www/html/world-map-timestamp.txt