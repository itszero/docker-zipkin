FROM debian:sid
MAINTAINER Zero Cho "http://itsze.ro"

RUN apt-get update
RUN apt-get install -y scala git curl openjdk-7-jdk
RUN git clone https://github.com/openzipkin/zipkin.git
RUN (cd zipkin; bin/sbt compile)
