#!/bin/sh
set -eux

echo "*** Installing Kafka and dependencies"
apk add --update --no-cache runit jq

# download and cherry-pick zookeeper binaries
APACHE_MIRROR=$(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | jq -r '.preferred')
curl -sSL $APACHE_MIRROR/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz | tar xz
mkdir zookeeper
mv zookeeper-$ZOOKEEPER_VERSION/lib zookeeper/
mv zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.jar zookeeper/lib
mv zookeeper-$ZOOKEEPER_VERSION/conf zookeeper/

# create runit config
mkdir -p /etc/service/zookeeper
cat > /etc/service/zookeeper/run <<-EOF
#!/bin/sh
exec java -Dzookeeper.log.dir=/kafka/zookeeper -Dzookeeper.root.logger=INFO,CONSOLE -cp /kafka/zookeeper/lib/*:/kafka/zookeeper/conf org.apache.zookeeper.server.quorum.QuorumPeerMain /kafka/zookeeper/conf/zoo_sample.cfg
EOF
chmod +x /etc/service/zookeeper/run

# download kafka binaries
curl -sSL $APACHE_MIRROR/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | tar xz
mv kafka_$SCALA_VERSION-$KAFKA_VERSION/* .

# Set explicit, basic configuration
cat > config/server.properties <<-EOF
broker.id=0
zookeeper.connect=127.0.0.1:2181
replica.socket.timeout.ms=1500
log.dirs=/kafka/logs
auto.create.topics.enable=true
offsets.topic.replication.factor=1
listeners=PLAINTEXT://0.0.0.0:9092,PLAINTEXT_HOST://0.0.0.0:19092
listener.security.protocol.map=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
EOF

# create runit config, dependent on zookeeper, that advertises the container ip
mkdir -p /etc/service/kafka
cat > /etc/service/kafka/run <<-"EOF"
#!/bin/sh
sv start zookeeper || exit 1
if [[ -z "$KAFKA_ADVERTISED_HOST_NAME" ]]; then
listeners=PLAINTEXT://:9092
  # Have internal docker producers and consumers use the normal hostname:9092, and outside docker localhost:19092
  echo advertised.listeners=PLAINTEXT://${HOSTNAME}:9092,PLAINTEXT_HOST://localhost:19092 >> /kafka/config/server.properties
else
  # Have internal docker producers and consumers use the normal hostname:9092, and outside docker the advertised host on port 19092
  echo "advertised.listeners=PLAINTEXT://${HOSTNAME}:9092,PLAINTEXT_HOST://${KAFKA_ADVERTISED_HOST_NAME}:19092" >> /kafka/config/server.properties
fi
exec sh /kafka/bin/kafka-run-class.sh -name kafkaServer -loggc kafka.Kafka /kafka/config/server.properties
EOF
chmod +x /etc/service/kafka/run

echo "*** Cleaning Up"
rm -rf zookeeper-$ZOOKEEPER_VERSION

echo "*** Image build complete"
