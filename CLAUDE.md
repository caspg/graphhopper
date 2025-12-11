# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GraphHopper is a fast and memory-efficient open-source routing engine written in Java. This is a fork geared towards bicycle routing for Velomapa.pl. It calculates routes, distances, turn-by-turn instructions, and supports features like isochrones, map matching, and public transit routing.

## Build and Run Commands

### Build
```bash
mvn clean install -DskipTests
```

### Run Tests
```bash
# All tests
mvn clean test verify

# Single test class
mvn test -Dtest=ClassName

# Single test method
mvn test -Dtest=ClassName#methodName

# Tests in a specific module
mvn test -pl core
```

### Run Server Locally
```bash
# Download OSM data first (e.g., for pomorskie region)
wget https://download.geofabrik.de/europe/poland/pomorskie-latest.osm.pbf

# Build and run (remove graph-cache after code changes)
mvn clean install -DskipTests && rm -rf graph-cache && \
  java -Xmx8g -Xms8g -Ddw.graphhopper.datareader.file=pomorskie-latest.osm.pbf \
  -jar web/target/graphhopper-web-*.jar server config-velomapa.yml
```

### Docker
```bash
docker build --no-cache --tag 'caspg_gh' .
docker run -v ./gh-data:/data -p 8989:8989 caspg_gh --input /data/gdansk.pbf --host 0.0.0.0
```

## Architecture

### Module Structure
- **core**: Main routing engine, graph data structures, algorithms, OSM parsing, custom models
- **web**: Dropwizard-based HTTP server exposing routing API
- **web-api**: API request/response models
- **web-bundle**: Web resources and UI integration
- **client-hc**: Java HTTP client for GraphHopper API
- **reader-gtfs**: GTFS public transit data support
- **map-matching**: Snap GPS traces to road network
- **navigation**: Navigation/turn-by-turn instruction service
- **tools**: Measurement and utility tools
- **example**: Usage examples

### Key Concepts

**Routing Modes:**
- **Speed mode (CH)**: Pre-computed Contraction Hierarchies for fastest queries (configured via `profiles_ch`)
- **Hybrid mode (LM)**: Landmarks-based A* for flexible queries (configured via `profiles_lm`)
- **Flexible mode**: No preprocessing, full customization per request

**Custom Models:** JSON-based routing customization without Java code. Located in `core/src/main/resources/com/graphhopper/custom_models/`. Controls speed, priority, and distance_influence for route calculation.

**Encoded Values:** Road attributes stored per edge (road_class, surface, max_speed, bike_network, etc.). Configure in `graph.encoded_values` in config YAML.

**Graph Storage:** Edges and nodes stored in memory-mapped files. The `graph-cache` directory contains the preprocessed graph - delete it when changing profiles or encoded values.

### Key Classes
- `GraphHopper`: Main entry point for routing engine setup
- `GraphHopperApplication`: Dropwizard application class (web module)
- `CustomWeighting`: Applies custom model rules to edge weights
- `OSMReader`/`WaySegmentParser`: Parse OpenStreetMap data
- `RoutingCHGraph`: Contraction Hierarchies graph wrapper
- `LocationIndexTree`: Spatial index for coordinate-to-edge lookup

## Configuration

Main config file: `config-velomapa.yml` (fork-specific) or `config-example.yml` (upstream)

Key configuration sections:
- `graphhopper.profiles`: Define routing profiles with custom model files
- `graphhopper.profiles_ch`: Enable speed mode for profiles
- `graphhopper.graph.encoded_values`: Which attributes to extract from OSM
- `graphhopper.graph.elevation.provider`: Elevation data source (hgt, srtm, etc.)

## Code Style
- Java 17+
- 4-space indent, 100-char line width
- IntelliJ defaults
- Tests use JUnit 5
