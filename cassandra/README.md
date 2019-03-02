This is temporary until we have a means to change yaml at runtime, to set the container IP, etc.

```bash
CASSANDRA_VERSION=3.11.4
# DataStax only hosts 3.0 series at the moment
curl -SL http://archive.apache.org/dist/cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz | tar xz
javac -source 1.8 -target 1.8 -classpath apache-cassandra-$CASSANDRA_VERSION/lib/apache-cassandra-$CASSANDRA_VERSION.jar ZipkinConfigurationLoader.java
git add  ZipkinConfigurationLoader.class
rm -rf apache-cassandra-$CASSANDRA_VERSION
```
