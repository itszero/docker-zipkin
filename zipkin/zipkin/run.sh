#!/bin/sh

if [ -f ".${STORAGE_TYPE}_profile" ]; then
  source ${PWD}/.${STORAGE_TYPE}_profile
fi

if [ -n "$SCRIBE_ENABLED" ]; then
  export JAVA_OPTS="${JAVA_OPTS} -Dloader.path=scribe -Dspring.profiles.active=scribe"
fi

if [ -n "$KAFKA_ZOOKEEPER" ]; then
  export JAVA_OPTS="${JAVA_OPTS} -Dloader.path=kafka08 -Dspring.profiles.active=kafka08"
fi

exec java ${JAVA_OPTS} -cp . org.springframework.boot.loader.PropertiesLauncher
