############################################################
# Dockerfile para el ubuntu phpfpm 7.1 con pthreads activo
# Basado en Ubuntu 16.04
############################################################
# Indicar la imagen base
FROM ubuntu:16.04

# Archivo Autor / Mantenimiento
LABEL maintainer="Luis Briceño<luijo265@gmail.com>"

# Previa instalación de paquetes PHP
RUN apt-get -y update && apt-get -y install git nano autoconf \
	make build-essential re2c bison libxml2-dev libssl-dev \
	 libcurl4-openssl-dev pkg-config libbz2-dev libenchant-dev \
	 libjpeg-turbo8-dev libpng-dev libfreetype6-dev libmcrypt-dev \
	 libpspell-dev libreadline-dev libxslt-dev 
RUN mkdir -p /etc/php7
RUN mkdir -p /etc/php7/cli

# Cuando se quiere instalar gmp
RUN apt-get -y install libgmp-dev
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h


# Instalacion de paquetes PHP
# Descarga de archivos necesarios
RUN git clone https://github.com/php/php-src.git /home/php-src -b PHP-7.1.23 --depth=1
RUN git clone https://github.com/sjdskl/pthreads-php7.1.git /home/php-src/ext/pthreads
WORKDIR /home/php-src/
RUN ./buildconf --force
RUN ./configure --prefix=/etc/php7 \
	--with-bz2 --with-zlib --enable-zip \
    --enable-intl --with-mcrypt \
    --with-openssl --with-readline --with-curl \
    --with-pspell --with-enchant --with-gettext \
    --enable-sockets --enable-sysvsem \
    --enable-sysvshm --enable-sysvmsg \
    --with-gd --with-jpeg-dir --with-png-dir \
    --with-freetype-dir --with-xsl \
    # --enable-mysqlnd --with-mysqli=mysqlnd \
    # --with-pdo-mysql=mysqlnd \
    --enable-mbstring --with-xmlrpc \
    --enable-simplexml --enable-json --enable-xml \
    --enable-dom --enable-opcache --enable-shmop \
    --enable-wddx --with-pcre-regex \
    --with-config-file-path=/etc/php7/cli \
    --with-config-file-scan-dir=/etc/php7/etc \
    --with-tsrm-pthreads --enable-fpm --enable-exif \
    --enable-debug --enable-cgi --enable-cli \
    --enable-maintainer-zts \
    --with-gmp \
    --with-fpm-user=www-data --with-fpm-group=www-data
RUN make && make install
## Version 0.3
RUN update-alternatives --install /usr/bin/php php /etc/php7/bin/php 50 --slave /usr/share/man/man1/php.1.gz php.1.gz /etc/php7/php/man/man1/php.1 && \
	update-alternatives --set php /etc/php7/bin/php

RUN update-alternatives --install /usr/bin/phar phar /etc/php7/bin/phar 50 --slave /usr/share/man/man1/phar.1.gz phar.1.gz /etc/php7/php/man/man1/phar.1 && \
	update-alternatives --set phar /etc/php7/bin/phar

RUN update-alternatives --install /usr/bin/phar.phar phar.phar /etc/php7/bin/phar.phar 50 --slave /usr/share/man/man1/phar.phar.1.gz phar.phar.1.gz /etc/php7/php/man/man1/phar.phar.1 && \
	update-alternatives --set phar.phar /etc/php7/bin/phar.phar

RUN update-alternatives --install /usr/bin/phpize phpize /etc/php7/bin/phpize 50 --slave /usr/share/man/man1/phpize.1.gz phpize.1.gz /etc/php7/php/man/man1/phpize.1 && \
	update-alternatives --set phpize /etc/php7/bin/phpize

RUN update-alternatives --install /usr/bin/php-config php-config /etc/php7/bin/php-config 50 --slave /usr/share/man/man1/php-config.1.gz php-config.1.gz /etc/php7/php/man/man1/php-config.1 && \
	update-alternatives --set php-config /etc/php7/bin/php-config

RUN update-alternatives --install /usr/bin/php-fpm php-fpm /etc/php7/sbin/php-fpm 50 --slave /usr/share/man/man8/php-fpm.1.gz php-fpm.1.gz /etc/php7/php/man/man8/php-fpm.8 && \
	update-alternatives --set php-fpm /etc/php7/sbin/php-fpm

RUN update-alternatives --install /usr/bin/pecl pecl /etc/php7/bin/pecl 50 && \
	update-alternatives --set pecl /etc/php7/bin/pecl

RUN	chmod o+x /etc/php7/bin/phpize && chmod o+x /etc/php7/bin/php-config
WORKDIR /home/php-src/ext/pthreads
RUN phpize
RUN ./configure --prefix=/etc/php7 \
	--with-libdir=/lib/x86_64-linux-gnu \
	--enable-pthreads=shared \
	--with-php-config=/etc/php7/bin/php-config
RUN make && make install
RUN pecl install mongodb

COPY ./php.ini:/etc/php7/cli/php.ini
COPY ./php-cli.ini:/etc/php7/cli/php-cli.ini
COPY ./php-fpm.conf:/etc/php7/etc/php-fpm.conf
RUN php-fpm --fpm-config /etc/php7/etc/php-fpm.conf
RUN rm -rf /home/php-src
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# RUN cp -r php.ini-development /etc/php7/cli/php.ini
# RUN cp -r php.ini-development /etc/php7/cli/php-cli.ini
# RUN echo "extension=pthreads.so" > /etc/php7/cli/php-cli.ini
# RUN echo "zend_extension=opcache.so" >> /etc/php7/cli/php.ini
# RUN cp /etc/php7/etc/php-fpm.conf.default /etc/php7/etc/php-fpm.conf


## Version 0.4

