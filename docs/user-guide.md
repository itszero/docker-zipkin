# Docker toolbox & docker-zipkin on Mac OS X

## Installation

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (`5.0.3+`).

* Install [Docker Toolbox](https://www.docker.com/toolbox).
  * if afterwards the `Docker Quickstart Terminal` doesn't work the docker machine might be botched (incompatible VirtualBox version etc), see the next section.

## Configuration of Docker

```sh
docker-machine ls
# NAME      ACTIVE   DRIVER       STATE     URL   SWARM
# default            virtualbox   Stopped

docker-machine start default
# Starting VM...
# Started machines may have new IP addresses. You may need to re-run the `docker-machine env` command.

docker-machine ls
# NAME      ACTIVE   DRIVER       STATE     URL                         SWARM
# default            virtualbox   Running   tcp://192.168.99.100:2376

docker-machine env default
# export DOCKER_TLS_VERIFY="1"
# export DOCKER_HOST="tcp://192.168.99.101:2376"
# export DOCKER_CERT_PATH="/Users/jfeltesse/.docker/machine/machines/default"
# export DOCKER_MACHINE_NAME="default"
# # Run this command to configure your shell:
# # eval "$(docker-machine env default)"

eval "$(docker-machine env default)"
# (no output)

docker run hello-world
# should pull and run the hello-world image
```

### Machine not working

If `docker-machine env default` throws an error (missing ca.pem file and such) try to re-create the default machine by running:

```sh
docker-machine rm default
docker-machine create --driver virtualbox default
```


## Running docker-zipkin

After going successfully through the docker configuration, the system is ready to give that docker-zipkin project a try!

```sh
git clone git@github.com:openzipkin/docker-zipkin.git
cd docker-zipkin
```

Before actually starting the machine check it is active

```sh
docker-machine ls
# NAME      ACTIVE   DRIVER       STATE     URL                         SWARM
# default   *        virtualbox   Running   tcp://192.168.99.101:2376
```

If it's not then simply do `docker-machine env default && eval "$(docker-machine env default)"`

At this point `docker ps` should output a blank table because nothing is running.

Run `docker-compose up` in the docker-zipkin directory (so it picks up the `docker-compose.yml` file) and wait until it's done downloading everything and flooding the console with all sorts of messages.

Now `docker ps` should display something like

```
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS              PORTS                              NAMES
82d09c0b6244        openzipkin/zipkin:1.11.0         "/bin/sh -c 'test -n "   36 seconds ago      Up 36 seconds       0.0.0.0:9410-9411->9410-9411/tcp   zipkin
81dbabc16591        openzipkin/zipkin-dependencies   "crond -f"               12 hours ago        Up 36 seconds                                          dependencies
88fb6ac58893        openzipkin/zipkin-mysql:1.11.0   "/bin/sh -c /mysql/ru"   12 hours ago        Up 36 seconds       0.0.0.0:3306->3306/tcp             mysql
```

Zipkin listens on a couple ports: 9411 (web ui and http api), 9410 (scribe collector)

```sh
$ docker port zipkin
9410/tcp -> 0.0.0.0:9410
9411/tcp -> 0.0.0.0:9411
```

But you can't simply access these using localhost because
> “[...] your DOCKER_HOST address is not the localhost address (0.0.0.0) but is instead the address of the your Docker VM.” [→ source](http://docs.docker.com/installation/mac/#example-of-docker-on-mac-os-x)

To get the proper ip run `docker-machine ip default` and access it on port 9411.

Zipkin's top page should come up!

## Upgrading docker-zipkin

Just sync your local repo and run `docker-compose up` again.
It will automagically download the images in the containers' docker files and run the machine.

## Zipkin's storage schema

- [Cassandra](https://github.com/openzipkin/zipkin/blob/master/zipkin-storage/cassandra/src/main/resources/cassandra-schema-cql3.txt)
- [MySQL](https://github.com/openzipkin/zipkin/blob/master/zipkin-storage/mysql/src/main/resources/mysql.sql)

## Connecting to the storage directly

### Cassandra

```
brew install cassandra
```

Then run the following to connect:

```sh
cqlsh `docker-machine ip default` --cqlversion=3.2.0
```

