#!/bin/bash -x
IMG_PREFIX="itszero/zipkin-"
NAME_PREFIX="zipkin-"
PUBLIC_PORT="8080"
ROOT_URL="http://deb.local:$PUBLIC_PORT"

name=$1
cleanup=$2
if [[ $cleanup == "y" ]]; then
  # SERVICES=("cassandra" "collector" "kinesis-collector" "query" "web")
  SERVICES=("$name")
  for i in "${SERVICES[@]}"; do
    echo "** Stopping zipkin-$i"
    docker stop "${NAME_PREFIX}$i"
    docker rm "${NAME_PREFIX}$i"
  done
fi


if [ $name == "cassandra" ]; then
	echo "** Starting zipkin-cassandra"
	docker run -i --name="${NAME_PREFIX}cassandra" -p 9160:9160 -t "${IMG_PREFIX}cassandra"
elif [ $name == "collector" ]; then
	echo "** Starting zipkin-collector"
	docker run -i --link="${NAME_PREFIX}cassandra:db" -p 9410:9410 -p 9903:9903 --name="${NAME_PREFIX}collector" -t "${IMG_PREFIX}collector"
elif [ $name == "kinesis-collector" ]; then
	echo "** Starting zipkin-kinesis-collector"
	docker run -i --link="${NAME_PREFIX}cassandra:db" -p 9410:9410 -p 9903:9903 --name="${NAME_PREFIX}kinesis-collector" -t "${IMG_PREFIX}kinesis-collector"
elif [ $name == "query" ]; then
	echo "** Starting zipkin-query"
	docker run -i --link="${NAME_PREFIX}cassandra:db" -p 9411:9411 --name="${NAME_PREFIX}query" -t "${IMG_PREFIX}query"
elif [ $name == "web" ]; then
	echo "** Starting zipkin-web"
	docker run -i --link="${NAME_PREFIX}query:query" -p 8080:$PUBLIC_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}web" -t "${IMG_PREFIX}web"
fi