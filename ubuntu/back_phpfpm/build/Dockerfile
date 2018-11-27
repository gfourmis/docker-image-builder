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
RUN ./configure --prefix=/etc/php7 --with-bz2 --with-zlib --enable-zip \
    --enable-intl --with-mcrypt --with-openssl --with-readline --with-curl \
    --with-pspell --with-enchant --with-gettext --enable-sockets \
    --enable-sysvsem --enable-sysvshm --enable-sysvmsg \
    --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-xsl \
    --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
    --enable-mbstring --with-xmlrpc --enable-simplexml --enable-json \
    --enable-xml --enable-dom --enable-opcache --enable-shmop --enable-wddx \
    --with-pcre-regex --with-config-file-path=/etc/php7/cli \
    --with-config-file-scan-dir=/etc/php7/etc \
    --with-tsrm-pthreads --enable-fpm --enable-exif \
    --enable-debug --enable-cgi --enable-cli --enable-maintainer-zts \
    --with-gmp \
    --with-fpm-user=www-data --with-fpm-group=www-data
RUN make && make install

## Version 0.2