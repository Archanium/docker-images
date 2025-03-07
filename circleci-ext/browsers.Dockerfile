FROM cimg/php:8.0.28-browsers
RUN sudo apt update && sudo apt install libxml2-dev libzip-dev libwebp-dev libjpeg-dev libpng-dev libz-dev libxpm-dev libmcrypt-dev libssl-dev mariadb-client libicu-dev openssl libmemcached-dev
RUN sudo apt-get update && sudo apt-get install -y libc-client-dev libkrb5-dev && sudo rm -r /var/lib/apt/lists/*
RUN sudo docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && sudo docker-php-ext-install imap
RUN sudo pecl channel-update pecl.php.net
RUN printf "\n" | sudo pecl install memcached
RUN sudo docker-php-ext-install zip pdo pdo_mysql soap intl xml bcmath pcntl gd
RUN sudo pecl install mongodb-1.20.1 pcov apcu
RUN sudo docker-php-ext-enable mongodb zip pdo pdo_mysql soap intl xml memcached pcov bcmath apcu gd
RUN echo "[PHP]\\ndate.timezone=UTC" | sudo tee -a /usr/local/etc/php/conf.d/tzone.ini
RUN sudo apt-get install nginx
CMD ["/bin/sh"]
