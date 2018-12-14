# Docker Backend Agile Teams (ubuntu_flask)

Contiene configuración e instalación de Python 3., Framework Flask.

**Lista general de paquetes instalados:**
- python
- Flask

## Para compilar y ejecutar

Colocarse dentro del directorio build
```bash
cd build
```
Ejecutar lo siguiente, se puede cambiar "ubuntu_flask" por el preferido, y la versión deseada
```bash
docker build -t ubuntu_flask:1.0 .
```
Luego para ejecutar como demonio o servicio de linux con docker. Se puede establecer cualquier otro nombre en "flask_at" y cuidar que se escriba el "ubuntu_flask" y versión correctas.
```bash
docker run --name flask_at -p 5000:5000 -d ubuntu_flask:1.0
```
Para poder ingresar en el bash del contenedor
```bash
docker exec -it flask_at /bin/bash
```

