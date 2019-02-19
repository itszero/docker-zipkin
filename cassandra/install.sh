#!/bin/sh
set -eu

apk add --update --no-cache curl


echo "*** Installing Cassandra"
# DataStax only hosts 3.0 series at the moment
curl -SL http://archive.apache.org/dist/cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz | tar xz
mv apache-cassandra-$CASSANDRA_VERSION/* /cassandra/

echo "*** Installing Python"
apk add --update --no-cache python

# Default conf for Cassandra 3.x does not work on modern JVMs due to many deprecated flags
sed -i '/-XX:ThreadPriorityPolicy=42/c\#-XX:ThreadPriorityPolicy=42' /cassandra/conf/jvm.options
sed -i '/-XX:+UseParNewGC/c\#-XX:+UseParNewGC' /cassandra/conf/jvm.options
sed -i '/-XX:+UseConcMarkSweepGC/c\#-XX:+UseConcMarkSweepGC' /cassandra/conf/jvm.options
sed -i '/-XX:+PrintGCDateStamps/c\#-XX:+PrintGCDateStamps' /cassandra/conf/jvm.options
sed -i '/-XX:+PrintHeapAtGC/c\#-XX:+PrintHeapAtGC' /cassandra/conf/jvm.options
sed -i '/-XX:+PrintTenuringDistribution/c\#-XX:+PrintTenuringDistribution' /cassandra/conf/jvm.options
sed -i '/-XX:+PrintGCApplicationStoppedTime/c\#-XX:+PrintGCApplicationStoppedTime' /cassandra/conf/jvm.options
sed -i '/-XX:+PrintPromotionFailure/c\#-XX:+PrintPromotionFailure' /cassandra/conf/jvm.options
sed -i '/-XX:+UseGCLogFileRotation/c\#-XX:+UseGCLogFileRotation' /cassandra/conf/jvm.options
sed -i '/-XX:NumberOfGCLogFiles=10/c\#-XX:NumberOfGCLogFiles=10' /cassandra/conf/jvm.options
sed -i '/-XX:GCLogFileSize=10M/c\#-XX:GCLogFileSize=10M' /cassandra/conf/jvm.options

# TODO: Add native snappy lib. Native loader stacktraces in the cassandra log as a results, which is distracting.

echo "*** Starting Cassandra"
/cassandra/bin/cassandra -R

timeout=300
while [[ "$timeout" -gt 0 ]] && ! /cassandra/bin/cqlsh -e 'SHOW VERSION' localhost >/dev/null 2>/dev/null; do
    echo "Waiting ${timeout} seconds for cassandra to come up"
    sleep 10
    timeout=$(($timeout - 10))
done

echo "*** Importing Scheme"
curl https://raw.githubusercontent.com/openzipkin/zipkin/$ZIPKIN_VERSION/zipkin-storage/cassandra-v1/src/main/resources/cassandra-schema-cql3.txt \
     | /cassandra/bin/cqlsh --debug localhost

curl https://raw.githubusercontent.com/openzipkin/zipkin/$ZIPKIN_VERSION/zipkin-storage/cassandra/src/main/resources/zipkin2-schema.cql \
     | /cassandra/bin/cqlsh --debug localhost

curl https://raw.githubusercontent.com/openzipkin/zipkin/$ZIPKIN_VERSION/zipkin-storage/cassandra/src/main/resources/zipkin2-schema.cql \
     | sed 's/ zipkin2/ zipkin2_udts/g' | /cassandra/bin/cqlsh --debug localhost

curl https://raw.githubusercontent.com/openzipkin/zipkin/$ZIPKIN_VERSION/zipkin-storage/cassandra/src/main/resources/zipkin2-schema-indexes.cql \
     | /cassandra/bin/cqlsh --debug localhost

echo "*** Adding custom UDFs to zipkin2 keyspace"
/cassandra/bin/cqlsh -e "CREATE FUNCTION zipkin2.plus (x bigint, y bigint) RETURNS NULL ON NULL INPUT RETURNS bigint LANGUAGE java AS 'return x+y;';"
/cassandra/bin/cqlsh -e "CREATE FUNCTION zipkin2.minus (x bigint, y bigint) RETURNS NULL ON NULL INPUT RETURNS bigint LANGUAGE java AS 'return x-y;';"
/cassandra/bin/cqlsh -e "CREATE FUNCTION zipkin2.toTimestamp (x bigint) RETURNS NULL ON NULL INPUT RETURNS timestamp LANGUAGE java AS 'return new java.util.Date(x/1000);';"
/cassandra/bin/cqlsh -e "CREATE FUNCTION zipkin2.value (x map<text,text>, y text) RETURNS NULL ON NULL INPUT RETURNS text LANGUAGE java AS 'return x.get(y);';"

echo "*** Stopping Cassandra"
pkill -f java

echo "*** Cleaning Up"
apk del python --purge
rm -rf /cassandra/javadoc/ /cassandra/pylib/ /cassandra/tools/ /cassandra/lib/*.zip

echo "*** Changing to cassandra user"
adduser -S cassandra

# Take a backup so that we can safely mount an empty volume over the data directory and maintain the schema
cp -R /cassandra/data/ /cassandra/data-backup/

chown -R cassandra /cassandra

echo "*** Image build complete"
