FROM alpine

ENV SCALA_VERSION 2.12
ENV KAFKA_VERSION 2.2.1
ENV ZOOKEEPER_VERSION 3.4.14

WORKDIR /kafka
ADD install.sh /kafka/install
RUN /kafka/install

ADD wait-for-zookeeper.sh /kafka/bin
ADD start.sh /kafka/bin

# Share the same base image to reduce layers used in testing
FROM gcr.io/distroless/java:11-debug
MAINTAINER Zipkin "https://zipkin.io/"

WORKDIR /kafka

COPY --from=0 /kafka /kafka

# Port 19092 is for connections from the Docker host
EXPOSE 2181 9092 19092

ENTRYPOINT ["/busybox/sh", "/kafka/bin/start.sh"]
