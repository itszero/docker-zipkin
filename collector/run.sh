#!/bin/bash
scala \
    -classpath /tdist-zipkin.jar com.knewton.tdist.zipkin.receiver.kafka.KafkaReceiverApp\
    -zipkin.itemQueue.maxSize=10\
    -com.twitter.finagle.tracing.debugTrace=true\
    -zipkin.kafka.groupid=0\
    -zipkin.zookeeper.location=host1:2181,host2:2181,host3:2181/Kafka08\
    -zipkin.kafka.server=host1:9160,host2:9160,host3:9160\
    -zipkin.kafka.topics=zipkin-tdist=1
