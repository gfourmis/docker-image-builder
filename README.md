# docker-image-builder

### Creación de imagen docker usando Dockerfile

*Previamente tener instalado docker en el servidor*

Dockerfile es un documento de texto que contiene todos los comandos que un usuario puede usar para construir una imagen `docker`

Creamos un directorio donde guardaremos el Dockerfile
```
mkdir dockerprojects
cd dockerprojects/
```
Creamos el Dockerfile y lo editamos:
```
nano Dockerfile
```
Editar con lo siguiente (que se ajuste a lo requerido):
```
############################################################
# Dockerfile para el servicio
# Basado en ...
############################################################

# Indicar la imagen base
FROM nombre_image:tag

# Archivo Autor / Mantenimiento
LABEL maintainer="Nombre Apellido<correo_electronico>"

# Comandos a ejecutar al iniciar el contenedor
# Ejemplo: 
# RUN apt update
RUN linea_de_comando

# Puerto a exponer.
EXPOSE puerto

# Definir comandos que se ejecutan sobre el contenedor
CMD ["executable","param1","param2"]

# Configurar que ejecutará al iniciar el contenedor
ENTRYPOINT ["executable", "param1", "param2"]
```
Se realiza el compilado de la nueva imagen a crear
```
docker build -t nombre_imagen .
```
Se valida que se haya creado la imagen
```
docker images
```
**Debe aparecer algo parecido a lo siguiente:**
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
apache              latest              e487d4f83c80        2 hours ago         182MB
mongo-ubuntu        1.0.1               3b95b64053cb        2 days ago          439MB
nombre_imagen       1.0.0               5951c6b1b227        2 days ago          141MB
```
Iniciar el contenedor con la opción "run" de docker. Si tiene cli para ingresar el contenedor se puede ejecutar lo siguiente:
```
docker run -it nombre_imagen
```
**NOTA:** Ejecutar "docker run --help" para conocer las opciones disponibles.