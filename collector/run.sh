#!/bin/bash
if [[ -z $DB_PORT_9042_TCP_ADDR ]]; then
  echo "** ERROR: You need to link the cassandra container as db."
  exit 1
fi

SERVICE_NAME="zipkin-collector-service"
CONFIG="${SERVICE_NAME}/config/collector-cassandra.scala"

echo "** Starting ${SERVICE_NAME}..."
cd zipkin
sed -i "s/localhost/${DB_PORT_9042_TCP_ADDR}/" $CONFIG
./$SERVICE_NAME/build/install/$SERVICE_NAME/bin/$SERVICE_NAME -f $CONFIG
