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

ENV ELASTICSEARCH_VERSION 7.0.0-beta1
# https://github.com/elastic/elasticsearch/pull/31003 was closed won't fix
ENV ES_TMPDIR /tmp

WORKDIR /elasticsearch

# single layer to install elasticsearch and the user
RUN curl -SL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION-linux-x86_64.tar.gz| tar xz && \
    mv elasticsearch-$ELASTICSEARCH_VERSION/* /elasticsearch/ && \
    # disable ML as not supported on alpine per https://discuss.elastic.co/t/elasticsearch-failing-to-start-due-to-x-pack/85125/6
    rm -rf /elasticsearch/modules/x-pack-ml/platform/linux-x86_64 && \
    adduser -S elasticsearch && \
    chown -R elasticsearch /elasticsearch

# elasticsearch complains if run as root
USER elasticsearch

COPY config ./config

EXPOSE 9200 9300

# our image doesn't have bash, so use sh instead, also remove JAVA_OPTS in favor of ES_JAVA_OPTS
CMD JAVA_OPTS= exec sh /elasticsearch/bin/elasticsearch
