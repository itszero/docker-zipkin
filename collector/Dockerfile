FROM quay.io/openzipkin/zipkin-base:base-1.4.0
MAINTAINER OpenZipkin "http://zipkin.io/"

RUN curl -SL $ZIPKIN_REPO/io/zipkin/zipkin-collector-service/$ZIPKIN_VERSION/zipkin-collector-service-$ZIPKIN_VERSION-all.jar > zipkin-collector.jar

ADD run.sh /usr/local/bin/run.sh
ENTRYPOINT ["/usr/local/bin/run.sh"]

EXPOSE 9410
