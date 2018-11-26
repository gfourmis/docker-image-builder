############################################################
# Dockerfile para el ubuntu php
# Basado en Ubuntu 16.04
############################################################

# Indicar la imagen base
FROM ubuntu:16.04

# Archivo Autor / Mantenimiento
# MAINTAINER Luis Briceño luijo265@gmail.com
LABEL maintainer="Luis Briceño<luijo265@gmail.com>"

# Comandos a ejecutar al iniciar el contenedor
#### Configuracion inicial del servidor ####
RUN apt-get update -y
RUN apt-get install -y python-software-properties software-properties-common nano
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen es_CO.UTF-8
RUN export LANG=es_CO.UTF-8
RUN export LANG=C.UTF-8
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update -y
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/Bogota /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

#### Instalación de paquetes php necesarios para el proyecto ####
RUN apt-get install -y php7.1 php7.1-mbstring php7.1-mcrypt php7.1-xml php7.1-common \
    openssh-client git php7.1-gmp php7.1-mongodb php7.1-curl php7.1-zip \
    libapache2-mod-php7.1 php7.1-dom php7.1-gettext php7.1-json php7.1-cli \
    php7.1-fpm php7.1-gd php7.1-common php7.1-xmlrpc
RUN ssh-keygen -q -t rsa -N '' -f /id_rsa

# Puerto a exponer.
EXPOSE 80

# Configurar que ejecutará al iniciar el contenedor
ENTRYPOINT /bin/bash