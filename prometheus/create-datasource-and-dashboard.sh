#!/bin/sh

set -xeuo pipefail

if ! curl --retry 5 --retry-connrefused --retry-delay 0 -sf http://grafana:3000/api/dashboards/name/prom; then
    curl -sf -X POST -H "Content-Type: application/json" \
         --data-binary '{"name":"prom","type":"prometheus","url":"http://prometheus:9090","access":"proxy","isDefault":true}' \
         http://grafana:3000/api/datasources
fi

curl -s https://grafana.net/api/dashboards/1598/revisions/1/download | \
    xargs -0 -I "{}" curl --retry-connrefused --retry 5 --retry-delay 0 -sf \
          -X POST -H "Content-Type: application/json" \
          --data-binary '{"dashboard": {}, "inputs": [{"name": "DS_PROM", "pluginId": "prometheus", "type": "datasource", "value": "prom"}], "overwrite": false}' \
          http://grafana:3000/api/dashboards/import
