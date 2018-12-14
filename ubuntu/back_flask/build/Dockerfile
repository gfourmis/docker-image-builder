############################################################
# Dockerfile para el back Python con Flask
# Basado en ubuntu 16.04
############################################################

# Indicar la imagen base
# FROM ubuntu:16.04
FROM python:3

# Archivo Autor / Mantenimiento
LABEL maintainer="Luis Briceño<luijo265@gmail.com>"

# Comandos a ejecutar al iniciar el contenedor
WORKDIR /opt/app
COPY requeriments.txt ./
RUN pip install --no-cache-dir -r requeriments.txt
COPY app.py .
CMD [ "python", "./app.py" ]


