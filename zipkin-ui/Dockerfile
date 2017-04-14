FROM nginx:alpine

ENV ZIPKIN_REPO https://jcenter.bintray.com
ENV ZIPKIN_UI_VERSION 0.2.1
ENV ZIPKIN_BASE_URL=http://zipkin:9411

RUN apk add --update --no-cache nginx curl && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/* && \
    # the current version of zipkin-ui is in a path of the same name in a jar file. This extracts it.
    curl -SL $ZIPKIN_REPO/io/zipkin/ui/zipkin-ui/$ZIPKIN_UI_VERSION/zipkin-ui-$ZIPKIN_UI_VERSION.jar > zipkin-ui.jar && \
    unzip zipkin-ui.jar 'zipkin-ui/*' -d /var/www/ && \
    mv /var/www/zipkin-ui /var/www/html && \
    rm -rf zipkin-ui zipkin-ui.jar

# Setup services
ADD nginx.conf /etc/nginx/conf.d/zipkin.conf.template
ADD run.sh /usr/local/bin/nginx.sh

EXPOSE 80

CMD /usr/local/bin/nginx.sh
