# Share the same base image to reduce layers used in testing
FROM openzipkin/jre-full:1.8.0_152
MAINTAINER OpenZipkin "http://zipkin.io/"

ENV SCALA_VERSION 2.12
ENV KAFKA_VERSION 1.1.0
ENV ZOOKEEPER_VERSION 3.4.10

WORKDIR /kafka
ADD install.sh /kafka/install
RUN /kafka/install

EXPOSE 2181 9092

CMD ["runsvdir", "/etc/service"]
