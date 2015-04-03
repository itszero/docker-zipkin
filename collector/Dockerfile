FROM itszero/zipkin-base
MAINTAINER Zero Cho "http://itsze.ro"

ADD /var/tmp/knewton/tdist-zipkin/tdist-zipkin.jar /

ADD run.sh /usr/local/bin/run
ENTRYPOINT ["/usr/local/bin/run"]

EXPOSE 9410
