# ==========================================
# STAGE 1: Builder (Heavy lifting & granular caching)
# ==========================================
FROM php:8.3-cli-bookworm AS builder

# 1. Download the installer script
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# 2. Granular Caching: Install one extension per layer.
# If you add/remove one later, only that specific layer and below will invalidate.
RUN install-php-extensions apcu
RUN install-php-extensions ast
RUN install-php-extensions bcmath
RUN install-php-extensions gd
RUN install-php-extensions igbinary
RUN install-php-extensions imap
RUN install-php-extensions intl
RUN install-php-extensions memcached
RUN install-php-extensions mongodb
RUN install-php-extensions pdo_mysql
RUN install-php-extensions soap
RUN install-php-extensions zip


# ==========================================
# STAGE 2: Final Runtime Image
# ==========================================
FROM php:8.3-cli-bookworm

# 1. Install ONLY the runtime Linux dependencies required by the extensions above.
# (These are the lightweight versions, NOT the heavy -dev packages)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libmemcached11 \
    libzip4 \
    libxml2 \
    libc-client2007e \
    libfreetype6 \
    libjpeg62-turbo \
    libpng16-16 \
    libwebp7 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Copy the compiled extensions (.so files) from the builder
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

# 3. Copy the configuration files (.ini files) that actually enable them
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

# 4. Install Phan
RUN curl -L -o /usr/local/bin/phan https://github.com/phan/phan/releases/download/5.5.2/phan.phar \
    && chmod +x /usr/local/bin/phan

# 5. Copy Composer
COPY --from=composer:2.4 /usr/bin/composer /usr/local/bin/composer

WORKDIR /mnt/src