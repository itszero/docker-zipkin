# docker-zipkin

Dockerfiles for starting a Zipkin instance backed by Cassandra

## Build Images

Please run `cd deploy; ./build.sh $name` to build the images on your own computer.
Where $name is base, cassandra, collector, query, or web as desired.

You may change the **PREFIX** in build.sh and deploy.sh as you see fit.

## Deploy Zipkin

Before you start, please edit the `deploy.sh` to change the URL to match your
Docker host IP, you may also change the port if needed. Now, run `cd deploy;
./deploy.sh $name` to start a complete Zipkin instance. Where $name is either
cassandra, collector, query or web.

If you did not build the
images before, you will pull the published images from Docker INDEX.

Note that if you changed PREFIX in build.sh to build your own images, you need
to make same changes here in deploy.sh. Otherwise, it will still use the
standard images pushed by me.

Alternatively, you can use
[docker-compose](https://docs.docker.com/compose/) by doing `cd
deploy; docker-compose up`. Note that you may want to change the
**PREFIX** in `deploy/docker-compose.yml` if you don't want to use the
images from Docker Index.

## Notes

Docker-Zipkin starts the services in their own container: zipkin-cassandra,
zipkin-collector, zipkin-query, zipkin-web and only link required dependencies
together.

The started Zipkin instance would be backed by a single node Cassandra. By
default, the collector port is not mapped to public. You will need to link
containers that you wish to trace with zipkin-collector or you may change the
respective line in deploy.sh to map the port.

All images with the exception of zipkin-cassandra are sharing a base image:
zipkin-base. zipkin-base and zipkin-cassandra is built on debian:sid.

`build.sh` performs some fairly intensive tasks, the heaviest of which is running
gradle. Long story short, make sure your Docker machine has 4GB memory.

Ex. If you are literally running build.sh locally..
```bash
$ docker-machine create --driver virtualbox --virtualbox-memory "4096" dev
```
## Author

Zero Cho <itszero@gmail.com>
