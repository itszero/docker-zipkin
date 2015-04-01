FROM itszero/zipkin-base
MAINTAINER Zero Cho "http://itsze.ro"

ADD setup_collector.sh
RUN chmod +x setup_collector.sh

ADD run.sh /usr/local/bin/run
ENTRYPOINT ["/usr/local/bin/run"]

EXPOSE 9410
