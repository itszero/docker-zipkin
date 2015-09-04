#!/bin/sh
if [[ -z $QUERY_PORT_9411_TCP_ADDR ]]; then
  echo "** ERROR: You need to link the query service as query."
  exit 1
fi

QUERY_ADDR="${QUERY_PORT_9411_TCP_ADDR}:9411"
SERVICE_NAME="zipkin-web"

DEFAULT_ROOTURL=http://localhost:8080/
ROOTURL="-zipkin.web.rootUrl=${ROOTURL:-DEFAULT_ROOTURL}"

echo "** Starting zipkin web..."
# cacheResources implies serving web assets from the jar, as opposed to a local filesystem path
java -jar zipkin-web.jar -zipkin.web.cacheResources=true -zipkin.web.query.dest=${QUERY_ADDR} ${ROOTURL}
