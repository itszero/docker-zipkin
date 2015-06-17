#!/bin/bash

# add for remote debugging, don't forget to expose 5005 in the Dockerfile
# -J-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005\

scala \
    -classpath "/tdist-zipkin-collector.jar" com.knewton.tdist.zipkin.receiver.kafka.KafkaReceiverApp\
    -zipkin.itemQueue.maxSize=10\
    -com.twitter.finagle.tracing.debugTrace=false\
    -zipkin.kafka.groupid=collector\
    -zipkin.kafka.server=ec2-174-129-254-64.compute-1.amazonaws.com:2181,ec2-23-21-69-105.compute-1.amazonaws.com:2181,ec2-75-101-130-163.compute-1.amazonaws.com:2181/Kafka08\
    -zipkin.kafka.topics=zipkin=1\
    -zipkin.store.cassie.dest=$DB_PORT_9160_TCP_ADDR:9160\
    -com.twitter.finagle.zipkin.initialSampleRate=1.0\
    -log.level=INFO\
    -admin.port=":9903"
