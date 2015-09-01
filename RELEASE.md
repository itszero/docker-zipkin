# Releasing a New Version

This document describes how to release a new set of Docker images for OpenZipkin. The images are built automatically
on [quay.io](https://quay.io), a service similar to Docker Hub.

## Tag structure

 * Don't use `-rc` tags; in this special case, it's perfectly fine to move tags around.
 * Create a tag for each sub-minor version, for example `1.4.1`
 * Create a tag for each minor version, for example `1.4`, and update it to the latest sub-minor under it.
 * If / when  we introduce a new major release, create tags for each major release (`1` and `2` for example),
   and keep them up-to-date with their latest minor.

## Release process

The examples below will use the release number `1.4.1`.

1. **Bump the `ZIPKIN_VERSION` ENV var in `zipkin-base`**

   This will be used in various install scripts to pull in the right Zipkin release. Commit, push.

1. **Create, push the git tag `base-1.4.1`**

   Tags starting with `base-` trigger a build for `zipkin-base`, and nothing else.

1. **Wait for `zipkin-base`**

   You can track all the builds of `zipkin-base` [here](https://quay.io/repository/openzipkin/zipkin-base?tab=builds)

1. **Bump the version in `FROM` statement in `Dockerfile`s**

   For the projects that depend on `zipkin-base`, change their `Dockerfile`s to start building `FROM` the tag
   `base-1.4.1`. These are, unless something special happens: `cassandra`, `collector`, `query`, and `web`.
   Commit, push.

1. **Create, push the git tag `1.4.1`**

   Tags starting with a number trigger a build on `zipkin-cassandra`, `zipkin-collector`, `zipkin-query`, and `zipkin-web`.

1. **Wait for the rest of the images**

   As usual, you want to wait for: [`zipkin-cassandra`](https://quay.io/repository/openzipkin/zipkin-cassandra?tab=builds),
   [`zipkin-collector`](https://quay.io/repository/openzipkin/zipkin-collector?tab=builds),
   [`zipkin-query`](https://quay.io/repository/openzipkin/zipkin-query?tab=builds), and
   [`zipkin-web`](https://quay.io/repository/openzipkin/zipkin-web?tab=builds).

1. **Test the new images**

   Locally change `docker-compose.yml` to use the newly built versions, say `docker-compose up`, and verify
   that all is well with the world. TBD: How exactly do we do that?

1. **Commit, push `docker-compose.yml`**

1. **Done!**

   Congratulations, the intersection of the sets (OpenZipkin users) and (Docker users) can now enjoy the latest
   and greatest Zipkin release!

## Room for automation

 * Managing the tags ("make this commit `1.4.1`" would update the tags `1`, `1.4` and `1.4.1`)
 * The whole release process. Quay.io has a promising API doc at http://docs.quay.io/api/swagger/
