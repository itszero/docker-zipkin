FROM nginx:1.16-alpine

# This gets whatever the latest version of zipkin-lens is
ENV ZIPKIN_REPO https://repository.apache.org/content/repositories/snapshots
ENV ZIPKIN_BASE_URL=http://zipkin:9411

RUN apk add --update --no-cache nginx curl && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/* && \
    # the current version of zipkin-lens is in a path of the same name in a jar file. This extracts it.
    LENS_BASE=$ZIPKIN_REPO/org/apache/zipkin/zipkin-lens && \
    LENS_VERSION=$(curl -sSL $LENS_BASE/maven-metadata.xml | sed -n '/<version>/s/.*<version>\([^<]*\)<\/version>.*/\1/p'|tail -1) && \
    LENS_BUILD=$(curl -sSL $LENS_BASE/$LENS_VERSION/maven-metadata.xml | sed -n '/<value>/s/.*<value>\([^<]*\)<\/value>.*/\1/p'| head -1) && \
    curl -sSL $LENS_BASE/$LENS_VERSION/zipkin-lens-$LENS_BUILD.jar > zipkin-lens.jar && \
    mkdir -p /var/www/html && \
    unzip zipkin-lens.jar 'zipkin-lens/*' -d /var/www/html && \
    mv /var/www/html/zipkin-lens /var/www/html/zipkin && \
    rm -rf zipkin-lens.jar && \
    mkdir -p /var/tmp/nginx && \
    chown -R nginx:nginx /var/tmp/nginx

# Setup services
ADD nginx.conf /etc/nginx/conf.d/zipkin.conf.template
ADD run.sh /usr/local/bin/nginx.sh

EXPOSE 80

CMD ["/usr/local/bin/nginx.sh"]
