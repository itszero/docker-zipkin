FROM alpine
MAINTAINER OpenZipkin "http://zipkin.io/"

WORKDIR /mysql
ADD install.sh /mysql/install
RUN /mysql/install

ENV ZIPKIN_VERSION 2.12.3

ADD configure.sh /mysql/configure
RUN /mysql/configure

ADD run.sh /mysql/run.sh
CMD /mysql/run.sh

EXPOSE 3306
