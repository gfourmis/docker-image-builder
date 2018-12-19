# Docker Backend Agile Teams (ubuntu_flask)

Contiene configuración e instalación de Python 3.7, Framework Flask.

**Lista general de paquetes instalados:**
- python
- Flask
- Pandas
- Numpy
- Pylot
- Sklearn
- Seaborn

## **Imagen en docker hub**

Para ejecutar como demonio o servicio de linux con docker, solo de prueba del servicio. Se puede establecer cualquier otro nombre en "flask_at"
```bash
docker run --name flask_at -p 5000:5000 -d luijo265/ubuntu_builder:flask_1.0
```
Para agregar el código, copiar la carpeta "app" al directorio host. Sustituir "path_app" con la ruta de la carpeta anteriormente copiada
```bash
docker run --name flask_at -p 5000:5000 -v /path_app/app:/opt/app -d luijo265/ubuntu_builder:flask_1.0
```
Para poder ingresar en el bash del contenedor
```bash
docker exec -it flask_at /bin/bash
```

## **Para compilar y ejecutar**

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
Para poder editar el código. Copiar la carpeta app a un directorio requerido para poder sobre este archivo.
```bash
docker run --name flask_at -p 5000:5000 -v /path_app/app:/opt/app -d ubuntu_flask:1.0
```
Para solo poder acceder a las graficas en formato png.
```bash
docker run --name flask_at -p 5000:5000 -v /path_app/app/graphical:/opt/app/graphical -d ubuntu_flask:1.0
```
Para poder ingresar en el bash del contenedor
```bash
docker exec -it flask_at /bin/bash
```

## **Realizar pruebas**

### Comprobar desde el navegador colocando http://ip_dominio_host:5000/, tendrá una salida como esta:
``` text
Welcome Python 3.7 & Flask
```
### Comprobar la creación de la gráfica con:

    Método: POST
    URL: http://192.168.1.130:5000/regrlineal
    body: {
        "fullname":"Felipe Rojas",
        "email" : "frojas@gfourmis.com"
    }

 ### Todas las imagenes .png quedan guardadas en el directorio "app/graphical/" y el nombre del documento se contruye con el lado izquierdo de la dirección de correo concatenado con la fecha, ver el siguiente ejemplo:

    email: admin@correo.local
    fecha de hoy: 2018-12-19

    Nombre final: admin2018-12-19.png

### Estructura del body en la paetición
``` json
{
    "fullname":"Nombre que saldra encima de la gráfica",
    "email" : "email de donde se obtendra los datos del archivo .csv",
    "url" : "Directorio donde se ubica el archivo csv",
    "module": "Que modulo se tomará el análisis para la línea de tendencia. Las opciones son: 'tasktimes','tasks','projects','total'." 
}
```
