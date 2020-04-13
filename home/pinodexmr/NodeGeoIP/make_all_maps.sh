#!/bin/sh
echo "Building World Map"
. /home/pinodexmr/NodeGeoIP/worldgeoipmap.sh;
echo "Building USA Map"
. /home/pinodexmr/NodeGeoIP/usgeoipmap.sh;
echo "Building United Kingdom Map"
. /home/pinodexmr/NodeGeoIP/ukgeoipmap.sh;
echo "Building Europe Map"
. /home/pinodexmr/NodeGeoIP/europegeoipmap.sh