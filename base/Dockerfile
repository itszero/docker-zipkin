FROM debian:sid
MAINTAINER OpenZipkin "http://zipkin.io/"

RUN apt-get update && apt-get install -y \
  curl \
  openjdk-8-jre-headless \
  netcat

ENV ZIPKIN_REPO https://jcenter.bintray.com
ENV ZIPKIN_VERSION 0.0.2

RUN mkdir /zipkin
WORKDIR /zipkin
