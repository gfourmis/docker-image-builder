############################################################
# Dockerfile para el ubuntu phpfpm
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
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y openssh-client git nano

# Puerto a exponer.
EXPOSE 80

# Configurar que ejecutará al iniciar el contenedor
ENTRYPOINT /bin/bash