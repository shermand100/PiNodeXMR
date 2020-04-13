#!/usr/bin/env python
# coding: utf-8

from __future__ import print_function, unicode_literals, with_statement
import argparse
import contextlib
import requests
import sys
import csv
import matplotlib
# Anti-Grain Geometry (AGG) backend so PyGeoIpMap can be used 'headless'
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
import geoip2.database

def get_ip(ip_file):
    """
    Returns a list of IP addresses from a file containing one IP per line.
    """
    with contextlib.closing(ip_file):
        return [line.strip() for line in ip_file]


def get_lat_lon(api_key, ip_list=[], lats=[], lons=[]):
    """
    This function connects to the FreeGeoIP web service to get info from
    a list of IP addresses.
    Returns two lists (latitude and longitude).
    """
    print("Processing {} IPs...".format(len(ip_list)))
    for ip in ip_list:
        r = requests.get("http://api.ipstack.com/" + ip + "?access_key=" + api_key)
        json_response = r.json()
        print("{ip}, {region_name}, {country_name}, {latitude}, {longitude}".format(**json_response))
        if json_response['latitude'] and json_response['longitude']:
            lats.append(json_response['latitude'])
            lons.append(json_response['longitude'])
    return lats, lons


def geoip_lat_lon(gi, ip_list=[], lats=[], lons=[]):
    """
    This function uses the MaxMind library and databases to geolocate IP addresses
    Returns two lists (latitude and longitude).
    """
    print("Processing {} IPs...".format(len(ip_list)))
    for ip in ip_list:
        try:
            r = gi.city(ip)
        except Exception:
            print("Unable to locate IP: %s" % ip)
            continue
        if r is None or r.location.latitude is None or r.location.longitude is None:
            print("Unable to find lat/long for IP: %s" % ip)
            continue
        #print("%s {country_code} {latitude}, {longitude}".format(**r) % ip)
        lats.append(r.location.latitude)
        lons.append(r.location.longitude)
    return lats, lons


def get_lat_lon_from_csv(csv_file, lats=[], lons=[]):
    """
    Retrieves the last two rows of a CSV formatted file to use as latitude
    and longitude.
    Returns two lists (latitudes and longitudes).

    Example CSV file:
    119.80.39.54, Beijing, China, 39.9289, 116.3883
    101.44.1.135, Shanghai, China, 31.0456, 121.3997
    219.144.17.74, Xian, China, 34.2583, 108.9286
    64.27.26.7, Los Angeles, United States, 34.053, -118.2642
    """
    with contextlib.closing(csv_file):
        reader = csv.reader(csv_file)
        for row in reader:
            lats.append(row[-2])
            lons.append(row[-1])

    return lats, lons


def generate_map(output, lats=[], lons=[], wesn=None):
    """
    Using Basemap and the matplotlib toolkit, this function generates a map and
    puts a red dot at the location of every IP addresses found in the list.
    The map is then saved in the file specified in `output`.
    """
    print("Generating map and saving it to {}".format(output))
    if wesn:
        wesn = [float(i) for i in wesn.split('/')]
        m = Basemap(projection='cyl', resolution='f',
                llcrnrlon=wesn[0], llcrnrlat=wesn[2],
                urcrnrlon=wesn[1], urcrnrlat=wesn[3])
    else:
        m = Basemap(projection='cyl', resolution='f')
    m.bluemarble()
    m.drawcountries(linewidth=0.1)
    x, y = m(lons, lats)
    m.scatter(x, y, s=0.5, color='#ff0000', marker='.', alpha=0.3)
    plt.savefig(output, dpi=450, bbox_inches='tight')


def main():
    parser = argparse.ArgumentParser(description='Visualize community on a map.')
    parser.add_argument('-i', '--input', dest="input", type=argparse.FileType('r'),
            help='Input file. One IP per line or, if FORMAT set to \'csv\', CSV formatted file ending with latitude and longitude positions',
            default=sys.stdin)
    parser.add_argument('-o', '--output', default='output.png', help='Path to save the file (e.g. /tmp/output.png)')
    parser.add_argument('-a', '--apikey', help='API-KEY from ipstack.com')
    parser.add_argument('-f', '--format', default='ip', choices=['ip', 'csv'], help='Format of the input file.')
    parser.add_argument('-s', '--service', default='f', choices=['f','m'], help='Geolocation service (f=ipstack, m=MaxMind local database)')
    parser.add_argument('-db', '--db', default='./GeoLiteCity.dat', help='Full path to MaxMind database file (default = ./GeoLiteCity.dat)')
    parser.add_argument('--extents', default=None, help='Extents for the plot (west/east/south/north). Default global.')
    args = parser.parse_args()

    output = args.output

    if args.format == 'ip':
        ip_list = get_ip(args.input)
        if args.service == 'm':
            gi = geoip2.database.Reader(args.db)
            lats, lons = geoip_lat_lon(gi, ip_list)
        else:  # default service
            if args.apikey:
                lats, lons = get_lat_lon(args.apikey,ip_list)
            else:
                print("You need the API-KEY!!")
                exit(1)
    elif args.format == 'csv':
        lats, lons = get_lat_lon_from_csv(args.input)

    generate_map(output, lats, lons, wesn=args.extents)


if __name__ == '__main__':
    main()
