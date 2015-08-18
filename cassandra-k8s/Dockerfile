FROM gcr.io/google_containers/cassandra:v5
MAINTAINER Dana NicCaluim <dniccaluim@airware.com>

ADD https://raw.githubusercontent.com/openzipkin/zipkin/master/zipkin-cassandra-core/src/main/resources/cassandra-schema-cql3.txt cassandra-schema-cql3.txt
ADD install.sh /install.sh
RUN /install.sh

ENTRYPOINT ["/run.sh"]

EXPOSE 9160 7000 7001 9042 7199
