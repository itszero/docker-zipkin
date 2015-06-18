#!/bin/bash
PREFIX="itszero/zipkin-"
#IMAGES=("base" "cassandra" "collector" "kinesis-collector" "query" "web")

name=$1

pushd "../$name"
docker build -t "$PREFIX$name" .
popd