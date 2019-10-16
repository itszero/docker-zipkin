#!/bin/sh

if [ -f ".${STORAGE_TYPE}_profile" ]; then
  source ${PWD}/.${STORAGE_TYPE}_profile
fi

# Use main class directly if there are no modules, as it measured 14% faster from JVM running to available
# verses PropertiesLauncher when using Zipkin was based on Spring Boot 2.1
if [[ -z "$MODULE_OPTS" ]]; then
  exec java ${JAVA_OPTS} -cp .:$(ls ${PWD}/BOOT-INF/lib/*.jar|tr '\n' ':')${PWD}/BOOT-INF/classes zipkin.server.ZipkinServer
else
  exec java ${MODULE_OPTS} ${JAVA_OPTS} -cp . org.springframework.boot.loader.PropertiesLauncher
fi
