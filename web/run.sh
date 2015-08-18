#!/bin/bash
if [[ -z $QUERY_PORT_9411_TCP_ADDR ]]; then
  if [[ -z $ZIPKIN_QUERY_PORT_9411_TCP_ADDR ]]; then
    echo "** ERROR: You need to link the query service as query or zipkin-query."
    exit 1
  fi
  QUERY_PORT_9411_TCP_ADDR=$ZIPKIN_QUERY_PORT_9411_TCP_ADDR
fi

QUERY_ADDR="${QUERY_PORT_9411_TCP_ADDR}:9411"
SERVICE_NAME="zipkin-web"

DEFAULT_ROOTURL=http://localhost:8080/
ROOTURL="-zipkin.web.rootUrl=${ROOTURL:-DEFAULT_ROOTURL}"

echo "** Starting ${SERVICE_NAME}..."
./$SERVICE_NAME/build/install/$SERVICE_NAME/bin/$SERVICE_NAME -zipkin.web.query.dest=${QUERY_ADDR} $ROOTURL
