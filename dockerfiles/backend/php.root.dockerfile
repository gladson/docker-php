FROM php:7.3.33-fpm-alpine3.14

LABEL br.com.immensa.authors="gladson@immensa.com.br"

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

ADD ./backend/php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN chown laravel:laravel -R /var/www/html

RUN set -ex \
    && apk --no-cache add \
    postgresql-dev

RUN docker-php-ext-install gd intl zip pdo pdo_mysql pdo_pgsql 

RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS} \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del pcre-dev ${PHPIZE_DEPS}

RUN chown laravel:laravel /var/www/html