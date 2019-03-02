#!/busybox/sh

echo Starting Zookeeper
/busybox/sh /kafka/bin/kafka-run-class.sh -Dlog4j.configuration=file:/kafka/config/log4j.properties org.apache.zookeeper.server.quorum.QuorumPeerMain /kafka/zookeeper/conf/zoo_sample.cfg &
/busybox/sh /kafka/bin/wait-for-zookeeper.sh

if [[ -z "$KAFKA_ADVERTISED_HOST_NAME" ]]; then
listeners=PLAINTEXT://:9092
  # Have internal docker producers and consumers use the normal hostname:9092, and outside docker localhost:19092
  echo advertised.listeners=PLAINTEXT://${HOSTNAME}:9092,PLAINTEXT_HOST://localhost:19092 >> /kafka/config/server.properties
else
  # Have internal docker producers and consumers use the normal hostname:9092, and outside docker the advertised host on port 19092
  echo "advertised.listeners=PLAINTEXT://${HOSTNAME}:9092,PLAINTEXT_HOST://${KAFKA_ADVERTISED_HOST_NAME}:19092" >> /kafka/config/server.properties
fi

echo Starting Kafka
/busybox/sh /kafka/bin/kafka-run-class.sh -name kafkaServer -Dlog4j.configuration=file:/kafka/config/log4j.properties kafka.Kafka /kafka/config/server.properties
