#!/bin/sh

cp -rf /cassandra/data-tmp/* /cassandra/data/

exec /cassandra/bin/cassandra -f
