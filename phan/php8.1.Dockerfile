FROM php:8.1-cli
RUN pecl install ast && docker-php-ext-enable ast;
RUN pecl install mongodb && docker-php-ext-enable mongodb;
RUN pecl install igbinary && docker-php-ext-enable igbinary;
RUN apt-get update && \
    apt-get install -y libz-dev libmemcached-dev libmemcached11 zlib1g-dev libmemcached-dev libsasl2-dev  libssl-dev && \
    yes '' | pecl install memcached && \
    docker-php-ext-enable memcached && \
    apt-get clean
RUN apt-get update && apt-get install -y \
        libicu-dev \
        && docker-php-ext-configure intl \
        && docker-php-ext-install intl \
        && apt-get clean
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && docker-php-ext-install pdo pdo_mysql ;
RUN apt-get update && apt-get install -y git  && apt-get clean
RUN apt-get update && apt-get install -y libzip-dev unzip && docker-php-ext-install zip && apt-get clean;
RUN docker-php-ext-install bcmath;
RUN pecl install apcu && docker-php-ext-enable apcu
RUN apt-get update && apt-get install -y libxml2-dev && docker-php-ext-configure soap && docker-php-ext-install soap && apt-get clean;
RUN apt-get install libwebp-dev libjpeg-dev libpng-dev -y && docker-php-ext-install gd;
RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap
RUN curl -L -o /usr/local/bin/phan https://github.com/phan/phan/releases/download/5.4.3/phan.phar && chmod +x /usr/local/bin/phan
RUN curl -L -o /usr/local/bin/composer https://github.com/composer/composer/releases/download/2.6.6/composer.phar && chmod +x /usr/local/bin/composer
WORKDIR /mnt/src
