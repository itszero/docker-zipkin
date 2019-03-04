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

FROM alpine

ENV ZIPKIN_REPO https://jcenter.bintray.com
ENV ZIPKIN_VERSION 2.12.3

# Add environment settings for supported storage types
COPY zipkin/ /zipkin/
WORKDIR /zipkin

RUN apk add unzip curl --no-cache && \
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

FROM gcr.io/distroless/java:11-debug
MAINTAINER OpenZipkin "http://zipkin.io/"

ENV ZIPKIN_VERSION 2.12.1

# Use to set heap, trust store or other system properties.
ENV JAVA_OPTS -Djava.security.egd=file:/dev/./urandom

# Add environment settings for supported storage types
COPY --from=0 /zipkin/ /zipkin/
WORKDIR /zipkin

EXPOSE 9410 9411

ENTRYPOINT ["/busybox/sh", "run.sh"]
