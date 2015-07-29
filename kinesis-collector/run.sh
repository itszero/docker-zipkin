#!/bin/bash

#add for remote debugging, don't forget to expose 5005 in the Dockerfile
# -J-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005\

scala \
    -classpath "/tdist-zipkin-collector.jar" com.knewton.tdist.zipkin.receiver.kinesis.KinesisReceiverApp\
    -zipkin.store.cassie.dest=$DB_PORT_9160_TCP_ADDR:9160\
    -kinesis.application.name=ZipkinCollector1\
    -kinesis.stream.name=$ENVIRONMENT_NAME-zipkin\
    -aws.access.key=$ACCESS_KEY\
    -aws.secret.key=$SECRET_KEY\
    -com.twitter.finagle.zipkin.initialSampleRate=1.0\
    -log.level=INFO\
    -admin.port=":9903"