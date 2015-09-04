#!/bin/sh

set -eu

echo "*** Installing Python"
apk add python

echo "*** Installing Cassandra"
curl -L http://downloads.datastax.com/community/dsc-cassandra-$CASSANDRA_VERSION-bin.tar.gz | tar xz
mv dsc-cassandra-$CASSANDRA_VERSION /cassandra

echo "*** Starting Cassandra"
sed -i s/Xss180k/Xss256k/ /cassandra/conf/cassandra-env.sh
/usr/sbin/cassandra

timeout=300
while [[ "$timeout" -gt 0 ]] && ! cqlsh -e 'SHOW VERSION' localhost >/dev/null 2>/dev/null; do
    echo "Waiting ${timeout} seconds for cassandra to come up"
    sleep 10
    timeout=$(($timeout - 10))
done

echo "*** Importing Scheme"
curl https://raw.githubusercontent.com/openzipkin/zipkin/$ZIPKIN_VERSION/zipkin-cassandra-core/src/main/resources/cassandra-schema-cql3.txt \
     | /cassandra/bin/cqlsh --debug localhost

echo "*** Stopping Cassandra"
pkill -f java

mv /cassandra/conf/cassandra.yaml /cassandra/conf/cassandra.default.yaml

echo "*** Image build complete"
