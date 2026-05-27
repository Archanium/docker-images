ARG PHP_VERSION=8.0
FROM cimg/php:$PHP_VERSION

RUN sudo apt update

RUN sudo apt install libxml2-dev libzip-dev libz-dev libxpm-dev libmcrypt-dev libssl-dev mariadb-client libicu-dev openssl libmemcached-dev
RUN sudo apt-get update && sudo apt-get install -y libc-client-dev libkrb5-dev && sudo rm -r /var/lib/apt/lists/*

RUN sudo pecl channel-update pecl.php.net
RUN printf "\n" | sudo pecl install memcached
RUN sudo docker-php-ext-install zip pdo pdo_mysql soap intl xml bcmath pcntl
RUN sudo apt-get update && sudo apt-get install -y \
		libfreetype-dev \
		libjpeg-dev \
        libwebp-dev \
		libpng-dev \
	&& sudo docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp  \
	&& sudo docker-php-ext-install -j$(nproc) gd

RUN sudo pecl install mongodb-1.20.1 pcov apcu
RUN sudo docker-php-ext-enable zip pdo pdo_mysql soap intl xml memcached pcov bcmath apcu gd mongodb
RUN echo "[PHP]\\ndate.timezone=UTC" | sudo tee -a /usr/local/etc/php/conf.d/tzone.ini
CMD ["/bin/sh"]
