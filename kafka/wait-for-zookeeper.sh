#!/busybox/sh

until echo stat | nc 127.0.0.1 2181
do
  sleep 1
done
