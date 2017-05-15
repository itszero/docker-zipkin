# Share the same base image to reduce layers used in testing
FROM openzipkin/jre-full:1.8.0_121
MAINTAINER OpenZipkin "http://zipkin.io/"

ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.2.1
ENV ZOOKEEPER_VERSION 3.4.9

WORKDIR /kafka
ADD install.sh /kafka/install
RUN /kafka/install

EXPOSE 2181 9092

CMD ["runsvdir", "/etc/service"]
