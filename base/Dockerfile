FROM debian:sid
MAINTAINER Zero Cho "http://itsze.ro"

RUN apt-get update
RUN apt-get install -y git
RUN git clone https://github.com/twitter/zipkin.git
RUN apt-get update
RUN apt-get install -y default-jdk
RUN apt-get install -y curl
RUN (cd zipkin; bin/sbt compile)
