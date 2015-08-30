#!/bin/sh

set -eu

IP=`hostname -i`
CONFIG_TMPL="/cassandra/conf/cassandra.default.yaml"
CONFIG="/cassandra/conf/cassandra.yaml"
rm -f $CONFIG; cp $CONFIG_TMPL $CONFIG
sed -i -e "s/^listen_address.*/listen_address: $IP/" $CONFIG
sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/" $CONFIG
sed -i -e "s/^\# broadcast_rpc_address.*/broadcast_rpc_address: $IP/" $CONFIG
/cassandra/bin/cassandra -f
