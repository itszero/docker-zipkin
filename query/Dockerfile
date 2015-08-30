FROM quay.io/openzipkin/zipkin-base:base-1.5.1
MAINTAINER OpenZipkin "http://zipkin.io/"

RUN curl -SL $ZIPKIN_REPO/io/zipkin/zipkin-query-service/$ZIPKIN_VERSION/zipkin-query-service-$ZIPKIN_VERSION-all.jar > zipkin-query.jar

ADD run.sh /usr/local/bin/run.sh
CMD /usr/local/bin/run.sh

EXPOSE 9411
