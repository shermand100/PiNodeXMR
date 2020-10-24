#!/bin/sh
echo "IP_Address	City	Region	Country	Latitude	Longitude" > /var/www/html/IPGEO-CSV.txt && while read line; do ip2geotools -d maxmindgeolite2city --db_path /home/pinodexmr/NodeGeoIP/GeoIPData/GeoLite2-City.mmdb -f csv-tab $line; done < /home/pinodexmr/NodeGeoIP/IPoutput.txt | tee -a /var/www/html/IPGEO-CSV.txt
##Explain:
##First section (before &&) Is headers for the table. Also using single '>' overwrites previous file. Starting fresh.
##Second While read do. Loops and reads the list of ip IP adresses inputted < line by line. Each line (IP) is then processed by 'dp' ip2geotools
##Ip2geotools loads the maxmind-geolite2city database and compares the IP sent to it. Output produced is in format (-f) csv with tab separator.
##Output is then appended -a (not overwritten) to RAW_IP-GEO-location.txt and displayed at console for progress