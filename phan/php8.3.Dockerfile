# ==========================================
# STAGE 1: Builder
# ==========================================
FROM php:8.3-cli-bookworm AS builder

# Chunk 1: System Dependencies (Rarely change)
RUN apt-get update && apt-get install -y \
    git libzip-dev unzip libmemcached-dev libz-dev libxml2-dev \
    libc-client-dev libkrb5-dev libfreetype6-dev libjpeg62-turbo-dev \
    libpng-dev libwebp-dev

# Chunk 2: Lightweight PECL extensions
RUN pecl install ast igbinary apcu

# Chunk 3: Heavy/C-compiled PECL extensions (Isolate the slow ones)
RUN pecl install memcached
RUN pecl install mongodb

# Chunk 4: Core PHP extensions
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure soap && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install intl bcmath soap
RUN docker-php-ext-install imap
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd

# Chunk 5: Enable all (Fast layer)
RUN docker-php-ext-enable ast igbinary apcu mongodb memcached

# ==========================================
# STAGE 2: Final Runtime Image
# ==========================================
FROM php:8.3-cli-bookworm

# 1. Install ONLY runtime dependencies (No -dev packages!)
# Note: Debian runtime package names drop the "-dev" suffix.
RUN apt-get update && apt-get install -y \
    git unzip libmemcached11 libzip4 libxml2 libc-client2007e \
    libfreetype6 libjpeg62-turbo libpng16-16 libwebp7 \
    && apt-get clean && rm -r /var/lib/apt/lists/*

# 2. Copy compiled extension binaries and configurations from the builder
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

# 3. Install Phan
RUN curl -L -o /usr/local/bin/phan https://github.com/phan/phan/releases/download/5.5.2/phan.phar \
    && chmod +x /usr/local/bin/phan

# 4. Copy Composer
COPY --from=composer:2.4 /usr/bin/composer /usr/local/bin/composer

WORKDIR /mnt/src