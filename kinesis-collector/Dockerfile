FROM itszero/zipkin-base
MAINTAINER Zero Cho "http://itsze.ro"

COPY tdist-zipkin-collector.jar /

ADD run.sh /usr/local/bin/run
ENTRYPOINT ["/usr/local/bin/run"]

EXPOSE 9410 9903 