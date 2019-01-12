############################################################
# Dockerfile para el ubuntu phpfpm 7.1 con pthreads activo
# Basado en Ubuntu 16.04
############################################################
# Indicar la imagen base
FROM ubuntu:16.04

# Archivo Autor / Mantenimiento
LABEL maintainer="Luis Briceño<luijo265@gmail.com>"

#### Previa instalación de paquetes PHP ####
RUN apt-get -y update && apt-get -y install git nano autoconf \
	make build-essential re2c bison libxml2-dev libssl-dev \
	 libcurl4-openssl-dev pkg-config libbz2-dev libenchant-dev \
	 libjpeg-turbo8-dev libpng-dev libfreetype6-dev libmcrypt-dev \
	 libpspell-dev libreadline-dev libxslt-dev 
RUN mkdir -p /etc/php7
RUN mkdir -p /etc/php7/cli

#### Cuando se quiere instalar gmp ####
RUN apt-get -y install libgmp-dev
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h


#### Instalacion de paquetes PHP ####
#### Clonar php sources 7.1 y pthreads ####
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
    # --enable-mysqlnd --with-mysqli=mysqlnd \  # Habilitar si se requiere
    # --with-pdo-mysql=mysqlnd \                # php-mysql
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

#### Asignar como globales ejecutables de php sources ####
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

#### Asignar permisos a ejecutables ####
RUN	chmod o+x /etc/php7/bin/phpize && chmod o+x /etc/php7/bin/php-config

#### Preparando para instalar pthreads ####
WORKDIR /home/php-src/ext/pthreads
RUN phpize
RUN ./configure --prefix=/etc/php7 \
	--with-libdir=/lib/x86_64-linux-gnu \
	--enable-pthreads=shared \
	--with-php-config=/etc/php7/bin/php-config
RUN make && make install

#### Para instalar mongo ####
RUN pecl install mongodb

#### Copiando configuraciones requeridas ####
COPY ./php.ini /etc/php7/cli/php.ini
COPY ./php-cli.ini /etc/php7/cli/php-cli.ini
COPY ./php-fpm.conf /etc/php7/etc/php-fpm.conf
COPY ./www.conf /etc/php7/etc/php-fpm.d/www.conf
WORKDIR /

#### Eliminando archivos de instalacion ####
RUN rm -rf /home/php-src

#### Instalacion y configuracion de apache ####
RUN apt-get install -y apache2

#### Cargar variables globales de apache ####
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2

#### Configuracion de apache2 ####
RUN mkdir -p /var/lock/apache2
RUN a2enmod rewrite
COPY ./dk.agileteams.local.conf /etc/apache2/sites-available/dk.agileteams.local.conf
RUN a2dismod mpm_worker && a2dismod mpm_prefork
RUN a2dissite 000-default.conf
RUN a2ensite dk.agileteams.local.conf
RUN a2enmod proxy_fcgi
RUN apt-get install wget
RUN wget https://raw.githubusercontent.com/pixelb/ps_mem/master/ps_mem.py \
	&& chmod a+x ps_mem.py
COPY ./mpm-event.conf /etc/apache2/mods-enabled/mpm-event.conf
COPY ./init_service.sh /init_service.sh
RUN chmod 777 /init_service.sh

#### Limpiar los repositorios descargador y cache de instalacion ####
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


#### Puerto a exponer. ####
EXPOSE 80 443

#### Configurar que ejecutará al iniciar el contenedor ####
CMD /init_service.sh