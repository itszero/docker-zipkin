#!/bin/bash
if [[ -z $DB_PORT_7000_TCP_ADDR ]]; then
  echo "** ERROR: You need to link the cassandra container as db."
  exit 1
fi

cd zipkin

SERVICE_NAME="zipkin-query-service"
CONFIG="${SERVICE_NAME}/config/query-cassandra.scala"

cat << EOF > $CONFIG
import com.datastax.driver.core.Cluster
import com.datastax.driver.core.SocketOptions
import com.twitter.zipkin.builder.QueryServiceBuilder
import com.twitter.zipkin.cassandra
import com.twitter.zipkin.storage.Store
import org.twitter.zipkin.storage.cassandra.ZipkinRetryPolicy

val cluster = Cluster.builder()
  .addContactPoints("${DB_PORT_9042_TCP_ADDR}")
  .withSocketOptions(new SocketOptions().setConnectTimeoutMillis(10000).setReadTimeoutMillis(20000))
  .withRetryPolicy(ZipkinRetryPolicy.INSTANCE)
  .build()

val storeBuilder = Store.Builder(new cassandra.SpanStoreBuilder(cluster))
EOF

echo "** Starting ${SERVICE_NAME}..."
./$SERVICE_NAME/build/install/$SERVICE_NAME/bin/$SERVICE_NAME -f $CONFIG
