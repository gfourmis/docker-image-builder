############################################################
# Dockerfile para el ubuntu phpfpm 7.1 con pthreads activo
# Basado en Ubuntu 16.04
############################################################
# Indicar la imagen base
FROM ubuntu:16.04

# Archivo Autor / Mantenimiento
LABEL maintainer="Luis Briceño<luijo265@gmail.com>"

# Previa instalación de paquetes PHP
RUN apt-get -y update && apt-get -y install git nano
RUN mkdir -p /etc/php7
RUN mkdir -p /etc/php7/cli
RUN cd /home

# Cuando se quiere instalar gmp
RUN apt-get -y install libgmp-dev
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h


# Instalacion de paquetes PHP
# Descarga de archivos necesarios
RUN pwd
RUN git clone https://github.com/php/php-src.git -b PHP-7.1.23 --depth=1
RUN pwd
RUN cd /home/php-src/ext
RUN git clone https://github.com/sjdskl/pthreads-php7.1.git

## Version 0.2