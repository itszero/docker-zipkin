FROM dockerfile/java:oracle-java8
MAINTAINER Zero Cho "http://itsze.ro"

RUN apt-get update
RUN apt-get install -y git
RUN git clone https://github.com/twitter/zipkin.git
RUN apt-get install -y curl

# Setup aws cli and the config
RUN apt-get -y install awscli
RUN mkdir /.aws

# Install Scala 2.10.4
ENV SCALA_VERSION 2.10.4

RUN \
  DEBIAN_FRONTEND=noninteractive apt-get install -y wget libjansi-java && \
  wget http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb && \
  DEBIAN_FRONTEND=noninteractive dpkg -i scala-$SCALA_VERSION.deb && \
  rm -f scala-$SCALA_VERSION.deb

# Install sbt 0.13.6
ENV SBT_VERSION 0.13.6

RUN \
  wget http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  DEBIAN_FRONTEND=noninteractive dpkg -i sbt-$SBT_VERSION.deb && \
  rm -f sbt-$SBT_VERSION.deb

# Define default command
CMD \
  ["/bin/bash"]

RUN (cd zipkin; bin/sbt compile)
