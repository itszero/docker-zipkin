# docker-zipkin

[![Build Status](https://travis-ci.org/openzipkin/docker-zipkin.svg)](https://travis-ci.org/openzipkin/docker-zipkin)
[![zipkin](https://quay.io/repository/openzipkin/zipkin/status "zipkin")](https://quay.io/repository/openzipkin/zipkin)
[![zipkin-cassandra](https://quay.io/repository/openzipkin/zipkin-cassandra/status "zipkin-cassandra")](https://quay.io/repository/openzipkin/zipkin-cassandra)
[![zipkin-mysql](https://quay.io/repository/openzipkin/zipkin-mysql/status "zipkin-mysql")](https://quay.io/repository/openzipkin/zipkin-mysql)
[![zipkin-elasticsearch](https://quay.io/repository/openzipkin/zipkin-elasticsearch/status "zipkin-elasticsearch")](https://quay.io/repository/openzipkin/zipkin-elasticsearch)
[![zipkin-kafka](https://quay.io/repository/openzipkin/zipkin-kafka/status "zipkin-kafka")](https://quay.io/repository/openzipkin/zipkin-kafka)
[![zipkin-ui](https://quay.io/repository/openzipkin/zipkin-ui/status "zipkin-ui")](https://quay.io/repository/openzipkin/zipkin-ui)


This repository contains the Docker build definition and release process for
[openzipkin/zipkin](https://github.com/openzipkin/zipkin). It also contains
test images for transport and storage backends such as Kafka or Cassandra.

Automatically built images are available on Quay.io under the [OpenZipkin](https://quay.io/organization/openzipkin) organization,
and are mirrored to [Docker Hub](https://hub.docker.com/u/openzipkin/).

## Regarding production usage

The only images OpenZipkin provides for production use are:
* [openzipkin/zipkin](./zipkin): The core server image that hosts the Zipkin UI, Api and Collector features.
* [openzipkin/zipkin-dependencies](https://github.com/openzipkin/docker-zipkin-dependencies): pre-aggregates data such that http://your_host:9411/dependency shows links between services.

If you are using these images and run into problems, please raise an issue or
join [gitter](https://gitter.im/openzipkin/zipkin).

The other images here, and docker-compose, are for development and exploration
purposes. For example, they aim to help you integrate an entire zipkin system
for testing purposes, without having to understand how everything works, and
without having to download gigabytes of files.

For example, `openzipkin/zipkin-cassandra` was not designed for real usage.
You'll notice it has no configuration available to run more than one node
sensibly, neither does it handle file systems as one would "in real life". We
expect production users to use canonical images for storage or transports like
Kafka, and only those testing or learning zipkin to use the ones we have here.

## Running

Zipkin has no dependencies, for example you can run an in-memory zipkin server like so:
`docker run -d -p 9411:9411 openzipkin/zipkin`

See the ui at (docker ip):9411

In the ui - click zipkin-server, then click "Find Traces".

## Configuration
Configuration is via environment variables, defined by [zipkin-server](https://github.com/openzipkin/zipkin/blob/master/zipkin-server/README.md). Notably, you'll want to look at the `STORAGE_TYPE` environment variables, which
include "cassandra", "mysql" and "elasticsearch".

When in docker, the following environment variables also apply

* `JAVA_OPTS`: Use to set java arguments, such as heap size or trust store location.
* `STORAGE_PORT_9042_TCP_ADDR` -- A Cassandra node listening on port 9042. This
  environment variable is typically set by linking a container running
  `zipkin-cassandra` as "storage" when you start the container.
* `STORAGE_PORT_3306_TCP_ADDR` -- A MySQL node listening on port 3306. This
  environment variable is typically set by linking a container running
  `zipkin-mysql` as "storage" when you start the container.
* `STORAGE_PORT_9200_TCP_ADDR` -- An Elasticsearch node listening on port 9200. This
  environment variable is typically set by linking a container running
  `zipkin-elasticsearch` as "storage" when you start the container. This is ignored
  when `ES_HOSTS` or `ES_AWS_DOMAIN` are set.
* `KAFKA_PORT_2181_TCP_ADDR` -- A zookeeper node listening on port 2181. This
  environment variable is typically set by linking a container running
  `zipkin-kafka` as "kafka" when you start the container.

## docker-compose

This project is configured to run docker containers using
[docker-compose](https://docs.docker.com/compose/). Note that the default
configuration requires docker-compose 1.6.0+ and docker-engine 1.10.0+. If you
are running older versions, see the [Legacy](#legacy) section below.

To start the default docker-compose configuration, run:

    $ docker-compose up

View the web UI at $(docker ip):9411.

To see specific traces in the UI, select "zipkin-server" in the dropdown and
then click the "Find Traces" button.

### MySQL

The default docker-compose configuration defined in `docker-compose.yml` is
backed by MySQL. This configuration starts `zipkin`, `zipkin-mysql` and
`zipkin-dependencies` (cron job) in their own containers.

### Cassandra

The docker-compose configuration can be extended to use Cassandra instead of
MySQL, using the `docker-compose-cassandra.yml` file. That file employs
[docker-compose overrides](https://docs.docker.com/compose/extends/#multiple-compose-files)
to swap out one storage container for another.

To start the Cassandra-backed configuration, run:

    $ docker-compose -f docker-compose.yml -f docker-compose-cassandra.yml up

### Elasticsearch

The docker-compose configuration can be extended to use Elasticsearch instead of
MySQL, using the `docker-compose-elasticsearch.yml` file. That file employs
[docker-compose overrides](https://docs.docker.com/compose/extends/#multiple-compose-files)
to swap out one storage container for another.

To start the Elasticsearch-backed configuration, run:

    $ docker-compose -f docker-compose.yml -f docker-compose-elasticsearch.yml up

#### Elasticsearch 5 and Host setup

The `docker-elasticsearch5` image is [more strict](https://github.com/docker-library/docs/tree/master/elasticsearch#host-setup) about virtual memory. You will need to adjust accordingly (especially if you notice elasticsearch crash!)

```bash
# If docker is running on your host machine, adjust the kernel setting directly
$ sudo sysctl -w vm.max_map_count=262144

# If using docker-machine/Docker Toolbox/Boot2Docker, remotely adjust the same
$ docker-machine ssh default "sudo sysctl -w vm.max_map_count=262144"
```

#### Elasticsearch Service on Amazon

If you are using Elasticsearch against Amazon, it will search for credentials including those
in the `~/.aws` directory. If you want to try Zipkin against Amazon Elasticsearch Service, the
easiest start is to share your credentials with Zipkin's docker image.

For example, if you are able to run `aws es list-domain-names`, then you
should be able to start Zipkin as simply as this:

```bash
$ docker run -d -p 9411:9411 \
  -e STORAGE_TYPE=elasticsearch -e ES_AWS_DOMAIN=your_domain \
  -v $HOME/.aws:/root/.aws:ro \
  openzipkin/zipkin
```

### Kafka

The docker-compose configuration can be extended to host a test Kafka broker
using the `docker-compose-kafka.yml` file. That file employs
[docker-compose overrides](https://docs.docker.com/compose/extends/#multiple-compose-files)
to add a Kafka+ZooKeeper container and relevant settings.

To start the MySQL+Kafka configuration, run:

    $ docker-compose -f docker-compose.yml -f docker-compose-kafka.yml up

By default, this assumes your Docker host IP is 192.168.99.100, which is what
you would use for the broker IP when configuring application instrumentation.

### UI

The docker-compose configuration can be extended to host the [experimental new
UI](https://github.com/openzipkin/zipkin-ui) on port 80 using `docker-compose-ui.yml`.
That file employs [docker-compose overrides](https://docs.docker.com/compose/extends/#multiple-compose-files)
to add an NGINX container and relevant settings.

To start the NGINX configuration, run:

    $ docker-compose -f docker-compose.yml -f docker-compose-ui.yml up

This container doubles as a skeleton for creating proxy configuration around
Zipkin like authentication, dealing with CORS with zipkin-js apps, or
terminating SSL. 

### Legacy

The docker-compose files described above use version 2 of the docker-compose
config file format. There is a legacy version 1 configuration also available, in
`docker-compose-legacy.yml`. That configuration relies on container linking.

To start the legacy configuration, run:

    $ docker-compose -f docker-compose-legacy.yml up

## Notes

All images share a base image, `openzipkin/jre-full`, built on the Alpine image
[`delitescere/java:8`](https://github.com/delitescere/docker-zulu), which is much
smaller than the previously used `debian:sid`d image.

If using a provided MySQL server or image, ensure schema and other parameters match the [docs](https://github.com/openzipkin/zipkin/tree/master/zipkin-storage/mysql#applying-the-schema).
