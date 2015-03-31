apt-get update
apt-get install -y curl procps wget

echo "*** Adding Cassandra deb source"
cat << EOF >> /etc/apt/sources.list.d/cassandra.sources.list
deb http://debian.datastax.com/community stable main
EOF

echo "*** Importing Cassandra deb keys"
curl -L http://debian.datastax.com/debian/repo_key | apt-key add -

echo "*** Installing Cassandra"
apt-get update
apt-get install -y dsc12=1.2.10-1 cassandra=1.2.10

echo "*** Starting Cassandra"
sed -i s/Xss180k/Xss256k/ /etc/cassandra/cassandra-env.sh
/usr/sbin/cassandra
sleep 5

echo "*** Getting Schema"
wget https://github.com/twitter/zipkin/blob/master/zipkin-cassandra/src/schema/cassandra-schema.txt
echo "*** Importing Scheme"
cassandra-cli -host localhost -port 9160 -f cassandra-schema.txt

echo "*** Stopping Cassandra"
killall java

mv /etc/cassandra/cassandra.yaml /etc/cassandra/cassandra.default.yaml

echo "*** Image build complete"
