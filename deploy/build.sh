#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

PREFIX="itszero/zipkin-"
#IMAGES=("base" "cassandra" "collector" "kinesis-collector" "query" "web")

name=$1

pushd "../$name"
docker build -t "$PREFIX$name" .
popd