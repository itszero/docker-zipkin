apt-get update
apt-get install -y procps psmisc

echo "*** Starting Cassandra"
cp /etc/cassandra/cassandra.yaml /etc/cassandra/cassandra.yaml.orig
perl -pi -e "s/%%ip%%/127.0.0.1/g" /etc/cassandra/cassandra.yaml
/run.sh &
sleep 10

echo "*** Importing Schema"
cqlsh -f /cassandra-schema-cql3.txt

echo "*** Stopping Cassandra"
killall java
mv /etc/cassandra/cassandra.yaml.orig /etc/cassandra/cassandra.yaml

echo "*** Image build complete"
