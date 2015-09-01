FROM quay.io/openzipkin/zipkin-base:base-1.4.0
MAINTAINER OpenZipkin "http://zipkin.io/"

RUN curl -SL $ZIPKIN_REPO/io/zipkin/zipkin-web/$ZIPKIN_VERSION/zipkin-web-$ZIPKIN_VERSION-all.jar > zipkin-web.jar

ADD run.sh /usr/local/bin/run
ENTRYPOINT ["/usr/local/bin/run"]

EXPOSE 8080
