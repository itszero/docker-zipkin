#!/bin/bash
scala \
    -classpath /tdist-zipkin.jar com.knewton.tdist.zipkin.receiver.kafka.KafkaReceiverApp\
    -zipkin.itemQueue.maxSize=10\
    -com.twitter.finagle.tracing.debugTrace=true\
    -zipkin.kafka.groupid=collector\
    -zipkin.kafka.server=host1:2181,host2:2181,host3:2181/Kafka08\
    -zipkin.kafka.topics=zipkin=1\
    -admin.port=":9903"
