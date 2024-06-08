#!/usr/bin/env bash
set -e

# wget https://download.geofabrik.de/europe-latest.osm.pbf

java -Xmx32g -Xms32g -Ddw.graphhopper.datareader.file=europe-latest.osm.pbf -jar web/target/graphhopper-web-*.jar server config-example.yml
