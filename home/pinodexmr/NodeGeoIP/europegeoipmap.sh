#!/bin/bash
python3 /home/pinodexmr/NodeGeoIP/europegeoipmap.py -i /home/pinodexmr/NodeGeoIP/IPoutput.txt --extents=-12/45/30/65 --service m --db /home/pinodexmr/NodeGeoIP/GeoIPData/GeoLite2-City.mmdb --output=/var/www/html/europenodes.png,

	#Update timestamp of when list last created
echo "Map last updated: " > /var/www/html/europe-map-timestamp.txt
date >> /var/www/html/europe-map-timestamp.txt
