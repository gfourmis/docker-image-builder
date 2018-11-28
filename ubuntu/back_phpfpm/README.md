# Docker Backend Agile Teams (ubuntu_phpfpm)

Contiene configuración e instalación de PHP-FPM 7.1 source, Apache2 en modo event.

**Lista general de paquetes instalados:**
- git
- phpfpm 7.1
- apache2

## Para compilar y ejecutar

Colocarse dentro del directorio build
```bash
cd build
```
Ejecutar lo siguiente, se puede cambiar "ubuntu_phpfpm" por el preferido, y la versión deseada
```bash
docker build -t ubuntu_phpfpm:1.0 .
```
Luego para ejecutar como demonio o servicio de linux con docker. Se puede establecer cualquier otro nombre en "phpfpm_compile" y cuidar que se escriba el "ubuntu_phpfpm" y versión correctas.
```bash
docker run -p 80:80 -p 443:443 \
	--name compile_phpfpm \
    -v /build/dk.agileteams.local.conf:/etc/apache2/sites-available/dk.agileteams.local.conf \
    -v /build/php.ini:/etc/php7/cli/php.ini \
    -v /build/php-cli.ini:/etc/php7/cli/php-cli.ini \
    -v /build/php-fpm.conf:/etc/php7/etc/php-fpm.conf \
    -v /build/www.conf:/etc/php7/etc/php-fpm.d/www.conf \
    -v /build/mpm-event.conf:/etc/apache2/mods-enabled/mpm-event.conf \
    -d phpfpm_compile:1.0
```
Para poder ingresar en el bash del contenedor
```bash
docker exec -it phpfpm_compile /bin/bash
```
Al estar en modo event con phpfpm se debe hacer las configuraciones optimas del mismo. Revisar la documentacion **configurar phpfpm y apache2-event.md** en el directorio guide
Para conocer cuanto consumen los procesos, ejecutar lo siguiente dentro del contenedor
```bash
python /ps_mem.py
```

