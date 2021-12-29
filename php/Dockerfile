FROM php:8.0-fpm as php-with-dependencies
WORKDIR /usr/src/app
RUN mkdir -p /usr/local/etc/php/conf.d
RUN docker-php-ext-install \
    bcmath \
    opcache

## SOAP
RUN set -xe \
    && apt-get update &&  apt-get install -y libxml2-dev \
    && docker-php-ext-install soap \
    && docker-php-ext-enable soap
## ZIP
RUN set -xe \
    && apt-get update && apt-get install -y zlib1g-dev libzip-dev \
    && docker-php-ext-install zip \
    && docker-php-ext-enable zip
## ICU/INTL
RUN set -xe \
    && apt-get update && apt-get install -y  icu-devtools libicu-dev libicu67 \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl
## IGBINARY
RUN set -xe \
    && pecl channel-update pecl.php.net \
    && pecl install igbinary \
    && docker-php-ext-enable igbinary
## MSGPACK
RUN set -xe \
    && pecl channel-update pecl.php.net \
    && pecl install msgpack \
    && docker-php-ext-enable msgpack
## MEMCACHED
ENV MEMCACHED_DEPS zlib1g-dev libmemcached-dev libsasl2-dev
RUN set -xe \
    && apt-get update && apt-get install -y  $MEMCACHED_DEPS libmemcached11 zlib1g \
    && pecl channel-update pecl.php.net \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini
## APCU
RUN set -xe \
    && pecl channel-update pecl.php.net \
    && pecl install apcu \
    && docker-php-ext-enable apcu
RUN set -xe \
    && apt-get update && apt-get install -y  libpng16-16 libpng-dev  \
    && docker-php-ext-install gd \
    && docker-php-ext-enable gd
RUN set -xe \
    && docker-php-ext-install pcntl \
    && docker-php-ext-enable pcntl

ENV DOCKER true
RUN set -eux; { \
    echo "[PHP]"; \
    echo "date.timezone=UTC"; \
    } | tee -a /usr/local/etc/php/conf.d/99-timezone.ini
RUN set -eux; rm /usr/local/etc/php-fpm.d/*.conf
## MONGODB
RUN set -xe \
    && apt update -y && apt-get install libssl-dev -y \
    && pecl channel-update pecl.php.net \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb
## MYSQL
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && docker-php-ext-install pdo pdo_mysql
