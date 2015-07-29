#!/bin/bash
if [[ -z $DB_PORT_7000_TCP_ADDR ]]; then
  echo "** ERROR: You need to link the cassandra container as db."
  exit 1
fi

cd zipkin

SERVICE_NAME="zipkin-query-service"
CONFIG="${SERVICE_NAME}/config/query-cassandra.scala"

cat << EOF > $CONFIG
import com.twitter.zipkin.builder.QueryServiceBuilder
import com.twitter.zipkin.cassandra
import com.twitter.zipkin.storage.Store

// development mode.
val keyspaceBuilder = cassandra.Keyspace.static(nodes = Set("${DB_PORT_7000_TCP_ADDR}"))
val storeBuilder = Store.Builder(
  cassandra.StorageBuilder(keyspaceBuilder),
  cassandra.IndexBuilder(keyspaceBuilder),
  cassandra.AggregatesBuilder(keyspaceBuilder))

QueryServiceBuilder(storeBuilder)
EOF

echo "** Starting ${SERVICE_NAME}..."
./$SERVICE_NAME/build/install/$SERVICE_NAME/bin/$SERVICE_NAME -f $CONFIG
