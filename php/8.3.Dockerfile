ARG PHP_VERSION=8.0-fpm
FROM php:$PHP_VERSION AS php-with-dependencies
WORKDIR /usr/src/app
RUN mkdir -p /usr/local/etc/php/conf.d
RUN docker-php-ext-install \
    bcmath 
RUN docker-php-ext-enable opcache sodium
## SOAP
RUN set -xe \
    && apt-get update &&  apt-get install -y libxml2-dev \
    && docker-php-ext-install soap \
    && docker-php-ext-enable soap \
    && rm -rf /var/lib/apt/lists/*
## ZIP
RUN set -xe \
    && apt-get update && apt-get install -y zlib1g-dev libzip-dev \
    && docker-php-ext-install zip \
    && docker-php-ext-enable zip \
    && rm -rf /var/lib/apt/lists/*
## ICU/INTL
RUN set -xe \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl \
    && rm -rf /var/lib/apt/lists/*
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
ARG PHPEXT_MEMCACHED_VERSION=3.3.0
RUN set -eux; \
  persistentDeps=" \
    libmemcached11 \
    libmemcachedutil2 \
    libzip4 \
    zlib1g \
  "; \
  buildDeps=" \
    libmemcached-dev \
    libssl-dev \
    libzip-dev \
    zlib1g-dev \
  "; \
  DEBIAN_FRONTEND=noninteractive apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ${persistentDeps} \
    ${buildDeps} \
  ; \
  \
  pecl bundle -d /usr/src/php/ext memcached-${PHPEXT_MEMCACHED_VERSION}; \
  docker-php-ext-configure memcached --enable-memcached-igbinary="yes" --enable-memcached-msgpack="yes"; \
  docker-php-ext-install -j$(nproc) memcached; \
  \
  DEBIAN_FRONTEND=noninteractive apt-get purge -y --auto-remove \
    -o APT::AutoRemove::RecommendsImportant=false \
    -o APT::AutoRemove::SuggestsImportant=false \
    ${buildDeps} \
  ; \
  docker-php-source delete; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
## APCU
RUN set -xe \
    && pecl channel-update pecl.php.net \
    && pecl install apcu \
    && docker-php-ext-enable apcu
RUN set -xe \
    && apt-get update && apt-get install -y  libpng16-16 libpng-dev  \
    && docker-php-ext-install gd \
    && docker-php-ext-enable gd \
    && rm -rf /var/lib/apt/lists/*
RUN set -xe \
    && docker-php-ext-install pcntl \
    && docker-php-ext-enable pcntl

ENV DOCKER=true
RUN set -eux; { \
    echo "[PHP]"; \
    echo "date.timezone=UTC"; \
    } | tee -a /usr/local/etc/php/conf.d/99-timezone.ini
RUN set -eux; rm /usr/local/etc/php-fpm.d/*.conf
## MONGODB
RUN set -xe \
    && apt update -y && apt-get install libssl-dev libzstd-dev -y \
    && pecl channel-update pecl.php.net \
    && pecl install mongodb-1.20.1 \
    && docker-php-ext-enable mongodb \
    && rm -rf /var/lib/apt/lists/*
## MYSQL
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && docker-php-ext-install pdo pdo_mysql
RUN set -xe \
    && pecl channel-update pecl.php.net \
    && pecl install redis \
    && docker-php-ext-enable redis