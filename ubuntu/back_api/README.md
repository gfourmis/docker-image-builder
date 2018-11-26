# Docker Backend Agile Teams (back_api)

Contiene configuración e instalación de PHP 7.1, Apache2 en modo prefork (El por defecto).

**Lista general de paquetes instalados:**
- git
- php 7.1
- tzdata
- apache2

## Para compilar y ejecutar

Colocarse dentro del directorio build
```
cd build
```
Ejecutar lo siguiente, se puede cambiar "back_api" por el preferido, y la versión deseada
```
docker build -t back_api:1.0 .
```
Luego para ejecutar como demonio o servicio de linux con docker. Se puede establecer cualquier otro nombre en "api_compile" y cuidar que se escriba el "back_api" y versión correctas.
```
docker run --name api_compile -p 80:80 -p 443:443 -d back_api:1.0
```
Para poder ingresar en el bash del contenedor
```
docker exec -it api_compile /bin/bash
```

