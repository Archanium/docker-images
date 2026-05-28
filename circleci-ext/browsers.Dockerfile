ARG PHP_VERSION=8.0-browsers
FROM cimg/php:$PHP_VERSION

RUN sudo apt-get update && sudo apt-get install -y libxml2-dev libzip-dev libz-dev libxpm-dev libmcrypt-dev libssl-dev mariadb-client libicu-dev openssl libmemcached-dev && sudo rm -r /var/lib/apt/lists/*
RUN sudo apt-get update && sudo apt-get install -y libc-client-dev libkrb5-dev && sudo rm -r /var/lib/apt/lists/*

RUN sudo pecl channel-update pecl.php.net
RUN printf "\n" | sudo pecl install memcached

RUN sudo pecl install mongodb-1.20.1 pcov apcu
RUN echo "[PHP]\\ndate.timezone=UTC" | sudo tee -a /usr/local/etc/php/conf.d/tzone.ini
RUN sudo apt-get update && sudo apt-get install nginx && sudo rm -r /var/lib/apt/lists/*
CMD ["/bin/sh"]
