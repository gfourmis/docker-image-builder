# Docker Backend Agile Teams (ubuntu_api)

Contiene configuración e instalación de PHP 7.1, Apache2 en modo prefork (El por defecto).

**Lista general de paquetes instalados:**
- git
- php 7.1
- tzdata
- apache2

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

