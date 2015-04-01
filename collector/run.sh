#!/bin/bash
scala \
    -classpath ./tdist-zipkin/target/tdist-zipkin.jar com.knewton.tdist.zipkin.receiver.kafka.KafkaReceiverApp\
    -zipkin.itemQueue.maxSize=10\
    -com.twitter.finagle.tracing.debugTrace=true\
    -zipkin.kafka.groupid=0
