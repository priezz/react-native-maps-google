#!/usr/bin/env bash

mkdir -p ios_modules
cd ios_modules
curl "https://www.gstatic.com/cpdc/c0e534927c0c955e-GoogleMaps-1.11.1.tar.gz" -o "GoogleMaps-1.11.1.tar.gz"
rm -rf GoogleMaps-1.11.1
mkdir GoogleMaps-1.11.1
tar -zxf GoogleMaps-1.11.1.tar.gz -C GoogleMaps-1.11.1
rm GoogleMaps-1.11.1.tar.gz
