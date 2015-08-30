FROM quay.io/openzipkin/zipkin-base:base-1.5.1
MAINTAINER OpenZipkin "http://zipkin.io/"

ENV CASSANDRA_VERSION 2.1.9

ADD install.sh /usr/local/bin/install
RUN /usr/local/bin/install
ADD run.sh /usr/local/bin/run
CMD "/usr/local/bin/run"

EXPOSE 9160 7000 7001 9042 7199
