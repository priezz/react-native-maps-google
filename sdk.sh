#!/usr/bin/env bash

mkdir -p ios_modules
cd ios_modules
curl "https://www.gstatic.com/cpdc/aa3052925ceeea2d-GoogleMaps-1.13.2.tar.gz" -o "GoogleMaps-1.13.2.tar.gz"
rm -rf GoogleMaps-1.13.2
mkdir GoogleMaps-1.13.2
tar -zxf GoogleMaps-1.13.2.tar.gz -C GoogleMaps-1.13.2
rm GoogleMaps-1.13.2.tar.gz
