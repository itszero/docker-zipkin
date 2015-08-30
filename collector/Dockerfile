FROM quay.io/openzipkin/zipkin-base:base-1.5.1
MAINTAINER OpenZipkin "http://zipkin.io/"

RUN curl -SL $ZIPKIN_REPO/io/zipkin/zipkin-collector-service/$ZIPKIN_VERSION/zipkin-collector-service-$ZIPKIN_VERSION-all.jar > zipkin-collector.jar

ADD run.sh /usr/local/bin/run.sh
CMD /usr/local/bin/run.sh

EXPOSE 9410
