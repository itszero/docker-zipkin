# zipkin-ui

This container doubles as a skeleton for creating proxy configuration around
Zipkin like authentication, dealing with CORS with zipkin-js apps, or
terminating SSL. It can also be adapted to test new UIs.

## How this works
Zipkin's UI is bundled into a jar (zip) file under a relative path of '/zipkin'.
This layers over an nginx image with [the latest jar](https://search.maven.org/search?q=g:io.zipkin%20AND%20a:zipkin-lens) extracted
into `/var/www/html/zipkin`.

The 'nginx.conf' in this image is a template, currently with one parameter
`ZIPKIN_BASE_URL` corresponding to where api requests are forwarded to. A
typical setup is `ZIPKIN_BASE_URL=http://zipkin:9411`. The two resources
forwarded are the api (/zipkin/api) and the config (/zipkin/config.json).

Zipkin's UI only calls GET (not POST) operations in the [v2 api](https://zipkin.io/zipkin-api/#/).
For example, if it calls for services names, it will end up invoking:
`GET ${ZIPKIN_BASE_URL}/zipkin/api/v2/services`

Beyond hosting of assets and forwarding, this also sets redirects,
cache-control headers, etc similar to what the normal [zipkin-server would](https://github.com/openzipkin/zipkin/blob/master/zipkin-server/src/main/java/zipkin2/server/internal/ui/ZipkinUiConfiguration.java).
This lets you use a more familiar nginx syntax for things such as how long
a browser should cache the result of the service names query.
