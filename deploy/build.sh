#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

PREFIX="itszero/zipkin-"
IMAGES=("base" "cassandra" "cassandra-k8s" "collector" "query" "web")

for image in ${IMAGES[@]}; do
  pushd "../$image"
  [[ -x ./prepare.sh ]] && ./prepare.sh
  docker build -t "$PREFIX$image" .
  [[ -x ./cleanup.sh ]] && ./cleanup.sh
  popd
done
