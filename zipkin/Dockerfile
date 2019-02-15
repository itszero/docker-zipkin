#
# Copyright 2015-2016 The OpenZipkin Authors
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
# in compliance with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under
# the License.
#
FROM openzipkin/jre-full:1.8.0_191
MAINTAINER OpenZipkin "http://zipkin.io/"

ENV ZIPKIN_REPO https://jcenter.bintray.com
ENV ZIPKIN_VERSION 2.12.1

# Use to set heap, trust store or other system properties.
ENV JAVA_OPTS -Djava.security.egd=file:/dev/./urandom

# Add environment settings for supported storage types
COPY zipkin/ /zipkin/
WORKDIR /zipkin

RUN apk add unzip --no-cache && \
    curl -SL $ZIPKIN_REPO/io/zipkin/java/zipkin-server/$ZIPKIN_VERSION/zipkin-server-$ZIPKIN_VERSION-exec.jar > zipkin-server.jar && \
    # don't break when unzip finds an extra header https://github.com/openzipkin/zipkin/issues/1932
    unzip zipkin-server.jar ; \
    rm zipkin-server.jar && \
    curl -SL $ZIPKIN_REPO/io/zipkin/java/zipkin-autoconfigure-collector-scribe/$ZIPKIN_VERSION/zipkin-autoconfigure-collector-scribe-$ZIPKIN_VERSION-module.jar > scribe.jar && \
    unzip scribe.jar -d scribe && \
    rm scribe.jar && \
    curl -SL $ZIPKIN_REPO/io/zipkin/java/zipkin-autoconfigure-collector-kafka08/$ZIPKIN_VERSION/zipkin-autoconfigure-collector-kafka08-$ZIPKIN_VERSION-module.jar > kafka08.jar && \
    unzip kafka08.jar -d kafka08 && \
    rm kafka08.jar && \
    apk del unzip

EXPOSE 9411 9410

CMD test -n "$STORAGE_TYPE" && source .${STORAGE_TYPE}_profile; \
    test -n "$SCRIBE_ENABLED" && JAVA_OPTS="${JAVA_OPTS} -Dloader.path=scribe -Dspring.profiles.active=scribe"; \
    test -n "$KAFKA_ZOOKEEPER" && JAVA_OPTS="${JAVA_OPTS} -Dloader.path=kafka08 -Dspring.profiles.active=kafka08"; \
    exec java ${JAVA_OPTS} -cp . org.springframework.boot.loader.PropertiesLauncher
