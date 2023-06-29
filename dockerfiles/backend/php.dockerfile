FROM php:7.3.33-fpm-alpine3.14

LABEL br.com.immensa.authors="gladson@immensa.com.br"

RUN mkdir -p /var/www/html

ADD ./backend/php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN chown laravel:laravel -R /var/www/html

RUN apk update \
    && apk upgrade \
    && apk --no-cache add \
    build-base \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    postgresql-dev

RUN apk update && apk upgrade \
    && apk add --no-cache libzip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql exif pcntl \
    && docker-php-ext-install -j$(nproc) zip

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
RUN docker-php-ext-enable gd

RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS} \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del pcre-dev ${PHPIZE_DEPS}

EXPOSE 9000

WORKDIR /var/www/html