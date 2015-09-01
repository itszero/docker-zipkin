# docker-zipkin

Dockerfiles for starting a Zipkin instance backed by Cassandra. Automatically built images are available on Quay.io
under the [OpenZipkin](https://quay.io/organization/openzipkin) organization.

## Running

Use [docker-compose](https://docs.docker.com/compose/) by doing
`docker-compose up`.

## Notes

Docker-Zipkin starts the services in their own container: zipkin-cassandra,
zipkin-collector, zipkin-query, zipkin-web and only link required dependencies
together.

The started Zipkin instance would be backed by a single node Cassandra.

All images with the exception of zipkin-cassandra are sharing a base image:
zipkin-base. zipkin-base and zipkin-cassandra is built on `debian:sid`.

## Connecting to Span Storage

`zipkin-collector` and `zipkin-query` store and retrieve spans from Cassandra, using its native protocol. Specify a list of one or more Cassandra nodes listening on port 9042, via the comma-separated environment variable `CASSANDRA_CONTACT_POINTS`.

ex. 
```bash
docker run -d -p 9410:9410 -p 9900:9900 --name="zipkin-collector" -e "CASSANDRA_CONTACT_POINTS=node1,node2,node3" "openzipkin/zipkin-collector:latest"
```
