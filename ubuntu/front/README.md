# Docker Frontend Agile Teams (ubuntu_front)

Contiene configuración e instalación de PHP 7.1, Apache2 en modo prefork (El por defecto).

**Lista general de paquetes instalados:**
- git
- curl
- ndoejs

## Para compilar y ejecutar

Colocarse dentro del directorio build
```bash
cd build
```
Ejecutar lo siguiente, se puede cambiar "ubuntu_front" por el preferido, y la versión deseada
```bash
docker build -t ubuntu_front:1.0 .
```
Luego para ejecutar como demonio o servicio de linux con docker. Se puede establecer cualquier otro nombre en "front_compile" y cuidar que se escriba el "ubuntu_front" y versión correctas.
```bash
docker run --name front_compile -it ubuntu_front:1.0
```
Para poder ingresar en el bash del contenedor
```bash
docker exec -it front_compile
```

