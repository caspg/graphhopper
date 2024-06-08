#!/usr/bin/env bash
set -e

pbf_file="europe-latest.osm.pbf"

if [ ! -e "$pbf_file" ]; then
    echo "File does not exist. Downloading..."
    wget https://download.geofabrik.de/europe-latest.osm.pbf
fi

java -Xmx32g -Xms32g -Ddw.graphhopper.datareader.file=$pbf_file -jar web/target/graphhopper-web-*.jar server config-example.yml 2>&1 | tee logs.txt
