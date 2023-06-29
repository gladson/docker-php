FROM php:8.2.4-fpm-alpine3.17

LABEL br.com.immensa.authors="gladson@immensa.com.br"

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN chown laravel:laravel -R /var/www/html

RUN apk update && apk add --no-cache \
    zip \
    unzip \
    dos2unix \
    libzip-dev

RUN apk upgrade 

RUN curl -sS https://getcomposer.org/installer | php \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer

RUN rm -rf /root/.composer/cache/* \
    && rm -rf /var/cache/apk/

RUN composer config --global process-timeout 7000

CMD ["composer"]