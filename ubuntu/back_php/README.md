# Docker Backend Agile Teams (ubuntu_back)

Contiene configuración e instalación de PHP 7.1, Apache2 en modo prefork (El por defecto).

**Lista general de paquetes instalados:**
- git
- php 7.1
- tzdata

## Para compilar y ejecutar

Colocarse dentro del directorio build
```bash
cd build
```
Ejecutar lo siguiente, cambiando "ubuntu_back" por el preferido, y la versión deseada
```bash
docker build -t ubuntu_back:1.0 .
```
Luego para ejecutar como demonio o servicio de linux con docker. Se puede establecer cualquier otro nombre en "php_compile" y cuidar que se escriba el "ubuntu_back" y versión correctas.
```bash
docker run --name php_compile -it ubuntu_back:1.0
```
Para poder ingresar en el bash del contenedor
```bash
docker exec -it php_compile
```

