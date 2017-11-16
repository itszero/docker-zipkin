#!/bin/sh
envsubst '\$ZIPKIN_BASE_URL' < /etc/nginx/conf.d/zipkin.conf.template > /etc/nginx/nginx.conf
exec nginx
