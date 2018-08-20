# Share the same base image to reduce layers used in testing
FROM openzipkin/jre-full:1.8.0_171
MAINTAINER OpenZipkin "http://zipkin.io/"

ENV SCALA_VERSION 2.12
ENV KAFKA_VERSION 2.0.0
ENV ZOOKEEPER_VERSION 3.4.13

WORKDIR /kafka
ADD install.sh /kafka/install
RUN /kafka/install

# Port 19092 is for connections from the Docker host
EXPOSE 2181 9092 19092

CMD ["runsvdir", "/etc/service"]
