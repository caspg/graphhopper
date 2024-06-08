function getRoutingApi() {
    if (location.pathname.startsWith("/graphhopper")) {
        return location.origin + '/graphhopper/'
    }

    return location.origin + '/'
}

const config = {
    routingApi: getRoutingApi(),
    geocodingApi: '',
    defaultTiles: 'OpenStreetMap',
    keys: {
        graphhopper: "",
        maptiler: "missing_api_key",
        omniscale: "missing_api_key",
        thunderforest: "missing_api_key",
        kurviger: "missing_api_key"
    },
    routingGraphLayerAllowed: true,
    request: {
        details: [
            'road_class',
            'road_environment',
            'max_speed',
            'average_speed',
        ],
        snapPreventions: ['ferry'],
    },
}
