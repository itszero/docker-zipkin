# We need a JRE to run Cassandra for setting up its schema.
FROM openjdk:8-jre-alpine

ENV CASSANDRA_VERSION 3.11.4
ENV ZIPKIN_VERSION 2.14.1

# Temporarily hard-code zipkin's configuration to a class that looks up the container's IP
ADD ZipkinConfigurationLoader.class /cassandra/build/classes/main/ZipkinConfigurationLoader.class
ENV JVM_OPTS="-Dcassandra -Dcassandra.config.loader=ZipkinConfigurationLoader -Djava.net.preferIPv4Stack=true"

ADD install.sh /usr/local/bin/install
RUN /usr/local/bin/install

# Share the same base image to reduce layers used in testing
FROM gcr.io/distroless/java:11-debug
MAINTAINER Zipkin "https://zipkin.io/"

ENV JVM_OPTS="-Dcassandra -Dcassandra.config.loader=ZipkinConfigurationLoader -Djava.net.preferIPv4Stack=true"

RUN ["/busybox/sh", "-c", "adduser -g '' -D cassandra"]

COPY --from=0 --chown=cassandra /cassandra /cassandra

# cassandra complains if run as root
USER cassandra

ADD run.sh /usr/local/bin/run.sh
ENTRYPOINT ["/busybox/sh", "/usr/local/bin/run.sh"]

EXPOSE 9160 7000 7001 9042 7199
