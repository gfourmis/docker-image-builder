############################################################
# Dockerfile para el back Python con Flask
# Basado en python oficial repository
############################################################

# Indicar la imagen base
FROM python:3

# Archivo Autor / Mantenimiento
LABEL maintainer="Luis Briceño<luijo265@gmail.com>"

# Comandos a ejecutar al iniciar el contenedor
WORKDIR /opt/app
COPY requeriments.txt ./
RUN pip install --no-cache-dir -r requeriments.txt
COPY run.py app.py
CMD [ "python", "./app.py" ]


