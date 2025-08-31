FROM php:8.3-bookworm-cli
RUN pecl install ast && docker-php-ext-enable ast;
RUN pecl install mongodb && docker-php-ext-enable mongodb;
RUN apt-get update && \
    apt-get install -y \
        git libzip-dev unzip libmemcached-dev libz-dev libxml2-dev \
        libc-client-dev libkrb5-dev libfreetype6-dev libjpeg62-turbo-dev \
        libpng-dev libwebp-dev\
    && apt-get clean && rm -r /var/lib/apt/lists/*;
RUN pecl install igbinary && docker-php-ext-enable igbinary;
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure soap && \
    docker-php-ext-install intl soap pdo pdo_mysql zip bcmath
RUN pecl install memcached && docker-php-ext-enable memcached
RUN pecl install apcu && docker-php-ext-enable apcu
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
        && docker-php-ext-install imap \
        && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-freetype \
        && docker-php-ext-install gd

RUN curl -L -o /usr/local/bin/phan https://github.com/phan/phan/releases/download/5.4.5/phan.phar && chmod +x /usr/local/bin/phan
COPY --from=composer:2.4 /usr/bin/composer /usr/local/bin/composer
WORKDIR /mnt/src
