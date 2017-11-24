# pins on 1.11 as it is built against Alpine 3.4 which doesn't die with SSL certificate problem
FROM nginx:1.11-alpine

ENV ZIPKIN_REPO https://jcenter.bintray.com
ENV ZIPKIN_VERSION 2.3.1
ENV ZIPKIN_BASE_URL=http://zipkin:9411

RUN apk add --update --no-cache nginx curl && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/* && \
    # the current version of zipkin-ui is in a path of the same name in a jar file. This extracts it.
    curl -SL $ZIPKIN_REPO/io/zipkin/java/zipkin-ui/$ZIPKIN_VERSION/zipkin-ui-$ZIPKIN_VERSION.jar > zipkin-ui.jar && \
    mkdir /var/www/html && \
    unzip zipkin-ui.jar 'zipkin-ui/*' -d /var/www/html && \
    mv /var/www/html/zipkin-ui /var/www/html/zipkin && \
    rm -rf zipkin-ui.jar

# Setup services
ADD nginx.conf /etc/nginx/conf.d/zipkin.conf.template
ADD run.sh /usr/local/bin/nginx.sh

EXPOSE 80

CMD ["/usr/local/bin/nginx.sh"]
