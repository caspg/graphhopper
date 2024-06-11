# based on https://github.com/IsraelHikingMap/graphhopper-docker-image-push
FROM maven:3.9.5-eclipse-temurin-21 as build

WORKDIR /graphhopper

COPY . .

# TODO(kacper): do not skip tests
# this can be removed after https://github.com/graphhopper/graphhopper/pull/3015
# is merged to master and to this fork.
RUN mvn clean install -DskipTests

FROM eclipse-temurin:21.0.1_12-jre

ARG JAVA_OPTS "-Xmx1g -Xms1g"
ENV JAVA_OPTS $JAVA_OPTS

WORKDIR /graphhopper

COPY --from=build /graphhopper/web/target/graphhopper*.jar ./

COPY docker_entrypoint.sh config-velomapa.yml ./

HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:8989/health || exit 1

ENTRYPOINT [ "./docker_entrypoint.sh", "-c", "config-velomapa.yml" ]
