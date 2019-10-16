#!/bin/sh

if [ -f ".${STORAGE_TYPE}_profile" ]; then
  source ${PWD}/.${STORAGE_TYPE}_profile
fi

exec java ${JAVA_OPTS} -cp .:$(ls ${PWD}/BOOT-INF/lib/*.jar|tr '\n' ':')${PWD}/BOOT-INF/classes zipkin.server.ZipkinServer
