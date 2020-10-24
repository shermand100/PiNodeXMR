#!/bin/bash
python3 /home/pinodexmr/NodeGeoIP/ukgeoipmap.py -i /home/pinodexmr/NodeGeoIP/IPoutput.txt --extents=-12.1/3/49.5/59.4 --service m --db /home/pinodexmr/NodeGeoIP/GeoIPData/GeoLite2-City.mmdb --output=/var/www/html/uknodes.png

	#Update timestamp of when list last created
echo "Map last updated: " > /var/www/html/uk-map-timestamp.txt
date >> /var/www/html/uk-map-timestamp.txt