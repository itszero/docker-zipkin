# docker-zipkin

Dockerfiles for starting a Zipkin instance backed by Cassandra

## Build Images

Please run `cd deploy; ./build.sh` to build the images on your own computer.

## Deploy Zipkin

Use [docker-compose](https://docs.docker.com/compose/) by doing `cd
deploy; docker-compose up`.

There are also a set of Kubernetes controller and service definitions in `deploy/k8s` that use a ["cloud-native" build of Cassandra](https://github.com/kubernetes/kubernetes/blob/release-1.0/examples/cassandra/README.md).

## Notes

Docker-Zipkin starts the services in their own container: zipkin-cassandra,
zipkin-collector, zipkin-query, zipkin-web and only link required dependencies
together.

The started Zipkin instance would be backed by a single node Cassandra.

All images with the exception of zipkin-cassandra are sharing a base image:
zipkin-base. zipkin-base and zipkin-cassandra is built on `debian:sid`.

`build.sh` performs some fairly intensive tasks, the heaviest of which is running
gradle. Long story short, make sure your Docker machine has 4GB memory.

Ex. If you are literally running build.sh locally..
```bash
$ docker-machine create --driver virtualbox --virtualbox-memory "4096" dev
```

## Connecting to Span Storage

`zipkin-collector` and `zipkin-query` store and retrieve spans from Cassandra, using its native protocol. Specify a list of one or more Cassandra nodes listening on port 9042, via the comma-separated environment variable `CASSANDRA_CONTACT_POINTS`.

ex.
```bash
docker run -d -p 9410:9410 -p 9900:9900 --name="zipkin-collector" -e "CASSANDRA_CONTACT_POINTS=node1,node2,node3" "itszero/zipkin-collector:latest"
```

## Author

Zero Cho <itszero@gmail.com>
