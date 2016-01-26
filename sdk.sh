#!/usr/bin/env bash

mkdir -p ios_modules
cd ios_modules
curl "https://www.gstatic.com/cpdc/8cb64655838d3eb7-GoogleMaps-1.10.4.tar.gz" -o "GoogleMaps-1.10.4.tar.gz"
rm -rf GoogleMaps-1.10.4
mkdir GoogleMaps-1.10.4
tar -zxf GoogleMaps-1.10.4.tar.gz -C GoogleMaps-1.10.4
rm GoogleMaps-1.10.4.tar.gz
