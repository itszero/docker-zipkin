#!/bin/sh

# If the schema has been removed due to mounting, restore from our backup. see: install.sh
if [ ! -d "/cassandra/data/data/zipkin2" ]; then
    cp -rf /cassandra/data-backup/* /cassandra/data/
fi

exec /cassandra/bin/cassandra -f
