FROM nginx:stable-alpine

LABEL br.com.immensa.authors="gladson@immensa.com.br"

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup -g 1000 --system vuejs
RUN adduser -G vuejs --system -D -s /bin/sh -u 1000 vuejs
RUN sed -i "s/user  nginx/user vuejs/g" /etc/nginx/nginx.conf

ADD ./frontend/nginx/default.conf /etc/nginx/conf.d/

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

COPY ./dist  /var/www/html

RUN chown vuejs:vuejs -R /var/www/html

