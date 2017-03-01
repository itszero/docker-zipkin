#!/bin/sh

set -xeuo pipefail

if ! curl --retry 5 --retry-connrefused --retry-delay 0 -sf http://grafana:3000/api/dashboards/name/prom; then
    curl -sf -X POST -H "Content-Type: application/json" \
         --data-binary '{"name":"prom","type":"prometheus","url":"http://prometheus:9090","access":"proxy","isDefault":true}' \
         http://grafana:3000/api/datasources
fi

dashboard_id=1598
last_revision=$(curl -sf https://grafana.net/api/dashboards/${dashboard_id}/revisions | grep '"revision":' | sed 's/ *"revision": \([0-9]*\),/\1/' | sort -n | tail -1)

curl -s https://grafana.net/api/dashboards/${dashboard_id}/revisions/${last_revision}/download | \
    xargs -0 -I "{}" curl --retry-connrefused --retry 5 --retry-delay 0 -sf \
          -X POST -H "Content-Type: application/json" \
          --data-binary '{"dashboard": {}, "inputs": [{"name": "DS_PROM", "pluginId": "prometheus", "type": "datasource", "value": "prom"}], "overwrite": false}' \
          http://grafana:3000/api/dashboards/import
