ARG PHP_VERSION=8.0-cli
FROM php:$PHP_VERSION as php-with-dependencies
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
## MONGODB
RUN set -xe \
    && apt update -y && apt-get install libssl-dev -y \
    && pecl channel-update pecl.php.net \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb
## MYSQL
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && docker-php-ext-install pdo pdo_mysql
RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install gd
RUN set -ex \
    && savedAptMark="$(apt-mark showmanual)" \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y ca-certificates mercurial build-essential libssl-dev libpcre2-dev curl pkg-config \
    && mkdir -p /usr/lib/unit/modules /usr/lib/unit/debug-modules \
    && mkdir -p /usr/src/unit \
    && cd /usr/src/unit \
    && hg clone -u 1.31.0-1 https://hg.nginx.org/unit \
    && cd unit \
    && NCPU="$(getconf _NPROCESSORS_ONLN)" \
    && DEB_HOST_MULTIARCH="$(dpkg-architecture -q DEB_HOST_MULTIARCH)" \
    && CC_OPT="$(DEB_BUILD_MAINT_OPTIONS="hardening=+all,-pie" DEB_CFLAGS_MAINT_APPEND="-Wp,-D_FORTIFY_SOURCE=2 -fPIC" dpkg-buildflags --get CFLAGS)" \
    && LD_OPT="$(DEB_BUILD_MAINT_OPTIONS="hardening=+all,-pie" DEB_LDFLAGS_MAINT_APPEND="-Wl,--as-needed -pie" dpkg-buildflags --get LDFLAGS)" \
    && CONFIGURE_ARGS_MODULES="--prefix=/usr \
                --statedir=/var/lib/unit \
                --control=unix:/var/run/control.unit.sock \
                --runstatedir=/var/run \
                --pid=/var/run/unit.pid \
                --logdir=/var/log \
                --log=/var/log/unit.log \
                --tmpdir=/var/tmp \
                --user=unit \
                --group=unit \
                --openssl \
                --libdir=/usr/lib/$DEB_HOST_MULTIARCH" \
    && CONFIGURE_ARGS="$CONFIGURE_ARGS_MODULES \
                --njs" \
    && make -j $NCPU -C pkg/contrib .njs \
    && export PKG_CONFIG_PATH=$(pwd)/pkg/contrib/njs/build \
    && ./configure $CONFIGURE_ARGS --cc-opt="$CC_OPT" --ld-opt="$LD_OPT" --modulesdir=/usr/lib/unit/debug-modules --debug \
    && make -j $NCPU unitd \
    && install -pm755 build/sbin/unitd /usr/sbin/unitd-debug \
    && make clean \
    && ./configure $CONFIGURE_ARGS --cc-opt="$CC_OPT" --ld-opt="$LD_OPT" --modulesdir=/usr/lib/unit/modules \
    && make -j $NCPU unitd \
    && install -pm755 build/sbin/unitd /usr/sbin/unitd \
    && make clean \
    && /bin/true \
    && ./configure $CONFIGURE_ARGS_MODULES --cc-opt="$CC_OPT" --modulesdir=/usr/lib/unit/debug-modules --debug \
    && ./configure php \
    && make -j $NCPU php-install \
    && make clean \
    && ./configure $CONFIGURE_ARGS_MODULES --cc-opt="$CC_OPT" --modulesdir=/usr/lib/unit/modules \
    && ./configure php \
    && make -j $NCPU php-install \
    && cd \
    && rm -rf /usr/src/unit \
    && for f in /usr/sbin/unitd /usr/lib/unit/modules/*.unit.so; do \
        ldd $f | awk '/=>/{print $(NF-1)}' | while read n; do dpkg-query -S $n; done | sed 's/^\([^:]\+\):.*$/\1/' | sort | uniq >> /requirements.apt; \
       done \
    && apt-mark showmanual | xargs apt-mark auto > /dev/null \
    && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; } \
    && ldconfig \
    && mkdir -p /var/lib/unit/ \
    && mkdir -p /docker-entrypoint.d/ \
    && groupadd --gid 999 unit \
    && useradd \
         --uid 999 \
         --gid unit \
         --no-create-home \
         --home /nonexistent \
         --comment "unit user" \
         --shell /bin/false \
         unit \
    && apt-get update \
    && apt-get --no-install-recommends --no-install-suggests -y install curl $(cat /requirements.apt) \
    && apt-get purge -y --auto-remove build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /requirements.apt \
    && ln -sf /dev/stdout /var/log/unit.log
ADD --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint-unit.sh
STOPSIGNAL SIGTERM
