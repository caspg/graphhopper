#!/usr/bin/env bash
set -e

# Run below command if there was any change in the source:
# mvn clean install -DskipTests

pbf_file="poland-latest.osm.pbf"

if [ ! -e "$pbf_file" ]; then
    echo "File does not exist. Downloading..."
    wget https://download.geofabrik.de/europe/poland-latest.osm.pbf
fi

# its for reverse proxy that is is setup by Docker
# bind_host=172.17.0.1

java -Xmx32g -Xms32g \
  -Ddw.graphhopper.datareader.file=$pbf_file \
  -Ddw.server.application_connectors[0].bind_host=172.17.0.1 \
  -jar web/target/graphhopper-web-*.jar server config-example.yml 2>&1 | tee logs.txt
