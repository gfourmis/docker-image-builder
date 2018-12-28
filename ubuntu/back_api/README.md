# Docker Backend Agile Teams (ubuntu_api)

Contiene configuración e instalación de PHP 7.1, Apache2 en modo prefork (El por defecto).

## Contenido

1. [Para compilar y ejecutar](#id1)
2. [Para descargar y ejecutar](#id2)
3. [Configuración de virtual host](#id3)
4. [Enlazar configuración virtual host a maquina anfitrión](#id4)
5. [Enlazar contenido del proyecto maquina anfitrión](#id5)

**Lista general de paquetes instalados:**
- git
- php 7.1
- tzdata
- apache2

<div id="id1"></div>

## Para compilar y ejecutar

Colocarse dentro del directorio build
```bash
cd build
```
Ejecutar lo siguiente, se puede cambiar "ubuntu_api" por el preferido, y la versión deseada
```bash
docker build -t ubuntu_api:1.0 .
```
Luego para ejecutar como demonio o servicio de linux con docker. Se puede establecer cualquier otro nombre en "api_compile" y cuidar que se escriba el "ubuntu_api" y versión correctas.
```bash
docker run --name api_compile -p 80:80 -p 443:443 -d ubuntu_api:1.0
```
Para poder ingresar en el bash del contenedor
```bash
docker exec -it api_compile /bin/bash
```
<div id="id2"></div>

## Para descargar y ejecutar

Para ejecutar como demonio o servicio de linux con docker. Se puede establecer cualquier otro nombre en "api_compile" y cuidar que se escriba el "ubuntu_api" y versión correctas.
```bash
docker run --name api_compile -p 80:80 -p 443:443 -d luijo265/ubuntu_builder:api_1.0
```
Para poder ingresar en el bash del contenedor
```bash
docker exec -it api_compile /bin/bash
```

<div id="id3"></div>

## Configuración de virtual host

Ver el siguiente documento [dk.agileteams.local.conf](./build/dk.agileteams.local.conf)

<div id="id4"></div>

## Enlazar configuración virtual host a maquina anfitrión

```bash
docker run --name api_compile -p 80:80 -p 443:443\
    -v /patch_your_config/dk.agileteams.local.conf:/etc/apache2/sites-available/dk.agileteams.local.conf\
    -d luijo265/ubuntu_builder:api_1.0
```

<div id="id5"></div>

## Enlazar contenido del proyecto maquina anfitrión

```bash
docker run --name api_compile -p 80:80 -p 443:443\
    -v /patch_your_project/gf-atsuite-backend:/var/www/gf-atsuite-backend\
    -d luijo265/ubuntu_builder:api_1.0
```

